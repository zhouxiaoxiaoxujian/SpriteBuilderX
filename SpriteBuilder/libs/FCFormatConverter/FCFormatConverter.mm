//
//  FCFormatConverter.m
//  CocosBuilder
//
//  Created by Viktor on 6/27/13.
//
//

#import "FCFormatConverter.h"
#import "PVRTexture.h"
#import "PVRTextureUtilities.h"

static FCFormatConverter* gDefaultConverter = NULL;

static NSString * kErrorDomain = @"com.apportable.SpriteBuilder";

@interface FCFormatConverter ()

@property (nonatomic, strong) NSTask *pngQuantTask;
@property (nonatomic, strong) NSTask *zipTask;
@property (nonatomic, strong) NSTask *sndTask;
@property (nonatomic, strong) NSTask *webpTask;

@end

#define CC_SWAP( x, y )			\
({ __typeof__(x) temp  = (x);		\
x = y; y = temp;		\
})

static float clampf(float value, float min_inclusive, float max_inclusive)
{
    if (min_inclusive > max_inclusive) {
        CC_SWAP(min_inclusive,max_inclusive);
    }
    return value < min_inclusive ? min_inclusive : value < max_inclusive? value : max_inclusive;
}

@implementation FCFormatConverter

+ (FCFormatConverter*) defaultConverter
{
    if (!gDefaultConverter)
    {
        gDefaultConverter = [[FCFormatConverter alloc] init];
    }
    return gDefaultConverter;
}

