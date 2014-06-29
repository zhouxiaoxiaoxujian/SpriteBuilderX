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
    kFCImageFormatOriginal = 0,
    kFCImageFormatPNG = 1,
    kFCImageFormatPNG_8BIT = 2,
    kFCImageFormatPVR_RGBA8888 = 3,
    kFCImageFormatPVR_RGBA4444 = 4,
    kFCImageFormatPVR_RGB565 = 5,
    kFCImageFormatPVRTC_4BPP = 6,
    kFCImageFormatPVRTC_2BPP = 7,
    kFCImageFormatWEBP = 8,
    kFCImageFormatJPG_High = 9,
    kFCImageFormatJPG_Medium = 10,
    kFCImageFormatJPG_Low = 11,
} kFCImageFormat;

typedef enum {
    kFCSoundFormatWAV = 0,
    kFCSoundFormatCAF = 1,
    kFCSoundFormatMP4 = 2,
    kFCSoundFormatOGG = 3,
} kFCSoundFormat;

@interface FCFormatConverter : NSObject

+ (FCFormatConverter*) defaultConverter;

- (NSString*) proposedNameForConvertedImageAtPath:(NSString*)srcPath format:(int)format compress:(BOOL)compress isSpriteSheet:(BOOL)isSpriteSheet;

-(BOOL)convertImageAtPath:(NSString*)srcPath
                   format:(int)format
                   dither:(BOOL)dither
                 compress:(BOOL)compress
            isSpriteSheet:(BOOL)isSpriteSheet
           outputFilename:(NSString**)outputFilename
                    error:(NSError**)error;

- (void)cancel;

- (NSString*) proposedNameForConvertedSoundAtPath:(NSString*)srcPath format:(int)format quality:(int)quality;
- (NSString*) convertSoundAtPath:(NSString*)srcPath format:(int)format quality:(int)quality;

@end
