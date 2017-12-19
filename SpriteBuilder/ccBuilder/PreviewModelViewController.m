//
//  PreviewModelViewController.m
//  SpriteBuilder
//
//  Created by Sergey Perepelitsa on 19.12.17.
//
//

#import "PreviewModelViewController.h"
#import "RMResource.h"
#import "ProjectSettings.h"
#import "ResourcePropertyKeys.h"

@interface PreviewModelViewController ()

@end


@implementation PreviewModelViewController

- (void)setPreviewedResource:(RMResource *)previewedResource projectSettings:(ProjectSettings *)projectSettings
{
    // Nothing to show at the moment, maybe a file icon?
    self.projectSettings = projectSettings;
    self.previewedResource = previewedResource;
    
    [self populateInitialValues];
}

- (void)populateInitialValues
{
    __weak PreviewModelViewController *weakSelf = self;
    [self setInitialValues:^{
        
        weakSelf.skip_normals = [[weakSelf.projectSettings propertyForResource:weakSelf.previewedResource andKey:RESOURCE_PROPERTY_MODEL_SKIP_NORMALS] intValue];
        weakSelf.format_model = [[weakSelf.projectSettings propertyForResource:weakSelf.previewedResource andKey:RESOURCE_PROPERTY_MODEL_FORMAT] intValue];
    }];
}

- (void)setFormat_model:(int)format_model
{
    _format_model = format_model;
    [self setValue:@(format_model) withName:RESOURCE_PROPERTY_MODEL_FORMAT isAudio:NO];
}

- (void) setSkip_normals:(BOOL)skip
{
    _skip_normals = skip;
    [self setValue:@(skip) withName:RESOURCE_PROPERTY_MODEL_SKIP_NORMALS isAudio:NO];
}

@end
