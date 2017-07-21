//
//  CCBPSprite9Slice.m
//  SpriteBuilder
//
//  Created by Viktor on 12/17/13.
//
//

#import "CCBPSprite9Slice.h"
#import "CCSprite_Private.h"
#import "CCTexture_Private.h"
#import "CCNode_Private.h"
#import "AppDelegate.h"
#import "InspectorController.h"


@implementation CCBPSprite9Slice



- (NSArray*) keysForwardedToBackground
{
    return @[@"blendFunc",
             @"spriteFrame",
             @"flipX",
             @"flipY"];
}

- (void) setValue:(id)value forKey:(NSString *)key
{
    if ([[self keysForwardedToBackground] containsObject:key])
    {
        [_background setValue:value forKey:key];
        [self needsLayout];
        return;
    }
    [super setValue:value forKey:key];
}

- (id) valueForKey:(NSString *)key
{
    if ([[self keysForwardedToBackground] containsObject:key])
    {
        return [_background valueForKey:key];
    }
    return [super valueForKey:key];
}

-(id) init
{
    self = [super init];
    if(self)
    {
        _background = [[CCSprite9Slice alloc] init];
        _background.positionType = CCPositionTypeNormalized;
        _background.anchorPoint = CGPointMake(0.5f, 0.5f);
        _background.position = CGPointMake(0.5f, 0.5f);
        [self addProtectedChild:_background];
        [super needsLayout];
    }
    return self;
}

- (id)initWithTexture:(CCTexture *)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
    self = [super init];
    if(self)
    {
        _background = [[CCSprite9Slice alloc] initWithTexture:texture rect:rect rotated:rotated];
        _background.positionType = CCPositionTypeNormalized;
        _background.anchorPoint = CGPointMake(0.5f, 0.5f);
        _background.position = CGPointMake(0.5f, 0.5f);
        [self addProtectedChild:_background];
    }
    return self;
}

- (void) layout
{
    CGSize contentSize = [self convertContentSizeToPoints:self.contentSize type:self.contentSizeType];
    [_background setContentSize:CGSizeMake(contentSize.width, contentSize.height)];
    [super layout];
}

- (void) setContentSize:(CGSize) contentSize
{
    [super setContentSize:contentSize];
    [self needsLayout];
}

- (void) setContentSizeType:(CCSizeType)contentSizeType
{
    [super setContentSizeType:contentSizeType];
    [self needsLayout];
}

- (void) setImageScale:(CGFloat) imageScale
{
    _background.scaleX = imageScale;
    _background.scaleY = imageScale;
    [self needsLayout];
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
    [_background setMarginLeft:marginLeft];
}

- (float)marginLeft
{
    return _background.marginLeft;
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
    
    [_background setMarginRight:marginRight];
}

- (float)marginRight
{
    return _background.marginRight;
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
    
    [_background setMarginTop:marginTop];
    
}

- (float)marginTop
{
    return _background.marginTop;
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
    
    [_background setMarginBottom:marginBottom];
}

- (float)marginBottom
{
    return _background.marginBottom;
}

-(void)onSetSizeFromTexture
{
    CCSpriteFrame * spriteFrame = _background.spriteFrame;
    if(spriteFrame == nil)
        return;
    
    [[AppDelegate appDelegate] saveUndoStateWillChangeProperty:@"contentSize"];
    
    self.contentSizeType = CCSizeTypeUIPoints;
    self.contentSizeInPoints = spriteFrame.originalSize;
    
    [self willChangeValueForKey:@"contentSize"];
    [self didChangeValueForKey:@"contentSize"];
    [[InspectorController sharedController] refreshProperty:@"contentSize"];
    [super needsLayout];
}

@end
