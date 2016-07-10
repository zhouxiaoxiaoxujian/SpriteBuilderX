//
//  PreviewAudioViewController.h
//  SpriteBuilder
//
//  Created by Nicky Weber on 26.08.14.
//
//

#import <Cocoa/Cocoa.h>
#import "PreviewViewControllerProtocol.h"
#import "PreviewBaseViewController.h"

@class ProjectSettings;
@class AudioPlayerViewController;

@interface PreviewAudioViewController : PreviewBaseViewController <PreviewViewControllerProtocol>

@property (nonatomic, weak) IBOutlet NSView *androidSettingsContainer;
@property (nonatomic, weak) IBOutlet NSView *audioControllerContainer;
@property (nonatomic, weak) IBOutlet NSImageView *iconImage;

// Bindings
@property (nonatomic) int format_sound;

@end
