//
//  SpriteObjectMenuFlipController.h
//  SpriteBuilderX
//
//  Created by Volodymyr Klymenko on 3/6/18.
//

#import <Cocoa/Cocoa.h>
#import "cocos2d.h"

@interface SpriteObjectMenuFlipController : NSViewController

@property (nonatomic, assign) CCNode *selection;

@property (nonatomic, assign) BOOL flipX;
@property (nonatomic, assign) BOOL flipY;

@end
