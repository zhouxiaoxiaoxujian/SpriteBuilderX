/*
 * CocosBuilder: http://www.cocosbuilder.com
 *
 * Copyright (c) 2012 Zynga Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "CCBPImage.h"
#import "AppDelegate.h"
#import "InspectorController.h"

@implementation CCBPImage
{
}

- (NSArray*) keysForwardedToBackground
{
    return @[@"blendFunc",
             @"spriteFrame",
             @"renderingType"];
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
        _imageScale = 1.0f;
        _background = [[CCBPSprite9SliceBase alloc] init];
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
        _imageScale = 1.0f;
        _background = [[CCBPSprite9SliceBase alloc] initWithTexture:texture rect:rect rotated:rotated];
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
    [_background setContentSize:CGSizeMake(contentSize.width / _imageScale, contentSize.height / _imageScale)];
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
    _imageScale = imageScale;
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
