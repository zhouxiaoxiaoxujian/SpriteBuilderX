//
//  PreviewSpriteSheetViewController.m
//  SpriteBuilder
//
//  Created by Nicky Weber on 26.08.14.
//
//

#import "PreviewBaseViewController.h"
#import "PreviewSpriteSheetViewController.h"
#import "RMResource.h"
#import "ProjectSettings.h"
#import "MiscConstants.h"
#import "CCBImageView.h"
#import "ImageFormatAndPropertiesHelper.h"
#import "ResourcePropertyKeys.h"
#import "SettingsManager.h"

@implementation PreviewSpriteSheetViewController

- (void)setPreviewedResource:(RMResource *)previewedResource projectSettings:(ProjectSettings *)projectSettings
{
    self.projectSettings = projectSettings;
    self.previewedResource = previewedResource;

    [self populateInitialValues];
}

- (void)populateInitialValues
{
    __weak PreviewSpriteSheetViewController *weakSelf = self;
    [self setInitialValues:^{

        weakSelf.format = [[weakSelf.projectSettings propertyForResource:weakSelf.previewedResource andKey:RESOURCE_PROPERTY_IMAGE_FORMAT] intValue];

        weakSelf.trimSprites = [[weakSelf.projectSettings propertyForResource:weakSelf.previewedResource andKey:RESOURCE_PROPERTY_TRIM_SPRITES] boolValue];
        
        weakSelf.format_padding = [[weakSelf.projectSettings propertyForResource:weakSelf.previewedResource andKey:RESOURCE_PROPERTY_FORMAT_PADDING] integerValue];
        weakSelf.format_extrude = [[weakSelf.projectSettings propertyForResource:weakSelf.previewedResource andKey:RESOURCE_PROPERTY_FORMAT_EXTRUDE] integerValue];
    }];

    NSString *filePath = [SBSettings miscFilesPathForFile:_previewedResource.filePath];
    NSString *imgPreviewPath = [filePath stringByAppendingPathExtension:PNG_PREVIEW_IMAGE_SUFFIX];
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:imgPreviewPath];
    if (!img)
    {
        img = [NSImage imageNamed:@"ui-nopreview.png"];
    }

    [_previewSpriteSheet setImage:img];
}

- (void) setFormat:(int)format
{
    BOOL changed = _format != format;
    _format = format;
    if(changed)
        [self setValue:@(format) withName:RESOURCE_PROPERTY_IMAGE_FORMAT isAudio:NO];
}

- (void) setTrimSprites:(BOOL) trimSprites
{
    BOOL changed = _trimSprites != trimSprites;
    _trimSprites = trimSprites;
    if(changed)
        [self setValue:@(trimSprites) withName:RESOURCE_PROPERTY_TRIM_SPRITES isAudio:NO];
}

- (void) setFormat_padding:(int) format_padding
{
    BOOL changed = _format_padding != format_padding;
    _format_padding = format_padding;
    if(changed)
        [self setValue:@(format_padding) withName:RESOURCE_PROPERTY_FORMAT_PADDING isAudio:NO];
}

- (void) setFormat_extrude:(int) format_extrude
{
    BOOL changed = _format_extrude != format_extrude;
    _format_extrude = format_extrude;
    if(changed)
        [self setValue:@(format_extrude) withName:RESOURCE_PROPERTY_FORMAT_EXTRUDE isAudio:NO];
}

@end
