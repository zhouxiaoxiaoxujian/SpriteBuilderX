//
//  FCFormatConverter.h
//  CocosBuilder
//
//  Created by Viktor on 6/27/13.
//
//

#import <Foundation/Foundation.h>

// Please keep explicit value assignments: order is irrelevant and new enum entries can be safely added/removed.
// Persistency is depending on these values.
typedef enum {
    kFCImageFormatOriginal = -1,
    kFCImageFormatPNG = 0,
    kFCImageFormatPNG_8BIT = 1,
    kFCImageFormatPVR_RGBA8888 = 2,
    kFCImageFormatPVR_RGBA4444 = 3,
    kFCImageFormatPVR_RGB565 = 4,
    kFCImageFormatPVRTC_4BPP = 5,
    kFCImageFormatPVRTC_2BPP = 6,
    kFCImageFormatWEBP = 7,
    kFCImageFormatWEBP_LOSSY = 8,
    kFCImageFormatJPG = 9,
    kFCImageFormatDXT1 = 10,
    kFCImageFormatDXT2 = 11,
    kFCImageFormatDXT3 = 12,
    kFCImageFormatDXT4 = 13,
    kFCImageFormatDXT5 = 14,
    kFCImageFormatATC_RGB = 12,
    kFCImageFormatATC_EXPLICIT_ALPHA = 13,
    kFCImageFormatATC_INTERPOLATED_ALPHA = 14
} kFCImageFormat;

typedef enum {
    kFCSoundFormatCAF = 0,
    kFCSoundFormatMP4 = 1,
    kFCSoundFormatOGG = 2,
    kFCSoundFormatWAV = 3,
    kFCSoundFormatMP3 = 4,
} kFCSoundFormat;

typedef enum {
    kFCSoundParamsMono11025,
    kFCSoundParamsMono22050,
    kFCSoundParamsMono44100,
    kFCSoundParamsMono48000,
    kFCSoundParamsStereo11025,
    kFCSoundParamsStereo22050,
    kFCSoundParamsStereo44100,
    kFCSoundParamsStereo48000,
} kFCSoundParams;

@interface FCFormatConverter : NSObject

+ (FCFormatConverter*) defaultConverter;

- (NSString*) proposedNameForConvertedImageAtPath:(NSString*)srcPath format:(int)format compress:(BOOL)compress isSpriteSheet:(BOOL)isSpriteSheet;

-(BOOL)convertImageAtPath:(NSString*)srcPath
                   format:(int)format
                  quality:(int)quality
                   dither:(BOOL)dither
                 compress:(BOOL)compress
            isSpriteSheet:(BOOL)isSpriteSheet
           outputFilename:(NSString**)outputFilename
                    error:(NSError**)error;

- (void)cancel;

- (NSString*) proposedNameForConvertedSoundAtPath:(NSString*)srcPath format:(int)format quality:(int)quality;
- (NSString*) convertSoundAtPath:(NSString*)srcPath format:(int)format quality:(int)quality;

@end
