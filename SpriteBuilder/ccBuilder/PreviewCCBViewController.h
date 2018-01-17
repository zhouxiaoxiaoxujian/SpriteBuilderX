//
//  PreviewCCBViewController.h
//  SpriteBuilder
//
//  Created by Nicky Weber on 27.08.14.
//
//

#import <Cocoa/Cocoa.h>
#import "PreviewViewControllerProtocol.h"
#import "PreviewBaseViewController.h"

@class PreviewBaseViewController;
@class ProjectSettings;
@class CCBImageView;

@interface PreviewCCBViewController : PreviewBaseViewController <PreviewViewControllerProtocol>

@property (nonatomic, weak) IBOutlet NSImageView *ccbPreviewImageView;
@property (nonatomic) int ccbType;

@end
