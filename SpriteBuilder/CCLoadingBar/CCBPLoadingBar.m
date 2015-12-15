//
//  CCBPLoadingBar.m
//  SpriteBuilder
//
//  Created by Sergey on 12/08/15.
//
//

#import "CCBPLoadingBar.h"
#import "AppDelegate.h"
#import "InspectorController.h"

@interface CCBPLoadingBar()
{
    NSInteger _totalLength;
}
@end

@implementation CCBPLoadingBar

- (id) init
{
    self = [super init];
    if (!self) return NULL;
    
    self.userInteractionEnabled = NO;
    
     _background = [[CCSprite9Slice alloc] init];
    [self addChild:_background];
    _direction = CCLoadingBarDirectionLeft;
    
    _totalLength = _contentSize.width;
    
    return self;
}

-(void) setContentSize:(CGSize)size
{
    //[self setPreferredSize:size];
    //[self setMaxSize:size];
    _totalLength = size.width;
    [super setContentSize:size];
    [self updateProgressBar];
}

- (void)setSpriteFrame:(CCSpriteFrame*)spriteFrame
{
    [_background setSpriteFrame:spriteFrame];
    [_background setAnchorPoint:CGPointMake(0.0,0.5)];
    [_background setPosition:CGPointMake(0.0f, _contentSize.height*0.5f)];
}

- (CCSpriteFrame*) spriteFrame
{
    return _background.spriteFrame;
}

- (void)setDirection:(CCLoadingBarDirection)direction
{
    if (_direction == direction)
    {
        return;
    }
    _direction = direction;
    [self updateProgressBar];
}

- (void)updateProgressBar
{
    float width = (float)(_percentage) / 100.0f * _totalLength;
    [_background setContentSize:CGSizeMake(width, _contentSize.height)];
    switch (_direction)
    {
        case CCLoadingBarDirectionLeft:
            [_background setAnchorPoint:CGPointMake(0.0f, 0.5f)];
            [_background setPosition:CGPointMake(0.0f, _contentSize.height*0.5f)];
            break;
        case CCLoadingBarDirectionRight:
            [_background setAnchorPoint:CGPointMake(1.0f,0.5)];
            [_background setPosition:CGPointMake(_totalLength, _contentSize.height*0.5f)];
            break;
    }
}

-(void)onSetSizeFromTexture
{
    CCSpriteFrame * spriteFrame = _background.spriteFrame;
    if(spriteFrame == nil)
        return;
    
    [[AppDelegate appDelegate] saveUndoStateWillChangeProperty:@"contentSize"];
    
    self.contentSize = spriteFrame.texture.contentSize;
    
    [self willChangeValueForKey:@"contentSize"];
    [self didChangeValueForKey:@"contentSize"];
    [[InspectorController sharedController] refreshProperty:@"contentSize"];
}

- (void)setPercentage:(float)percentage
{
    if (percentage > 100)
    {
        percentage = 100;
    }
    if (percentage < 0)
    {
        percentage = 0;
    }
    if (_percentage == percentage)
    {
        return;
    }
    _percentage = percentage;
    
    if (_totalLength <= 0)
    {
        return;
    }
    
    [self updateProgressBar];
}

- (void)setMarginLeft:(float)marginLeft
{
    marginLeft = clampf(marginLeft, 0, 1);
    
    if(self.marginRight + marginLeft >= 1)
    {
        [[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The left & right margins should add up to less than 1"];
        [[InspectorController sharedController] refreshProperty:@"marginLeft"];
        return;
    }
    [self.background setMarginLeft:marginLeft];
}

- (void)setMarginRight:(float)marginRight
{
    marginRight = clampf(marginRight, 0, 1);
    if(self.marginLeft + marginRight >= 1)
    {
        [[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The left & right margins should add up to less than 1"];
        [[InspectorController sharedController] refreshProperty:@"marginRight"];
        
        return;
    }
    
    [self.background setMarginRight:marginRight];
}

- (void)setMarginTop:(float)marginTop
{
    marginTop = clampf(marginTop, 0, 1);
    if(self.marginBottom + marginTop >= 1)
    {
        [[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The top & bottom margins should add up to less than 1"];
        [[InspectorController sharedController] refreshProperty:@"marginTop"];
        return;
    }
    
    [self.background setMarginTop:marginTop];
    
}

- (void)setMarginBottom:(float)marginBottom
{
    marginBottom = clampf(marginBottom, 0, 1);
    if(self.marginTop + marginBottom >= 1)
    {
        [[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The top & bottom margins should add up to less than 1"];
        [[InspectorController sharedController] refreshProperty:@"marginBottom"];
        return;
    }
    
    [self.background setMarginBottom:marginBottom];
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

@end
