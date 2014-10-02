//
//  CCProgressTimer.m
//  CCProgressTimer
//
//  Created by user-i134 on 8/5/13.
//
//

#import "CCBProgressNode.h"

@implementation CCBProgressNode

-(id)init {
    self = [super init];
    if (!self) {
        return NULL;
    }
    
    return self;
}

-(void)setSpriteFrame:(CCSpriteFrame *)newSpriteFrame
{
    if(!newSpriteFrame)
        [self setSprite:[CCSprite emptySprite]];
    else
        [self setSprite:[CCSprite spriteWithSpriteFrame:newSpriteFrame]];
}

-(void)setBlendFunc:(ccBlendFunc)blendFunc
{
    [self.sprite setBlendFunc:blendFunc];
}

-(void)setFlipX:(BOOL)flipX
{
    [self.sprite setFlipX:flipX];
}

-(void)setFlipY:(BOOL)flipY
{
    [self.sprite setFlipY:flipY];
}

-(CCSpriteFrame *)spriteFrame
{
    return self.sprite.spriteFrame;
}

-(ccBlendFunc)blendFunc
{
    return self.sprite.blendFunc;
}

-(BOOL)flipX
{
    return self.sprite.flipX;
}

-(BOOL)flipY
{
    return self.sprite.flipY;
}

@end
