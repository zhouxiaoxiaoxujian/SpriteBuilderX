//
//  PreviewCCBViewController.m
//  SpriteBuilder
//
//  Created by Nicky Weber on 27.08.14.
//
//

#import "PreviewViewControllerProtocol.h"
#import "PreviewCCBViewController.h"
#import "RMResource.h"
#import "ProjectSettings.h"
#import "MiscConstants.h"
#import "SettingsManager.h"
#import "ResourcePropertyKeys.h"
#import "ResourceManagerOutlineView.h"
#import "AppDelegate.h"

@implementation PreviewCCBViewController

- (void)setPreviewedResource:(RMResource *)previewedResource projectSettings:(ProjectSettings *)projectSettings {
    self.projectSettings = projectSettings;
    self.previewedResource = previewedResource;
    
    NSString *filePath = [SBSettings miscFilesPathForFile:previewedResource.filePath projectPathDir:projectSettings.projectPathDir];
    NSString *imgPreviewPath = [filePath stringByAppendingPathExtension:MISC_FILE_PPNG];
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:imgPreviewPath];
    if (!img)
    {
       img = [NSImage imageNamed:@"ui-nopreview.png"];
    }

    [_ccbPreviewImageView setImage:img];
    [self populateInitialValues];
}

-(void)populateInitialValues {
    __weak PreviewCCBViewController *weakSelf = self;
    [self setInitialValues:^{
        weakSelf.ccbType = [[weakSelf.projectSettings propertyForResource:weakSelf.previewedResource
                                                                andKey:RESOURCE_PROPERTY_CCB_TYPE] intValue];
    }];
}

-(void) setCcbType:(int)ccbType {
    _ccbType = ccbType;
    [self setValue:@(ccbType) withName:RESOURCE_PROPERTY_CCB_TYPE isAudio:NO];
    [[AppDelegate appDelegate].outlineProject reloadData];
}

@end
