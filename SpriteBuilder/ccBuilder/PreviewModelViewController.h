//
//  PreviewModelViewController.h
//  SpriteBuilderX
//
//  Created by Sergey Perepelitsa on 19.12.17.
//
//

#import <Cocoa/Cocoa.h>
#import "PreviewViewControllerProtocol.h"
#import "PreviewBaseViewController.h"

@class ProjectSettings;

@interface PreviewModelViewController : PreviewBaseViewController <PreviewViewControllerProtocol>

// Bindings
@property (nonatomic,readwrite) BOOL skip_normals;
@property (nonatomic) int format_model;

@end
