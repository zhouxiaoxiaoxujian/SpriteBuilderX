//
//  CCBPButton.m
//  SpriteBuilder
//
//  Created by Viktor on 9/25/13.
//
//

#import "CCBPButton.h"
#import "CCSpriteFrame.h"
#import "CCTexture.h"
#import "AppDelegate.h"
#import "InspectorController.h"
#import "CCSprite9Slice.h"

@implementation CCBPButton

- (id) init
{
    self = [super init];
    if (!self) return NULL;
    
    self.userInteractionEnabled = NO;
    
    return self;
}


-(void)onSetSizeFromTexture
{
    CCSpriteFrame * spriteFrame = _backgroundSpriteFrames[@(CCControlStateNormal)];
    if(spriteFrame == nil)
        return;
    
    self.preferredSize = spriteFrame.texture.contentSize;
    
    [self willChangeValueForKey:@"preferredSize"];
    [self didChangeValueForKey:@"preferredSize"];
    [[InspectorController sharedController] refreshProperty:@"preferredSize"];
    
}

- (void)setMarginLeft:(float)marginLeft
{
    self.background.marginLeft = marginLeft;
}

- (void)setMarginRight:(float)marginRight
{
    self.background.marginRight = marginRight;
}

- (void)setMarginTop:(float)marginTop
{
    self.background.marginTop = marginTop;
}

- (float)marginBottom
{
    return self.background.marginBottom;
}

- (float)marginLeft
{
    return self.background.marginLeft;
}

- (float)marginRight
{
    return self.background.marginRight;
}

- (float)marginTop
{
    return self.background.marginTop;
}

- (void)setMarginBottom:(float)marginBottom
{
    self.background.marginBottom = marginBottom;
}

@end
