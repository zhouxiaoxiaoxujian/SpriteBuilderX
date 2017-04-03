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

// ---------------------------------------------------------------------

static const float CCSprite9SliceMarginDefault         = 1.0f/3.0f;

// ---------------------------------------------------------------------

@implementation CCBPSprite9SliceBase
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
    
    // initialize new parts in 9slice
    self.margin = CCSprite9SliceMarginDefault;
    
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

static GLKMatrix4
PositionInterpolationMatrix(const CCSpriteVertexes *verts, const GLKMatrix4 *transform)
{
    GLKVector4 origin = verts->bl.position;
    GLKVector4 basisX = GLKVector4Subtract(verts->br.position, origin);
    GLKVector4 basisY = GLKVector4Subtract(verts->tl.position, origin);
    
    return GLKMatrix4Multiply(*transform, GLKMatrix4Make(
                                                         basisX.x, basisX.y, basisX.z, 0.0f,
                                                         basisY.x, basisY.y, basisY.z, 0.0f,
                                                         0.0f,     0.0f,     1.0f, 0.0f,
                                                         origin.x, origin.y, origin.z, 1.0f
                                                         ));
}

static GLKMatrix3
TexCoordInterpolationMatrix(const CCSpriteVertexes *verts)
{
    GLKVector2 origin = verts->bl.texCoord1;
    GLKVector2 basisX = GLKVector2Subtract(verts->br.texCoord1, origin);
    GLKVector2 basisY = GLKVector2Subtract(verts->tl.texCoord1, origin);
    
    return GLKMatrix3Make(
                          basisX.x, basisX.y, 0.0f,
                          basisY.x, basisY.y, 0.0f,
                          origin.x, origin.y, 1.0f
                          );
}

-(void)setRenderingType:(CCBPSprite9SliceRenderingType)renderingType
{
    _renderingType = renderingType;
    _isTextureDirty = YES;
}

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
        if(_renderingType == CCBPSprite9SliceRenderingTypeTiled)
        {
            TiledSprite* croppedSprite = [[TiledSprite alloc] initWithSprite:self width:self.contentSizeInPoints.width height:self.contentSizeInPoints.height];
            croppedSprite.anchorPoint = ccp(0, 0);
            croppedSprite.position = ccp(0, 0);
            [baseNode addChild:croppedSprite];
            croppedSprite.cascadeOpacityEnabled = YES;
            croppedSprite.cascadeColorEnabled = YES;
        }
        /*
        else if(_renderingType == CCBPSprite9SliceRenderingTypeSimple || (_marginTop == 0  && _marginLeft == 0 && _marginRight == 0 && _marginBottom == 0))
        {
            CCSprite* croppedSprite = [[CCSprite alloc] initWithSpriteFrame:self.spriteFrame];
            croppedSprite.anchorPoint = ccp(0, 0);
            croppedSprite.position = ccp(0, 0);
            croppedSprite.scaleX = self.contentSize.width / croppedSprite.contentSize.width;
            croppedSprite.scaleY = self.contentSize.height / croppedSprite.contentSize.height;
            [baseNode addChild:croppedSprite];
        }*/
        _isTextureDirty = NO;
        baseNode.cascadeColorEnabled = YES;
        baseNode.cascadeOpacityEnabled = YES;
    }
    [super visit:renderer parentTransform:parentTransform];
}

