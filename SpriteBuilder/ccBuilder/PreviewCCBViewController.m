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

@implementation PreviewCCBViewController

- (void)setPreviewedResource:(RMResource *)previewedResource projectSettings:(ProjectSettings *)projectSettings
{
   NSString *filePath = [SBSettings miscFilesPathForFile:previewedResource.filePath projectPathDir:projectSettings.projectPath];
   NSString *imgPreviewPath = [filePath stringByAppendingPathExtension:MISC_FILE_PPNG];
   NSImage *img = [[NSImage alloc] initWithContentsOfFile:imgPreviewPath];
   if (!img)
   {
       img = [NSImage imageNamed:@"ui-nopreview.png"];
   }

   [_ccbPreviewImageView setImage:img];
}

@end