- (NSString*) proposedNameForConvertedImageAtPath:(NSString*)srcPath format:(int)format compress:(BOOL)compress isSpriteSheet:(BOOL)isSpriteSheet
{
    if ( isSpriteSheet )
		{
		    // The name of a sprite in a spritesheet never changes.
		    return [srcPath copy];
		}
    if ( format == kFCImageFormatOriginal)
    {
        return [srcPath copy];
    }
    else if (format == kFCImageFormatPNG ||
        format == kFCImageFormatPNG_8BIT)
    {
        // File might be loaded from a .psd file.
        return [[srcPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"png"];
    }
    else if (format == kFCImageFormatPVR_RGBA8888 ||
             format == kFCImageFormatPVR_RGBA4444 ||
             format == kFCImageFormatPVR_RGB565 ||
             format == kFCImageFormatPVRTC_4BPP ||
             format == kFCImageFormatPVRTC_2BPP)
    {
        NSString* dstPath = [[srcPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"pvr"];
        if (compress) dstPath = [dstPath stringByAppendingPathExtension:@"ccz"];
        return dstPath;
    }
    else if (format == kFCImageFormatJPG)
    {
        NSString* dstPath = [[srcPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"];
        return dstPath;
    }
    else if (format == kFCImageFormatWEBP ||
             format == kFCImageFormatWEBP_LOSSY)
    {
        NSString* dstPath = [[srcPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"webp"];
        return dstPath;
    }
    return NULL;
}

-(BOOL)optimizePngAtPath:(NSString*)srcPath
{

    NSTask *task = [[NSTask alloc] init];
    NSString *pathToOptiPNG = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"optipng"];
    [task setLaunchPath:pathToOptiPNG];
    [task setArguments:@[srcPath]];

    // NSPipe *pipe = [NSPipe pipe];
    NSPipe *pipeErr = [NSPipe pipe];
    [task setStandardError:pipeErr];

    // [_task setStandardOutput:pipe];
    // NSFileHandle *file = [pipe fileHandleForReading];

    NSFileHandle *fileErr = [pipeErr fileHandleForReading];

    int status = 0;

    @try
    {
        [task launch];
        [task waitUntilExit];
        status = [task terminationStatus];
    }
    @catch (NSException *ex)
    {
        NSLog(@"[%@] %@", [self class], ex);
        return NO;
    }

    /*if (status)
    {
        NSData *data = [fileErr readDataToEndOfFile];
        NSString *stdErrOutput = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *warningDescription = [NSString stringWithFormat:@"optipng error: %@", stdErrOutput];
        [_warnings addWarningWithDescription:warningDescription];
    }*/
    return YES;
}

-(NSString*)compress:(NSString*)dstPath andDir:(NSString*)dstDir
{
    // Create compressed file (ccz)
    self.zipTask = [[NSTask alloc] init];
    [_zipTask setCurrentDirectoryPath:dstDir];
    [_zipTask setLaunchPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ccz"]];
    NSMutableArray* args = [NSMutableArray arrayWithObjects:dstPath, nil];
    [_zipTask setArguments:args];
    [_zipTask launch];
    [_zipTask waitUntilExit];
    self.zipTask = nil;
    
    // Remove uncompressed file
    [[NSFileManager defaultManager] removeItemAtPath:dstPath error:NULL];
    
    // Update name of texture file
    dstPath = [dstPath stringByAppendingPathExtension:@"ccz"];
    return dstPath;
}

-(BOOL)convertImageAtPath:(NSString*)srcPath
                   format:(int)format
                  quality:(int)quality
                   dither:(BOOL)dither
                 compress:(BOOL)compress
            isSpriteSheet:(BOOL)isSpriteSheet
                isRelease:(BOOL)isRelease
           outputFilename:(NSString**)outputFilename
                    error:(NSError**)error;
{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString* dstDir = [srcPath stringByDeletingLastPathComponent];
    
    // Convert PSD to PNG as a pre-step.
    // Unless the .psd is part of a spritesheet, then the original name has to be preserved.
    if ( [[srcPath pathExtension] isEqualToString:@"psd"] && !isSpriteSheet)
    {
        CGImageSourceRef image_source = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:srcPath], NULL);
        CGImageRef image = CGImageSourceCreateImageAtIndex(image_source, 0, NULL);

        NSString *out_path = [[srcPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"png"];
        CFURLRef out_url = (__bridge CFURLRef)[NSURL fileURLWithPath:out_path];
        CGImageDestinationRef image_destination = CGImageDestinationCreateWithURL(out_url, kUTTypePNG, 1, NULL);
        CGImageDestinationAddImage(image_destination, image, NULL);
        CGImageDestinationFinalize(image_destination);

        CFRelease(image_source);
        CGImageRelease(image);
        CFRelease(image_destination);

        [fm removeItemAtPath:srcPath error:nil];
        srcPath = out_path;
    }
		
    if ( format == kFCImageFormatOriginal)
    {
        *outputFilename = [srcPath copy];
        return YES;
    }
    else if (format == kFCImageFormatPNG)
    {
        // PNG image - no conversion required
        //*outputFilename = [srcPath copy];
        if([[srcPath pathExtension] isEqualToString:@"png"])
        {
            *outputFilename = [srcPath copy];
            if(!isSpriteSheet && isRelease)
                [self optimizePngAtPath:srcPath];
            return YES;
        }
        else
        {
            CGImageSourceRef image_source = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:srcPath], NULL);
            CGImageRef image = CGImageSourceCreateImageAtIndex(image_source, 0, NULL);
            
            NSString *out_path = [[srcPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"png"];
            CFURLRef out_url = (__bridge CFURLRef)[NSURL fileURLWithPath:out_path];
            CGImageDestinationRef image_destination = CGImageDestinationCreateWithURL(out_url, kUTTypePNG, 1, NULL);
            CGImageDestinationAddImage(image_destination, image, NULL);
            CGImageDestinationFinalize(image_destination);
            
            CFRelease(image_source);
            CGImageRelease(image);
            CFRelease(image_destination);
            
            [fm removeItemAtPath:srcPath error:nil];
            *outputFilename = out_path;
            if(!isSpriteSheet && isRelease)
                [self optimizePngAtPath:srcPath];
            return YES;
        }
    }
    if (format == kFCImageFormatPNG_8BIT)
    {
        // 8 bit PNG image
        self.pngQuantTask = [[NSTask alloc] init];
        [_pngQuantTask setLaunchPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pngquant"]];
        NSMutableArray* args = [NSMutableArray arrayWithObjects:
                                @"--force", @"--ext", @".png", srcPath, nil];
        if (dither) [args addObject:@"-dither"];
        [_pngQuantTask setArguments:args];
        [_pngQuantTask launch];
        [_pngQuantTask waitUntilExit];
        
        self.pngQuantTask = nil;
        if ([fm fileExistsAtPath:srcPath])
        {
            *outputFilename = [srcPath copy];
            if(!isSpriteSheet && isRelease)
                [self optimizePngAtPath:srcPath];
            return YES;
        }
    }
    else if (format == kFCImageFormatPVR_RGBA8888 ||
             format == kFCImageFormatPVR_RGBA4444 ||
             format == kFCImageFormatPVR_RGB565 ||
             format == kFCImageFormatPVRTC_4BPP ||
             format == kFCImageFormatPVRTC_2BPP)
    {
        // PVR(TC) image
        NSString *dstPath = [[srcPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"pvr"];
        
        pvrtexture::PixelType pixelType;
        EPVRTVariableType variableType = ePVRTVarTypeUnsignedByteNorm;
        
        if (format == kFCImageFormatPVR_RGBA8888)
        {
            pixelType = pvrtexture::PixelType('r','g','b','a',8,8,8,8);
        }
        else if (format == kFCImageFormatPVR_RGBA4444)
        {
            pixelType = pvrtexture::PixelType('r','g','b','a',4,4,4,4);
            variableType = ePVRTVarTypeUnsignedShortNorm;
        }
        else if (format == kFCImageFormatPVR_RGB888)
        {
            pixelType = pvrtexture::PixelType('r','g','b',0,8,8,8,0);
        }
        else if (format == kFCImageFormatPVR_RGB565)
        {
            pixelType = pvrtexture::PixelType('r','g','b',0,5,6,5,0);
            variableType = ePVRTVarTypeUnsignedShortNorm;
        }
        else if (format == kFCImageFormatPVRTC_4BPP)
        {
            pixelType = pvrtexture::PixelType(ePVRTPF_PVRTCI_4bpp_RGB);
        }
        else if (format == kFCImageFormatPVRTC_2BPP)
        {
            pixelType = pvrtexture::PixelType(ePVRTPF_PVRTCI_2bpp_RGB);
        }
        else if (format == kFCImageFormatPVRTC2_4BPP)
        {
            pixelType = pvrtexture::PixelType(ePVRTPF_PVRTCII_4bpp);
        }
        else if (format == kFCImageFormatPVRTC2_2BPP)
        {
            pixelType = pvrtexture::PixelType(ePVRTPF_PVRTCII_2bpp);
        }

        NSImage * image = [[NSImage alloc] initWithContentsOfFile:srcPath];
        NSBitmapImageRep* rawImg = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
        
        pvrtexture::CPVRTextureHeader header(pvrtexture::PVRStandard8PixelType.PixelTypeID, image.size.height , image.size.width);
        pvrtexture::CPVRTexture     * pvrTexture = new pvrtexture::CPVRTexture(header , rawImg.bitmapData);
        
        
        
        bool hasError = NO;
      
        
        if(!pvrtexture::PreMultiplyAlpha(*pvrTexture))
        {
            if (error)
			{
				NSString * errorMessage = [NSString stringWithFormat:@"Failure to premultiple alpha: %@", srcPath];
				NSDictionary * userInfo __attribute__((unused)) =@{NSLocalizedDescriptionKey:errorMessage};
				*error = [NSError errorWithDomain:kErrorDomain code:EPERM userInfo:userInfo];
			}
            hasError = YES;
        }
        
        if(!hasError && !pvrtexture::Flip(*pvrTexture, ePVRTAxisY))
        {
            if (error)
			{
				NSString * errorMessage = [NSString stringWithFormat:@"Failure to flip texture: %@", srcPath];
				NSDictionary * userInfo __attribute__((unused)) =@{NSLocalizedDescriptionKey:errorMessage};
				*error = [NSError errorWithDomain:kErrorDomain code:EPERM userInfo:userInfo];
			}
            hasError = YES;
        }
        
       
        if(!hasError && !Transcode(*pvrTexture, pixelType, variableType, ePVRTCSpacelRGB, pvrtexture::ePVRTCBest, dither))
        {
            if (error)
            {
                NSString * errorMessage = [NSString stringWithFormat:@"Failure to transcode image: %@", srcPath];
                NSDictionary * userInfo __attribute__((unused)) =@{NSLocalizedDescriptionKey:errorMessage};
                *error = [NSError errorWithDomain:kErrorDomain code:EPERM userInfo:userInfo];
            }
            hasError = YES;
        }
    
        
        if(!hasError)
        {
            CPVRTString filePath([dstPath UTF8String], dstPath.length);
            
            if(!pvrTexture->saveFile(filePath))
            {
				if (error)
				{
					NSString * errorMessage = [NSString stringWithFormat:@"Failure to save image: %@", dstPath];
					NSDictionary * userInfo __attribute__((unused)) =@{NSLocalizedDescriptionKey:errorMessage};
					*error = [NSError errorWithDomain:kErrorDomain code:EPERM userInfo:userInfo];
				}
                hasError = YES;
            }
        }
        
        // Remove PNG file
        [[NSFileManager defaultManager] removeItemAtPath:srcPath error:NULL];
        //Clean up memory.
        delete pvrTexture;
        
        if(hasError)
        {
            return NO;//return failure;
        }
        
        if (compress)
        {
            dstPath = [self compress:dstPath andDir:dstDir];
        }
        
        if ([fm fileExistsAtPath:dstPath])
        {
            *outputFilename = [dstPath copy];
            return YES;
        }
    }
    else if (format == kFCImageFormatJPG)
    {
        // JPG image format
        NSString* dstPath = [[srcPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"];
        
        // Set the compression factor
        float compressionFactor = clampf(quality / 100.0f, 0.f, 100.0f);
        
        NSDictionary* props = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:compressionFactor] forKey:NSImageCompressionFactor];
        
        // Convert the file
        NSBitmapImageRep* imageRep = [NSBitmapImageRep imageRepWithContentsOfFile:srcPath];
        NSData* imgData = [imageRep representationUsingType:NSJPEGFileType properties:props];
        
        if (![imgData writeToFile:dstPath atomically:YES]) return NULL;
        
        // Remove old file
        if (![srcPath isEqualToString:dstPath])
        {
            [fm removeItemAtPath:srcPath error:NULL];
        }
        
        *outputFilename = [dstPath copy];
        return YES;
        
    }
    else if (format == kFCImageFormatWEBP ||
             format == kFCImageFormatWEBP_LOSSY)
    {
        // JPG image format
        NSString* dstPath = [[srcPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"webp"];
        
        self.webpTask = [[NSTask alloc] init];
        [_webpTask setCurrentDirectoryPath:dstDir];
        [_webpTask setLaunchPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cwebp"]];
        NSMutableArray* args = nil;
        switch (format) {
            case kFCImageFormatWEBP:
                args = [NSMutableArray arrayWithObjects:srcPath, @"-lossless", @"-alpha_cleanup", @"-o", dstPath, nil];
                break;
                
            case kFCImageFormatWEBP_LOSSY:
                args = [NSMutableArray arrayWithObjects:srcPath, @"-q", [@(quality) stringValue], @"-alpha_cleanup", @"-o", dstPath, nil];
                break;
                
            default:
                break;
        }
        [_webpTask setArguments:args];
        [_webpTask launch];
        [_webpTask waitUntilExit];
        self.webpTask = nil;
        
        // Remove uncompressed file
        [[NSFileManager defaultManager] removeItemAtPath:srcPath error:NULL];
        
        *outputFilename = [dstPath copy];
        return YES;
        
    }
    
	// Conversion failed
	if(error != nil)
	{
		*error = [NSError errorWithDomain:kErrorDomain code:EPERM userInfo:@{NSLocalizedDescriptionKey:@"Unhandled format"}];
	}
	
	return NO;
}

- (NSString*) proposedNameForConvertedSoundAtPath:(NSString*)srcPath format:(int)format quality:(int)quality
{
    NSString* ext = NULL;
    if (format == kFCSoundFormatWAV) ext = @"wav";
    else if (format == kFCSoundFormatCAF) ext = @"caf";
    else if (format == kFCSoundFormatMP4) ext = @"m4a";
    else if (format == kFCSoundFormatOGG) ext = @"ogg";
    else if (format == kFCSoundFormatMP3) ext = @"mp3";
    
    if (ext)
    {
        return [[srcPath stringByDeletingPathExtension] stringByAppendingPathExtension:ext];
    }
    return NULL;
}

- (NSString*) afconvertDataFormatWithQuality:(int)quality prefix8Bit:(NSString*)prefix8Bit prefix16Bit:(NSString*)prefix16Bit
{
    switch (quality) {
        case 1:
            return [NSString stringWithFormat:@"%@@%@", prefix8Bit, @"11025"];
        case 2:
            return [NSString stringWithFormat:@"%@@%@", prefix8Bit, @"22050"];
        case 3:
            return [NSString stringWithFormat:@"%@@%@", prefix8Bit, @"32000"];
        case 4:
            return [NSString stringWithFormat:@"%@@%@", prefix8Bit, @"41000"];
        case 5:
            return [NSString stringWithFormat:@"%@@%@", prefix8Bit, @"48000"];
            
        case 6:
            return [NSString stringWithFormat:@"%@@%@", prefix16Bit, @"11025"];
        case 7:
            return [NSString stringWithFormat:@"%@@%@", prefix16Bit, @"22050"];
        case 8:
            return [NSString stringWithFormat:@"%@@%@", prefix16Bit, @"32000"];
        case 9:
            return [NSString stringWithFormat:@"%@@%@", prefix16Bit, @"44100"];
        case 10:
            return [NSString stringWithFormat:@"%@@%@", prefix16Bit, @"48000"];
        
        default:
            return [NSString stringWithFormat:@"%@@%@", prefix16Bit, @"22050"];
    }
}

- (NSString*) convertSoundAtPath:(NSString*)srcPath format:(int)format quality:(int)quality stereo:(BOOL)stereo;
{
    NSString* dstPath = [self proposedNameForConvertedSoundAtPath:srcPath format:format quality:quality];
    NSFileManager* fm = [NSFileManager defaultManager];
    
    if (format == kFCSoundFormatWAV)
    {
        // Convert to WAV
        NSTask* sndTask = [[NSTask alloc] init];
        
        NSString *qualityString = [self afconvertDataFormatWithQuality:quality prefix8Bit:@"UI8" prefix16Bit:@"LEI16"];
        
        [sndTask setLaunchPath:@"/usr/bin/afconvert"];
        NSMutableArray* args = [NSMutableArray arrayWithObjects:
                                @"-f", @"WAVE",
                                @"-d", qualityString, nil];
        if(!stereo)
        {
            [args addObject:@"-c"];
            [args addObject:@"1"];
        }
        [args addObject:srcPath];
        [args addObject:dstPath];
        
        [sndTask setArguments:args];
        [sndTask launch];
        [sndTask waitUntilExit];
        
        
        // Remove old file
        if (![srcPath isEqualToString:dstPath])
        {
            [fm removeItemAtPath:srcPath error:NULL];
        }
        
        return dstPath;
    }
    else if (format == kFCSoundFormatCAF)
    {
        // Convert to CAF
        self.sndTask = [[NSTask alloc] init];
        
        NSString *qualityString = [self afconvertDataFormatWithQuality:quality prefix8Bit:@"I8" prefix16Bit:@"LEI16"];
        
        [_sndTask setLaunchPath:@"/usr/bin/afconvert"];
        NSMutableArray* args = [NSMutableArray arrayWithObjects:
                                @"-f", @"caff",
                                @"-d", qualityString, nil];
        if(!stereo)
        {
            [args addObject:@"-c"];
            [args addObject:@"1"];
        }
        [args addObject:srcPath];
        [args addObject:dstPath];
        
        [_sndTask setArguments:args];
        [_sndTask launch];
        [_sndTask waitUntilExit];

        // Remove old file
        if (![srcPath isEqualToString:dstPath])
        {
            [fm removeItemAtPath:srcPath error:NULL];
        }

        self.sndTask = nil;
        return dstPath;
    }
    else if (format == kFCSoundFormatMP4)
    {
        // Convert to AAC
        
        //default value
        if(quality == -1)
            quality = 3;
        
        int qualityScaled = ((quality -1) * 127) / 9;//Quality [1,10]
        
        // Do the conversion
        self.sndTask = [[NSTask alloc] init];
        
        [_sndTask setLaunchPath:@"/usr/bin/afconvert"];
        NSMutableArray* args = [NSMutableArray arrayWithObjects:
                                @"-f", @"m4af",
                                @"-d", @"aac",
                                @"-u", @"pgcm", @"2",
                                @"-u", @"vbrq", [NSString stringWithFormat:@"%i",qualityScaled],
                                @"-q", @"127",
                                @"-s", @"3", nil];
        if(!stereo)
        {
            [args addObject:@"-c"];
            [args addObject:@"1"];
        }
        [args addObject:srcPath];
        [args addObject:dstPath];
        
        [_sndTask setArguments:args];
        [_sndTask launch];
        [_sndTask waitUntilExit];

        // Remove old file
        if (![srcPath isEqualToString:dstPath])
        {
            [fm removeItemAtPath:srcPath error:NULL];
        }

        self.sndTask = nil;
        return dstPath;
    }
    else if (format == kFCSoundFormatOGG)
    {
        // Convert to OGG

        if ([srcPath isEqualToString:dstPath])
        {
            // oggenc can't convert things in place, so make a copy that will get deleted at the end
            NSString *newSrcPath = [srcPath stringByAppendingPathExtension:@"orig"];
            [fm moveItemAtPath:srcPath toPath:newSrcPath error:NULL];
            srcPath = newSrcPath;
        }
        
        //default value
        if(quality == -1)
            quality = 3;

        self.sndTask = [[NSTask alloc] init];
        NSString *temp = [NSString stringWithFormat:@"%@.temp",dstPath];
        [_sndTask setLaunchPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"oggenc"]];
        NSMutableArray* args = [NSMutableArray arrayWithObjects:
                                [NSString stringWithFormat:@"-q%d", quality], nil];
        if(!stereo)
            [args addObject:@"--downmix"];
        [args addObject:@"-o"];
        [args addObject:temp];
        [args addObject:srcPath];
        
        [_sndTask setArguments:args];
        [_sndTask launch];
        [_sndTask waitUntilExit];

        // Remove old file
        if (![srcPath isEqualToString:temp])
        {
            [fm removeItemAtPath:srcPath error:NULL];
        }
        
        [fm moveItemAtPath:temp toPath:dstPath error:nil];

        self.sndTask = nil;
        return dstPath;
    }
    else if (format == kFCSoundFormatMP3)
    {
        // Convert to MP3
        
        if ([srcPath isEqualToString:dstPath])
        {
            // oggenc can't convert things in place, so make a copy that will get deleted at the end
            NSString *newSrcPath = [srcPath stringByAppendingPathExtension:@"orig"];
            [fm moveItemAtPath:srcPath toPath:newSrcPath error:NULL];
            srcPath = newSrcPath;
        }
        
        //default value
        if(quality == -1)
            quality = 4;
        
        self.sndTask = [[NSTask alloc] init];
        NSString *temp = [NSString stringWithFormat:@"%@.temp",dstPath];
        [_sndTask setLaunchPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"lame"]];
        NSMutableArray* args = [NSMutableArray arrayWithObjects:
                                @"-h",
                                [NSString stringWithFormat:@"-V%d", quality],
                                stereo?@"":@"-a",
                                srcPath, temp,
                                nil];
        [_sndTask setArguments:args];
        [_sndTask launch];
        [_sndTask waitUntilExit];
        
        // Remove old file
        if (![srcPath isEqualToString:temp])
        {
            [fm removeItemAtPath:srcPath error:NULL];
        }
        
        [fm moveItemAtPath:temp toPath:dstPath error:nil];
        
        self.sndTask = nil;
        return dstPath;
    }
    
    return NULL;
}

- (void)cancel
{
    @try
    {
        [_pngQuantTask terminate];
        [_zipTask terminate];
        [_sndTask  terminate];

        self.pngQuantTask = nil;
        self.zipTask = nil;
        self.sndTask = nil;
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception: %@", exception);
    }
}

@end
