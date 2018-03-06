//
//  SpriteObjectMenuFlipController.m
//  SpriteBuilderX
//
//  Created by Volodymyr Klymenko on 3/6/18.
//

#import "SpriteObjectMenuFlipController.h"
#import "AppDelegate.h"
#import "InspectorController.h"

@interface SpriteObjectMenuFlipController ()

@end

@implementation SpriteObjectMenuFlipController

- (void) setFlipX:(BOOL)flipX
{
    NSString *propName = @"flipX";
    [[AppDelegate appDelegate] saveUndoStateWillChangeProperty:propName];
    [self.selection setValue:@(flipX) forKey:propName];
    [[InspectorController sharedController] refreshProperty: @"flip"];
    [[AppDelegate appDelegate].spriteObjectMenu cancelTracking];
}

- (BOOL) flipX
{
    return [[self.selection valueForKey:@"flipX"] boolValue];
}

- (void) setFlipY:(BOOL)flipY
{
    NSString *propName = @"flipY";
    [[AppDelegate appDelegate] saveUndoStateWillChangeProperty:propName];
    [self.selection setValue:@(flipY) forKey:propName];
    [[InspectorController sharedController] refreshProperty: @"flip"];
    [[AppDelegate appDelegate].spriteObjectMenu cancelTracking];
}

- (BOOL) flipY
{
    return [[self.selection valueForKey:@"flipY"] boolValue];
}

@end
