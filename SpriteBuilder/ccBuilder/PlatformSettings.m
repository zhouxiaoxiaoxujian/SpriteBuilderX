//
//  PlatformSettings.m
//  SpriteBuilder
//
//  Created by Sergey on 22.05.16.
//
//

#import "PlatformSettings.h"
#import "ResourceManager.h"
#import "ResourceManager+Publishing.h"
#import "RMPackage.h"

@interface EnumTransformer: NSValueTransformer {}
@end
@implementation EnumTransformer
+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return YES; }
-(id)transformedValue:(id)value {
    return [NSNumber numberWithInteger:[value intValue]];
}
-(id)reverseTransformedValue:(id)value {
    return [NSNumber numberWithInteger:[value intValue]];
}
@end

@interface ImageFormatQulityEnabledTransformer: NSValueTransformer {}
@end
@implementation ImageFormatQulityEnabledTransformer
+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }
-(id)transformedValue:(id)value {
    switch ([value intValue]) {
        case kFCImageFormatWEBP:
        case kFCImageFormatWEBP_LOSSY:
        case kFCImageFormatJPG:
            return [NSNumber numberWithBool:YES];
            
        default:
            return [NSNumber numberWithBool:NO];
    }
}
@end

@interface ImageFormatDichterEnabledTransformer: NSValueTransformer {}
@end
@implementation ImageFormatDichterEnabledTransformer
+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }
-(id)transformedValue:(id)value {
    switch ([value intValue]) {
        case kFCImageFormatPNG_8BIT:
        case kFCImageFormatPVR_RGB565:
        case kFCImageFormatPVR_RGBA4444:
            return [NSNumber numberWithBool:YES];
            
        default:
            return [NSNumber numberWithBool:NO];
    }
}
@end

@interface ImageFormatCCZEnabledTransformer: NSValueTransformer {}
@end
@implementation ImageFormatCCZEnabledTransformer
+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }
-(id)transformedValue:(id)value {
    switch ([value intValue]) {
        case kFCImageFormatOriginal:
        case kFCImageFormatPNG:
        case kFCImageFormatPNG_8BIT:
        case kFCImageFormatWEBP:
        case kFCImageFormatWEBP_LOSSY:
        case kFCImageFormatJPG:
            return [NSNumber numberWithBool:NO];
            
        default:
            return [NSNumber numberWithBool:YES];
    }
}
@end

@interface PacketPublish : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL publish;
@property (nonatomic, assign) NSMutableArray *packets;
@end

@implementation PacketPublish
- (void) setPublish:(BOOL) value
{
    _publish = value;
    if(value)
    {
        if(![_packets containsObject:_name])
            [_packets addObject:_name];
    }
    else
    {
        if([_packets containsObject:_name])
            [_packets removeObject:_name];
    }
}
@end

@implementation PlatformSettings

- (NSArray*) packetsPublish
{
    NSMutableArray *ret = [NSMutableArray array];
    PacketPublish *mainPacket = [[PacketPublish alloc] init];
    mainPacket.name = @"Main";
    mainPacket.publish = [_packets containsObject:@"Main"];
    mainPacket.packets = _packets;
    [ret addObject:mainPacket];
    for (RMPackage *package in [[ResourceManager sharedManager] allPackages])
    {
        PacketPublish *packetPublish = [[PacketPublish alloc] init];
        packetPublish.name = package.name;
        packetPublish.publish = [_packets containsObject:packetPublish.name];
        packetPublish.packets = _packets;
        [ret addObject:packetPublish];
    }
    return ret;
}

- (id) serialize
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    dict[@"name"] = _name;
    
    dict[@"publishEnabled"] = @(_publishEnabled);
    dict[@"publishDirectory"] = _publishDirectory;
    
    dict[@"publish1x"] = @(_publish1x);
    dict[@"publish2x"] = @(_publish2x);
    dict[@"publish4x"] = @(_publish4x);
    
    dict[@"publishSound"] = @(_publishSound);
    dict[@"effectFormat"] = @(_effectFormat);
    dict[@"effectStereo"] = @(_effectStereo);
    dict[@"effectQuality"] = @(_effectQuality);
    dict[@"musicFormat"] = @(_musicFormat);
    dict[@"musicStereo"] = @(_musicStereo);
    dict[@"musicQuality"] = @(_musicQuality);
    dict[@"customSoundFormat"] = @(_customSoundFormat);
    dict[@"customSoundStereo"] = @(_customSoundStereo);
    dict[@"customSoundQuality"] = @(_customSoundQuality);
    
    dict[@"compressedImageFormat"] = @(_compressedImageFormat);
    dict[@"compressedImageQuality"] = @(_compressedImageQuality);
    dict[@"compressedImageCCZCompression"] = @(_compressedImageCCZCompression);
    dict[@"compressedImageDither"] = @(_compressedImageDither);

    dict[@"compressedNoAlphaImageFormat"] = @(_compressedNoAlphaImageFormat);
    dict[@"compressedNoAlphaImageQuality"] = @(_compressedNoAlphaImageQuality);
    dict[@"compressedNoAlphaImageCCZCompression"] = @(_compressedNoAlphaImageCCZCompression);
    dict[@"compressedNoAlphaImageDither"] = @(_compressedNoAlphaImageDither);
    
    dict[@"uncompressedImageFormat"] = @(_uncompressedImageFormat);
    dict[@"uncompressedImageQuality"] = @(_uncompressedImageQuality);
    dict[@"uncompressedImageCCZCompression"] = @(_uncompressedImageCCZCompression);
    dict[@"uncompressedImageDither"] = @(_uncompressedImageDither);
    
    dict[@"customImageFormat"] = @(_customImageFormat);
    dict[@"customImageQuality"] = @(_customImageQuality);
    dict[@"customImageCCZCompression"] = @(_customImageCCZCompression);
    dict[@"customImageDither"] = @(_customImageDither);
    
    dict[@"packets"] = _packets;
    
    return dict;
}

