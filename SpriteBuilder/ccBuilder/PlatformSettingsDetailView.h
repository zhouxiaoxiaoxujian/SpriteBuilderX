//
//  PackageSettingsDetailView.h
//  SpriteBuilder
//
//  Created by Nicky Weber on 24.07.14.
//
//

#import <Cocoa/Cocoa.h>

@class PlatformSettings;

@interface PlatformSettingsDetailView : NSView

@property (nonatomic, strong) IBOutlet NSView *androidView;
@property (nonatomic) BOOL showAndroidSettings;

@end
