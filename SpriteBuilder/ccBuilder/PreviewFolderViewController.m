//
//  PreviewGenericViewController.m
//  SpriteBuilder
//
//  Created by Nicky Weber on 26.08.14.
//
//

#import "PreviewFolderViewController.h"
#import "RMResource.h"
#import "ProjectSettings.h"
#import "ResourcePropertyKeys.h"

@interface PreviewFolderViewController ()

@end


@implementation PreviewFolderViewController

- (void)setPreviewedResource:(RMResource *)previewedResource projectSettings:(ProjectSettings *)projectSettings
{
    // Nothing to show at the moment, maybe a file icon?
    self.projectSettings = projectSettings;
    self.previewedResource = previewedResource;
    
    [self populateInitialValues];
}

- (void)populateInitialValues
{
    __weak PreviewFolderViewController *weakSelf = self;
    [self setInitialValues:^{
        
        weakSelf.skip = [[weakSelf.projectSettings propertyForResource:weakSelf.previewedResource andKey:RESOURCE_PROPERTY_IS_SKIPDIRECTORY] intValue];
    }];
}

- (void) setSkip:(BOOL)skip
{
    _skip = skip;
    [self setValue:@(skip) withName:RESOURCE_PROPERTY_IS_SKIPDIRECTORY isAudio:NO];
}

@end
