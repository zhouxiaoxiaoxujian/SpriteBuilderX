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

#import "CCBPTiledImage.h"
#import "AppDelegate.h"
#import "InspectorController.h"


@interface TiledSprite : CCSprite
{
    int width;
    int height;
}

- (id) initWithSprite:(CCSprite*)p_sprite width:(float)p_width height:(float)p_height;

@end

@implementation TiledSprite

- (id) initWithSprite:(CCSprite *)p_sprite width:(float)p_width height:(float)p_height
{
    if (self = [super init])
    {
        // Only bother doing anything if the sizes are positive
        if (p_width > 0 && p_height > 0)
        {
            CGRect spriteBounds = p_sprite.textureRect;
            float sourceX = spriteBounds.origin.x;
            float sourceY = spriteBounds.origin.y;
            float sourceWidth = spriteBounds.size.width;
            float sourceHeight = spriteBounds.size.height;
            CCTexture* texture = p_sprite.texture;
            
            // Case 1: both width and height are smaller than source sprite, just clip
            if (p_width <= sourceWidth && p_height <= sourceHeight)
            {
                CCSprite* sprite = [CCSprite spriteWithTexture:texture rect:CGRectMake(sourceX, sourceY + sourceHeight - p_height, p_width, p_height)];
                sprite.anchorPoint = ccp(0, 0);
                [self addChild:sprite];
                sprite.cascadeOpacityEnabled = YES;
                sprite.cascadeColorEnabled = YES;
            }
            // Case 2: only width is larger than source sprite
            else if (p_width > sourceWidth && p_height <= sourceHeight)
            {
                // Stamp sideways until we can
                float ix = 0;
                while (ix < p_width - sourceWidth)
                {
                    CCSprite* sprite = [CCSprite spriteWithTexture:texture rect:CGRectMake(sourceX, sourceY + sourceHeight - p_height, sourceWidth, p_height)];
                    sprite.anchorPoint = ccp(0, 0);
                    sprite.position = ccp(ix, 0);
                    [self addChild:sprite];
                    sprite.cascadeOpacityEnabled = YES;
                    sprite.cascadeColorEnabled = YES;
                    
                    ix += sourceWidth;
                }
                
                // Stamp the last one
                CCSprite* sprite = [CCSprite spriteWithTexture:texture rect:CGRectMake(sourceX, sourceY + sourceHeight - p_height, p_width - ix, p_height)];
                sprite.anchorPoint = ccp(0, 0);
                sprite.position = ccp(ix, 0);
                [self addChild:sprite];
                sprite.cascadeOpacityEnabled = YES;
                sprite.cascadeColorEnabled = YES;
            }
            // Case 3: only height is larger than source sprite
            else if (p_height >= sourceHeight && p_width <= sourceWidth)
            {
                // Stamp down until we can
                float iy = 0;
                while (iy < p_height - sourceHeight)
                {
                    CCSprite* sprite = [CCSprite spriteWithTexture:texture rect:CGRectMake(sourceX, sourceY, p_width, sourceHeight)];
                    sprite.anchorPoint = ccp(0, 0);
                    sprite.position = ccp(0, iy);
                    [self addChild:sprite];
                    sprite.cascadeOpacityEnabled = YES;
                    sprite.cascadeColorEnabled = YES;
                    
                    iy += sourceHeight;
                }
                
                // Stamp the last one
                float remainingHeight = p_height - iy;
                CCSprite* sprite = [CCSprite spriteWithTexture:texture rect:CGRectMake(sourceX, sourceY + sourceHeight - remainingHeight, p_width, remainingHeight)];
                sprite.anchorPoint = ccp(0, 0);
                sprite.position = ccp(0, iy);
                [self addChild:sprite];
                sprite.cascadeOpacityEnabled = YES;
                sprite.cascadeColorEnabled = YES;
            }
            // Case 4: both width and height are larger than source sprite (Composite together several Case 2's, as needed)
            else
            {
                // Stamp down until we can
                float iy = 0;
                while (iy < p_height - sourceHeight)
                {
                    TiledSprite* sprite = [[TiledSprite alloc] initWithSprite:p_sprite width:p_width height:sourceHeight];
                    sprite.anchorPoint = ccp(0, 0);
                    sprite.position = ccp(0, iy);
                    [self addChild:sprite];
                    sprite.cascadeOpacityEnabled = YES;
                    sprite.cascadeColorEnabled = YES;
                    
                    iy += sourceHeight;
                }
                
                // Stamp the last one
                TiledSprite* sprite = [[TiledSprite alloc] initWithSprite:p_sprite width:p_width height:p_height - iy];
                sprite.anchorPoint = ccp(0, 0);
                sprite.position = ccp(0, iy);
                [self addChild:sprite];
                sprite.cascadeOpacityEnabled = YES;
                sprite.cascadeColorEnabled = YES;
            }
        }
    }
    
    return self;
}

