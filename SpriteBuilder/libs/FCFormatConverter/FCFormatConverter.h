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
    
    kFCImageFormatWEBP = 2,
    kFCImageFormatWEBP_LOSSY = 3,
    
    kFCImageFormatJPG = 4,
    
    kFCImageFormatPVR_RGBA8888 = 5,
    kFCImageFormatPVR_RGBA4444 = 6,
    kFCImageFormatPVR_RGB888 = 7,
    kFCImageFormatPVR_RGB565 = 8,
    kFCImageFormatPVRTC_4BPP = 9,
    kFCImageFormatPVRTC_2BPP = 10,
    kFCImageFormatPVRTC2_4BPP = 11,
    kFCImageFormatPVRTC2_2BPP = 12,
    
    kFCImageFormatETC = 13,
    kFCImageFormatETC_ALPHA = 14,
    
    kFCImageFormatETC2_RGB8 = 15,
    kFCImageFormatETC2_RGBA8 = 16,
    kFCImageFormatETC2_RGB8A1 = 17,
    
    kFCImageFormatDXT1 = 18,
    kFCImageFormatDXT2 = 19,
    kFCImageFormatDXT3 = 20,
    kFCImageFormatDXT4 = 21,
    kFCImageFormatDXT5 = 22,
    
    kFCImageFormatATC_RGB = 23,
    kFCImageFormatATC_EXPLICIT_ALPHA = 24,
    kFCImageFormatATC_INTERPOLATED_ALPHA = 25
} kFCImageFormat;

typedef enum {
    kFCSoundFormatWAV = 0,
    kFCSoundFormatCAF = 1,
    kFCSoundFormatMP4 = 2,
    kFCSoundFormatOGG = 3,
    kFCSoundFormatMP3 = 4,
} kFCSoundFormat;

typedef enum {
    kFCSoundParamsMono11025,
    kFCSoundParamsMono22050,
    kFCSoundParamsMono32000,
    kFCSoundParamsMono44100,
    kFCSoundParamsMono48000,
    kFCSoundParamsStereo11025,
    kFCSoundParamsStereo22050,
    kFCSoundParamsStereo32000,
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
                isRelease:(BOOL)isRelease
           outputFilename:(NSString**)outputFilename
                    error:(NSError**)error;

- (void)cancel;

- (NSString*) proposedNameForConvertedSoundAtPath:(NSString*)srcPath format:(int)format quality:(int)quality;
- (NSString*) convertSoundAtPath:(NSString*)srcPath format:(int)format quality:(int)quality;

@end
