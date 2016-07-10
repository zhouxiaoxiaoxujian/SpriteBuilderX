//
//  PreviewSpriteSheetViewController.h
//  SpriteBuilder
//
//  Created by Nicky Weber on 26.08.14.
//
//

#import <Cocoa/Cocoa.h>
#import "PreviewViewControllerProtocol.h"

@class CCBImageView;
@class PreviewBaseViewController;

@interface PreviewSpriteSheetViewController : PreviewBaseViewController <PreviewViewControllerProtocol>

@property (nonatomic, weak) IBOutlet NSView *androidSettingsContainer;
@property (nonatomic, weak) IBOutlet CCBImageView* previewSpriteSheet;

@property (nonatomic) BOOL trimSprites;

@property (nonatomic) int  format;

@property (nonatomic,readwrite) int format_padding;
@property (nonatomic,readwrite) int format_extrude;

@end