@end

@interface CCBPTiledImageBase : CCSprite {
}

@end

// ---------------------------------------------------------------------

@implementation CCBPTiledImageBase
{
    CGSize _originalContentSize;
    BOOL _isTextureDirty;
}

// ---------------------------------------------------------------------
#pragma mark - create and destroy
// ---------------------------------------------------------------------

- (id)initWithTexture:(CCTexture *)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
    self = [super initWithTexture:texture rect:rect rotated:rotated];
    NSAssert(self != nil, @"Unable to create class");
    
    _originalContentSize = self.contentSizeInPoints;
    _isTextureDirty = YES;
    
    self.cascadeColorEnabled = YES;
    self.cascadeOpacityEnabled = YES;
    
    // done
    return(self);
}

// ---------------------------------------------------------------------
#pragma mark - overridden properties
// ---------------------------------------------------------------------

- (void)setTextureRect:(CGRect)rect rotated:(BOOL)rotated untrimmedSize:(CGSize)untrimmedSize
{
    _isTextureDirty = YES;
    CGSize oldContentSize = self.contentSize;
    CCSizeType oldContentSizeType = self.contentSizeType;
    
    [super setTextureRect:rect rotated:rotated untrimmedSize:untrimmedSize];
    
    // save the original sizes for texture calculations
    _originalContentSize = self.contentSizeInPoints;
    
    if (!CGSizeEqualToSize(oldContentSize, CGSizeZero))
    {
        self.contentSizeType = oldContentSizeType;
        self.contentSize = oldContentSize;
    }
}

-(void)setTexture:(CCTexture *)texture
{
    _isTextureDirty = YES;
    [super setTexture:texture];
}

-(void)setSpriteFrame:(CCSpriteFrame *)spriteFrame
{
    _isTextureDirty = YES;
    [super setSpriteFrame:spriteFrame];
}

-(void)setScaleX:(float)scaleX
{
    _isTextureDirty = YES;
    [super setScaleX:scaleX];
}

-(void)setScaleY:(float)scaleY
{
    _isTextureDirty = YES;
    [super setScaleY:scaleY];
}

// ---------------------------------------------------------------------
#pragma mark - draw

- (void) visit:(CCRenderer *)renderer parentTransform:(const GLKMatrix4 *)parentTransform
{
    if (_isTextureDirty)
    {
        [self removeAllChildren];
        CCNode *baseNode = [[CCNode alloc] init];
        baseNode.anchorPoint = ccp(0, 0);
        baseNode.position = ccp(self.flipX?1:0, self.flipY?1:0);
        baseNode.positionType = CCPositionTypeNormalized;
        [self addChild:baseNode];
        if(self.flipX)
        {
            [baseNode setScaleX:-1];
        }
        if(self.flipY)
            [baseNode setScaleY:-1];
        
        TiledSprite* croppedSprite = [[TiledSprite alloc] initWithSprite:self width:self.contentSizeInPoints.width height:self.contentSizeInPoints.height];
        croppedSprite.anchorPoint = ccp(0, 0);
        croppedSprite.position = ccp(0, 0);
        [baseNode addChild:croppedSprite];
        croppedSprite.cascadeOpacityEnabled = YES;
        croppedSprite.cascadeColorEnabled = YES;
        _isTextureDirty = NO;
        baseNode.cascadeColorEnabled = YES;
        baseNode.cascadeOpacityEnabled = YES;
    }
    [super visit:renderer parentTransform:parentTransform];
}

-(void) setContentSize:(CGSize)size
{
    _isTextureDirty = YES;
    [super setContentSize:size];
}

// TODO This is sort of brute force. Could probably use some optimization after profiling.
// Could it be done in a vertex shader using the texCoord2 attribute?
-(void)draw:(CCRenderer *)renderer transform:(const GLKMatrix4 *)transform
{
}

@end



@implementation CCBPTiledImage
{
    CCBPTiledImageBase *_background;
}

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
        _imageScale = 1.0f;
        _background = [[CCBPTiledImageBase alloc] init];
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
        _background = [[CCBPTiledImageBase alloc] initWithTexture:texture rect:rect rotated:rotated];
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