- (id) init
{
    self = [super init];
    if (!self)
    {
        return NULL;
    }
    _packets = [NSMutableArray array];
    _name = @"Empty";
    
    _publishEnabled = YES;
    _publishDirectory = @".";
    
    _publish1x = YES;
    _publish2x = YES;
    _publish4x = YES;
    
    _publishSound = YES;
    _effectFormat = kFCSoundFormatMP3;
    _effectStereo= YES;
    _effectQuality = 4;
    _musicFormat = kFCSoundFormatMP3;
    _musicStereo = YES;
    _musicQuality = 4;
    _customSoundFormat = kFCSoundFormatMP3;
    _customSoundStereo = YES;
    _customSoundQuality = 4;
    
    _compressedImageFormat = kFCImageFormatPNG;
    _compressedImageQuality = 75;
    _compressedImageCCZCompression = YES;
    _compressedImageDither = YES;
    
    _compressedNoAlphaImageFormat = kFCImageFormatPNG;
    _compressedNoAlphaImageQuality = 75;
    _compressedNoAlphaImageCCZCompression = YES;
    _compressedNoAlphaImageDither = YES;
    
    _uncompressedImageFormat = kFCImageFormatPNG;
    _uncompressedImageQuality = 75;
    _uncompressedImageCCZCompression = YES;
    _uncompressedImageDither = YES;
    
    _customImageFormat = kFCImageFormatPNG;
    _customImageQuality = 75;
    _customImageCCZCompression = YES;
    _customImageDither = YES;
    return self;
}

- (id) initWithSerialization:(id)dict
{
    self = [super init];
    if (!self)
    {
        return NULL;
    }
    
    _name = [dict objectForKey:@"name"];
    self.publishEnabled = [[dict objectForKey:@"publishEnabled"] boolValue];
    self.publishDirectory = [dict objectForKey:@"publishDirectory"];
    
    self.publish1x = [[dict objectForKey:@"publish1x"] boolValue];
    self.publish2x = [[dict objectForKey:@"publish2x"] boolValue];
    self.publish4x = [[dict objectForKey:@"publish4x"] boolValue];
    
    self.publishSound = [[dict objectForKey:@"publishSound"] boolValue];
    self.effectFormat = [[dict objectForKey:@"effectFormat"] intValue];
    self.effectStereo= [[dict objectForKey:@"effectStereo"] intValue];
    self.effectQuality = [[dict objectForKey:@"effectQuality"] intValue];
    self.musicFormat = [[dict objectForKey:@"musicFormat"] intValue];
    self.musicStereo = [[dict objectForKey:@"musicStereo"] intValue];
    self.musicQuality = [[dict objectForKey:@"musicQuality"] intValue];
    self.customSoundFormat = [[dict objectForKey:@"customSoundFormat"] intValue];
    self.customSoundStereo = [[dict objectForKey:@"customSoundStereo"] intValue];
    self.customSoundQuality = [[dict objectForKey:@"customSoundQuality"] intValue];
    
    self.compressedImageFormat = [[dict objectForKey:@"compressedImageFormat"] intValue];
    self.compressedImageQuality = [[dict objectForKey:@"compressedImageQuality"] intValue];
    self.compressedImageCCZCompression = [[dict objectForKey:@"compressedImageCCZCompression"] intValue];
    self.compressedImageDither = [[dict objectForKey:@"compressedImageDither"] intValue];
    
    self.compressedNoAlphaImageFormat = [[dict objectForKey:@"compressedNoAlphaImageFormat"] intValue];
    self.compressedNoAlphaImageQuality = [[dict objectForKey:@"compressedNoAlphaImageQuality"] intValue];
    self.compressedNoAlphaImageCCZCompression = [[dict objectForKey:@"compressedNoAlphaImageCCZCompression"] intValue];
    self.compressedNoAlphaImageDither = [[dict objectForKey:@"compressedNoAlphaImageDither"] intValue];
    
    self.uncompressedImageFormat = [[dict objectForKey:@"uncompressedImageFormat"] intValue];
    self.uncompressedImageQuality = [[dict objectForKey:@"uncompressedImageQuality"] intValue];
    self.uncompressedImageCCZCompression = [[dict objectForKey:@"uncompressedImageCCZCompression"] intValue];
    self.uncompressedImageDither = [[dict objectForKey:@"uncompressedImageDither"] intValue];
    
    self.customImageFormat = [[dict objectForKey:@"customImageFormat"] intValue];
    self.customImageQuality = [[dict objectForKey:@"customImageQuality"] intValue];
    self.customImageCCZCompression = [[dict objectForKey:@"customImageCCZCompression"] intValue];
    self.customImageDither = [[dict objectForKey:@"customImageDither"] intValue];
    
    self.packets = [dict objectForKey:@"packets"];
    if(!self.packets)
        self.packets = [NSMutableArray array];
    
    return self;
}

