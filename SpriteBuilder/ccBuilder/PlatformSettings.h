//
//  PlatformSettings.h
//  SpriteBuilder
//
//  Created by Sergey on 22.05.16.
//
//

#import <Foundation/Foundation.h>
#import "FCFormatConverter.h"

@interface PlatformSettings : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString* publishDirectory;
@property (nonatomic, assign) BOOL publishEnabled;
@property (nonatomic, assign) BOOL publish1x;
@property (nonatomic, assign) BOOL publish2x;
@property (nonatomic, assign) BOOL publish4x;

@property (nonatomic, assign) kFCImageFormat compressedImageFormat;
@property (nonatomic, assign) int compressedImageQuality;
@property (nonatomic, assign) kFCImageFormat compressedNoAlphaImageFormat;
@property (nonatomic, assign) int compressedNoAlphaImageQuality;
@property (nonatomic, assign) kFCImageFormat uncompressedImageFormat;
@property (nonatomic, assign) int uncompressedImageQuality;
@property (nonatomic, assign) kFCImageFormat customImageFormat;
@property (nonatomic, assign) int customImageQuality;

@property (nonatomic, assign) BOOL publishSound;
@property (nonatomic, assign) kFCSoundFormat effectFormat;
@property (nonatomic, assign) kFCSoundParams effectParams;
@property (nonatomic, assign) int effectQuality;
@property (nonatomic, assign) kFCSoundFormat musicFormat;
@property (nonatomic, assign) kFCSoundParams musicParams;
@property (nonatomic, assign) int musicQuality;
@property (nonatomic, assign) kFCSoundFormat customSoundFormat;
@property (nonatomic, assign) kFCSoundParams customSoundParams;
@property (nonatomic, assign) int customSoundQuality;
@property (nonatomic, retain) NSMutableArray *packets;
@property (nonatomic, retain, readonly) NSArray *packetsPublish;


- (id) initWithSerialization:(id)dict;
- (id) init;

- (id) serialize;
@end
