//
//  PreviewImageViewController.h
//  SpriteBuilder
//
//  Created by Nicky Weber on 26.08.14.
//
//

#import <Cocoa/Cocoa.h>
#import "PreviewViewControllerProtocol.h"
#import "PreviewBaseViewController.h"

@class ProjectSettings;
@class CCBImageView;

@interface PreviewImageViewController : PreviewBaseViewController <PreviewViewControllerProtocol>

@property (nonatomic, weak) IBOutlet NSView *androidSettingsContainer;

@property (nonatomic, weak) IBOutlet CCBImageView *previewMain;
@property (nonatomic, weak) IBOutlet CCBImageView *previewPhone;
@property (nonatomic, weak) IBOutlet CCBImageView *previewPhonehd;
@property (nonatomic, weak) IBOutlet CCBImageView *previewTablet;
@property (nonatomic, weak) IBOutlet CCBImageView *previewTablethd;

// Bindings
@property (nonatomic, readonly) BOOL format_supportsPVRTC;

@property (nonatomic) int scaleFrom;
@property (nonatomic) int tabletScale;

@property (nonatomic) int  format;

@end
