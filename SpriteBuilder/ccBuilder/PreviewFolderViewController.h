//
//  PreviewFolderViewController.h
//  SpriteBuilder
//
//  Created by Nicky Weber on 26.08.14.
//
//

#import <Cocoa/Cocoa.h>
#import "PreviewViewControllerProtocol.h"
#import "PreviewBaseViewController.h"

@class ProjectSettings;

@interface PreviewFolderViewController : PreviewBaseViewController <PreviewViewControllerProtocol>

@property (nonatomic,readwrite) BOOL skip;

@end
