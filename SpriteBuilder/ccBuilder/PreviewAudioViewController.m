//
//  PreviewAudioViewController.m
//  SpriteBuilder
//
//  Created by Nicky Weber on 26.08.14.
//
//

#import "PreviewAudioViewController.h"
#import "RMResource.h"
#import "MiscConstants.h"
#import "ResourcePropertyKeys.h"
#import "ProjectSettings.h"
#import "AudioPlayerViewController.h"

@interface PreviewAudioViewController ()

@property (nonatomic, strong) AudioPlayerViewController *audioPlayerViewController;

@end


@implementation PreviewAudioViewController

- (void)setPreviewedResource:(RMResource *)previewedResource projectSettings:(ProjectSettings *)projectSettings
{
    self.projectSettings = projectSettings;
    self.previewedResource = previewedResource;

    [self initializeAudioController];

    [self initializeIcon];

    [self populateInitialValues];
}

- (void)initializeAudioController
{
    self.audioPlayerViewController = [[AudioPlayerViewController alloc] initWithNibName:@"AudioPlayerView" bundle:nil];

    _audioPlayerViewController.view.frame = CGRectMake(0, 0, _audioControllerContainer.frame.size.width, _audioControllerContainer.frame.size.height);
    [_audioControllerContainer addSubview:_audioPlayerViewController.view];

    [_audioPlayerViewController setupPlayer];

    [_audioPlayerViewController loadAudioFile:_previewedResource.filePath];
}

- (void)populateInitialValues
{
    __weak PreviewAudioViewController *weakSelf = self;
    [self setInitialValues:^{
        weakSelf.format_sound = [[weakSelf.projectSettings propertyForResource:weakSelf.previewedResource andKey:RESOURCE_PROPERTY_SOUND_FORMAT] intValue];
    }];
}

- (void)initializeIcon
{
    NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFileType:@"wav"];
    [icon setScalesWhenResized:YES];
    icon.size = NSMakeSize(128, 128);
    [_iconImage setImage:icon];
}

- (void)setFormat_sound:(int)format_sound
{
    _format_sound = format_sound;
    [self setValue:@(format_sound) withName:RESOURCE_PROPERTY_SOUND_FORMAT isAudio:YES];
}

@end
