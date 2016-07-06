//
//  PlatformSettings.m
//  SpriteBuilder
//
//  Created by Sergey on 22.05.16.
//
//

#import "PlatformSettings.h"

@implementation PlatformSettings

- (NSString *)name
{
    return @"test";
}

- (BOOL) store
{
    return YES;
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
    dict[@"effectParams"] = @(_effectParams);
    dict[@"effectQuality"] = @(_effectQuality);
    dict[@"musicFormat"] = @(_musicFormat);
    dict[@"musicParams"] = @(_musicParams);
    dict[@"musicQuality"] = @(_musicQuality);
    dict[@"customSoundFormat"] = @(_customSoundFormat);
    dict[@"customSoundParams"] = @(_customSoundParams);
    dict[@"customSoundQuality"] = @(_customSoundQuality);
    
    dict[@"compressedImageFormat"] = @(_compressedImageFormat);
    dict[@"compressedImageQuality"] = @(_compressedImageQuality);
    dict[@"compressedNoAlphaImageFormat"] = @(_compressedNoAlphaImageFormat);
    dict[@"compressedNoAlphaImageQuality"] = @(_compressedNoAlphaImageQuality);
    dict[@"uncompressedImageFormat"] = @(_uncompressedImageFormat);
    dict[@"uncompressedImageQuality"] = @(_uncompressedImageQuality);
    dict[@"customImageFormat"] = @(_customImageFormat);
    dict[@"customImageQuality"] = @(_customImageQuality);
    dict[@"packets"] = _packets;
    
    return dict;
}

- (id) initWithSerialization:(id)dict
{
    self = [self init];
    if (!self)
    {
        return NULL;
    }
    
    _name = [dict objectForKey:@"name"];
    self.publishEnabled = [[dict objectForKey:@"platformName"] boolValue];
    self.publishDirectory = [dict objectForKey:@"publishDirectory"];
    
    self.publish1x = [[dict objectForKey:@"publish1x"] boolValue];
    self.publish2x = [[dict objectForKey:@"publish2x"] boolValue];
    self.publish4x = [[dict objectForKey:@"publish4x"] boolValue];
    
    self.publishSound = [[dict objectForKey:@"publishSound"] boolValue];
    self.effectFormat = [[dict objectForKey:@"effectFormat"] intValue];
    self.effectParams= [[dict objectForKey:@"effectParams"] intValue];
    self.effectQuality = [[dict objectForKey:@"effectQuality"] intValue];
    self.musicFormat = [[dict objectForKey:@"musicFormat"] intValue];
    self.musicParams = [[dict objectForKey:@"musicParams"] intValue];
    self.musicQuality = [[dict objectForKey:@"musicQuality"] intValue];
    self.customSoundFormat = [[dict objectForKey:@"customSoundFormat"] intValue];
    self.customSoundParams = [[dict objectForKey:@"customSoundParams"] intValue];
    self.customSoundQuality = [[dict objectForKey:@"customSoundQuality"] intValue];
    
    self.compressedImageFormat = [[dict objectForKey:@"compressedImageFormat"] intValue];
    self.compressedImageQuality = [[dict objectForKey:@"compressedImageQuality"] intValue];
    self.compressedNoAlphaImageFormat = [[dict objectForKey:@"compressedImageFormat"] intValue];
    self.compressedNoAlphaImageQuality = [[dict objectForKey:@"compressedImageQuality"] intValue];
    self.uncompressedImageFormat = [[dict objectForKey:@"uncompressedImageFormat"] intValue];
    self.uncompressedImageQuality = [[dict objectForKey:@"uncompressedImageQuality"] intValue];
    self.customImageFormat = [[dict objectForKey:@"customImageFormat"] intValue];
    self.customImageQuality = [[dict objectForKey:@"customImageQuality"] intValue];
    self.packets = [dict objectForKey:@"packets"];
    if(!self.packets)
        self.packets = [NSMutableArray array];
    
    return self;
}

- (id) init
{
    self = [self init];
    if (!self)
    {
        return NULL;
    }
    return self;
}

@end