- (NSArray *)inputDirs
{
    NSMutableArray *inputDirs = [NSMutableArray array];
    
    if([_packets containsObject:@"Main"])
    {
        NSArray * oldResourcePaths = [[ResourceManager sharedManager] oldResourcePaths];
        for (RMDirectory *oldResourcePath in oldResourcePaths)
        {
            [inputDirs addObject:oldResourcePath.dirPath];
        }
    }
    
    for (RMPackage *package in [[ResourceManager sharedManager] allPackages])
    {
        if([_packets containsObject:package.name])
        {
            [inputDirs addObject:package.dirPath];
        }
    }
    return inputDirs;
}
- (kFCImageFormat) imageFormat:(int)type
{
    switch (type) {
        case kPlatformSettingsImageTypesCompressed:
            return _compressedImageFormat;
            
        case kPlatformSettingsImageTypesCompressedWOAlpha:
            return _compressedNoAlphaImageFormat;
            
        case kPlatformSettingsImageTypesUncompressed:
            return _uncompressedImageFormat;
            
        case kPlatformSettingsImageTypesCustom:
            return _customImageFormat;
            
        default:
            return kFCImageFormatOriginal;
    }
}
- (int) imageQuality:(int)type
{
    switch (type) {
        case kPlatformSettingsImageTypesCompressed:
            return _compressedImageQuality;
            
        case kPlatformSettingsImageTypesCompressedWOAlpha:
            return _compressedNoAlphaImageQuality;
            
        case kPlatformSettingsImageTypesUncompressed:
            return _uncompressedImageQuality;
            
        case kPlatformSettingsImageTypesCustom:
            return _customImageQuality;
            
        default:
            return 75;
    }
}

- (BOOL) imageCCZCompression:(int)type
{
    switch (type) {
        case kPlatformSettingsImageTypesCompressed:
            return _compressedImageCCZCompression;
            
        case kPlatformSettingsImageTypesCompressedWOAlpha:
            return _compressedNoAlphaImageCCZCompression;
            
        case kPlatformSettingsImageTypesUncompressed:
            return _uncompressedImageCCZCompression;
            
        case kPlatformSettingsImageTypesCustom:
            return _customImageCCZCompression;
            
        default:
            return YES;
    }
}

- (BOOL) imageDither:(int)type
{
    switch (type) {
        case kPlatformSettingsImageTypesCompressed:
            return _compressedImageDither;
            
        case kPlatformSettingsImageTypesCompressedWOAlpha:
            return _compressedNoAlphaImageDither;
            
        case kPlatformSettingsImageTypesUncompressed:
            return _uncompressedImageDither;
            
        case kPlatformSettingsImageTypesCustom:
            return _customImageDither;
            
        default:
            return YES;
    }
}


- (kFCSoundFormat) soundFormat:(int)type
{
    switch (type) {
        case kPlatformSettingsSoundTypesEffect:
            return _effectFormat;
            
        case kPlatformSettingsSoundTypesMusic:
            return _musicFormat;
            
        case kPlatformSettingsSoundTypesCustom:
            return _customSoundFormat;
            
        default:
            return YES;
    }
}

- (BOOL) soundStereo:(int)type
{
    switch (type) {
        case kPlatformSettingsSoundTypesEffect:
            return _effectStereo;
            
        case kPlatformSettingsSoundTypesMusic:
            return _musicStereo;
            
        case kPlatformSettingsSoundTypesCustom:
            return _customSoundStereo;
            
        default:
            return YES;
    }
}
- (int) soundQuality:(int)type
{
    switch (type) {
        case kPlatformSettingsSoundTypesEffect:
            return _effectQuality;
            
        case kPlatformSettingsSoundTypesMusic:
            return _musicQuality;
            
        case kPlatformSettingsSoundTypesCustom:
            return _customSoundQuality;
            
        default:
            return 4;
    }
}

@end