// TODO This is sort of brute force. Could probably use some optimization after profiling.
// Could it be done in a vertex shader using the texCoord2 attribute?
-(void)draw:(CCRenderer *)renderer transform:(const GLKMatrix4 *)transform
{
    // Don't draw rects that were originally sizeless. CCButtons in tableviews are like this.
    // Not really sure it's intended behavior or not.
    if(_originalContentSize.width == 0 && _originalContentSize.height == 0) return;
    
    switch (_renderingType) {
        case CCBPSprite9SliceRenderingTypeSlice:
        case CCBPSprite9SliceRenderingTypeSimple:
            {
                //if(_marginTop == 0  && _marginLeft == 0 && _marginRight == 0 && _marginBottom == 0)
                //    return;
                
                CGSize size = self.contentSizeInPoints;
                CGSize rectSize = self.textureRect.size;
                
                CGSize physicalSize = CGSizeMake(
                                                 size.width + rectSize.width - _originalContentSize.width,
                                                 size.height + rectSize.height - _originalContentSize.height
                                                 );
                
                // Lookup tables for alpha coefficients.
                float scaleX = physicalSize.width/rectSize.width;
                float scaleY = physicalSize.height/rectSize.height;
                
                float marginLeft;
                float marginRight;
                float marginTop;
                float marginBottom;
                
                if(_renderingType == CCBPSprite9SliceRenderingTypeSimple)
                {
                    marginLeft = 0;
                    marginRight = 0;
                    marginTop = 0;
                    marginBottom = 0;
                }
                else
                {
                    marginLeft = _marginLeft;
                    marginRight = _marginRight;
                    marginTop = _marginTop;
                    marginBottom = _marginBottom;
                }
                
                float alphaX2[4];
                alphaX2[0] = 0;
                alphaX2[1] = marginLeft / (physicalSize.width / rectSize.width);
                alphaX2[2] = 1 - marginRight / (physicalSize.width / rectSize.width);
                alphaX2[3] = 1;
                const float alphaX[4] = {0.0f, marginLeft, scaleX - marginRight, scaleX};
                const float alphaY[4] = {0.0f, marginBottom, scaleY - marginTop, scaleY};
                
                const float alphaTexX[4] = {0.0f, marginLeft, 1.0f - marginRight, 1.0f};
                const float alphaTexY[4] = {0.0f, marginBottom, 1.0f - marginTop, 1.0f};
                
                // Interpolation matrices for the vertexes and texture coordinates
                const CCSpriteVertexes *_verts = self.vertexes;
                GLKMatrix4 interpolatePosition = PositionInterpolationMatrix(_verts, transform);
                GLKMatrix3 interpolateTexCoord = TexCoordInterpolationMatrix(_verts);
                GLKVector4 color = _verts->bl.color;
                
                CCRenderBuffer buffer = [renderer enqueueTriangles:18 andVertexes:16 withState:self.renderState globalSortOrder:0];
                
                // Interpolate the vertexes!
                for(int y=0; y<4; y++){
                    for(int x=0; x<4; x++){
                        GLKVector4 position = GLKMatrix4MultiplyVector4(interpolatePosition, GLKVector4Make(alphaX[x], alphaY[y], 0.0f, 1.0f));
                        GLKVector3 texCoord = GLKMatrix3MultiplyVector3(interpolateTexCoord, GLKVector3Make(alphaTexX[x], alphaTexY[y], 1.0f));
                        CCRenderBufferSetVertex(buffer, y*4 + x, (CCVertex){position, GLKVector2Make(texCoord.x, texCoord.y), GLKVector2Make(0.0f, 0.0f), color});
                    }
                }
                
                // Output lots of triangles.
                for(int y=0; y<3; y++){
                    for(int x=0; x<3; x++){
                        CCRenderBufferSetTriangle(buffer, y*6 + x*2 + 0, (y + 0)*4 + (x + 0), (y + 0)*4 + (x + 1), (y + 1)*4 + (x + 1));
                        CCRenderBufferSetTriangle(buffer, y*6 + x*2 + 1, (y + 0)*4 + (x + 0), (y + 1)*4 + (x + 1), (y + 1)*4 + (x + 0));
                    }
                }
            }
            return;
        
        case CCBPSprite9SliceRenderingTypeTiled:
            return;
    }
    
}

// ---------------------------------------------------------------------
#pragma mark - properties
// ---------------------------------------------------------------------

- (float)margin
{
    // if margins are not the same, a unified margin can nort be read
    NSAssert(_marginLeft == _marginRight &&
             _marginLeft == _marginTop &&
             _marginLeft == _marginBottom, @"Margin can not be read. Do not know which margin to return");
    
    // just return any of them
    return(_marginLeft);
}

- (void)setMargin:(float)margin
{
    _isTextureDirty = YES;
    margin = clampf(margin, 0, 0.5);
    _marginLeft = margin;
    _marginRight = margin;
    _marginTop = margin;
    _marginBottom = margin;
}

// ---------------------------------------------------------------------

- (void)setMarginLeft:(float)marginLeft
{
    _isTextureDirty = YES;
    _marginLeft = clampf(marginLeft, 0, 1);
}

- (void)setMarginRight:(float)marginRight
{
    _isTextureDirty = YES;
    _marginRight = clampf(marginRight, 0, 1);
}

- (void)setMarginTop:(float)marginTop
{
    _isTextureDirty = YES;
    _marginTop = clampf(marginTop, 0, 1);
}

- (void)setMarginBottom:(float)marginBottom
{
    _isTextureDirty = YES;
    _marginBottom = clampf(marginBottom, 0, 1);
}

@end
