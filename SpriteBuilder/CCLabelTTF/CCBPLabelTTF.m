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

#import "CCBPLabelTTF.h"
#import "NSAttributedString+CCAdditions.h"
#import "CCTexture_Private.h"

@interface CCExtLabelTTF : CCLabelTTF
@property (nonatomic,assign) BOOL worldWrap;
@end

@implementation CCExtLabelTTF

- (void) drawAttributedString:(NSAttributedString *)attrString inContext:(CGContextRef) context inRect:(CGRect)rect {
    CGFloat contextHeight = CGBitmapContextGetHeight(context);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    CGPathRef path = CGPathCreateWithRect(CGRectMake(rect.origin.x, contextHeight-rect.origin.y-rect.size.height, rect.size.width, rect.size.height), NULL);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(framesetter);
    CGPathRelease(path);
    CGContextSaveGState(context);
    CGContextSetTextMatrix (context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0.0f, contextHeight);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CTFrameDraw(frame, context);
    CGContextRestoreGState(context);
    CFRelease(frame);
}

- (void)applyShadowOnContext:(CGContextRef)context color:(CGColorRef)color blurRadius:(CGFloat)blurRadius offset:(CGPoint)offset {
    
    CGContextSetShadowWithColor(context, CGSizeMake(offset.x, -offset.y), blurRadius, color);
    
}

- (void)applyOutlineOnContext:(CGContextRef)context color:(CGColorRef)color width:(CGFloat)width {
    CGContextSetTextDrawingMode(context, kCGTextStroke);
    CGContextSetLineWidth(context, width * 2);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(context, color);
    
}

- (CGSize) sizeForAttributedString:(NSAttributedString *)attrString constrainedToSize:(CGSize) size {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    
    CFRange suggestedRange;
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, size,  &suggestedRange);
    CFRelease(framesetter);
    
    return suggestedSize;
}

- (CCTexture*) createTextureWithAttributedString:(NSAttributedString*)attributedString useFullColor:(BOOL) fullColor
{
    NSAssert(attributedString, @"Invalid attributedString");
    
    CGSize originalDimensions = self.dimensions;
    
    CGFloat scale = [CCDirector sharedDirector].contentScaleFactor;
    originalDimensions.width *= scale;
    originalDimensions.height *= scale;
    
    CGSize dimensions = [self convertContentSizeToPoints:originalDimensions type:self.dimensionsType];
    
    CGFloat shadowBlurRadius = self.shadowBlurRadius * scale;
    CGPoint shadowOffset = ccpMult(self.shadowOffsetInPoints, scale);
    CGFloat outlineWidth = self.outlineWidth * scale;
    
    BOOL hasShadow = (self.shadowColor.alpha > 0);
    BOOL hasOutline = (self.outlineColor.alpha > 0 && self.outlineWidth > 0);
    
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    CGFloat scaleFactor = 1;
    
    CGFloat xPadding = 0;
    CGFloat yPadding = 0;
    CGFloat wDrawArea = 0;
    CGFloat hDrawArea = 0;
    
    // Calculate padding
    if (hasShadow)
    {
        xPadding = (shadowBlurRadius + fabs(shadowOffset.x));
        yPadding = (shadowBlurRadius + fabs(shadowOffset.y));
    }
    if (hasOutline)
    {
        xPadding += outlineWidth;
        yPadding += outlineWidth;
    }
    
    // Get actual rendered dimensions
    if (dimensions.height == 0)
    {
        // Get dimensions for string without dimensions of string with variable height
        dimensions = [self sizeForAttributedString:attributedString constrainedToSize:dimensions];
        
        dimensions.width = ceil(dimensions.width);
        dimensions.height = ceil(dimensions.height);
        
        wDrawArea = dimensions.width;
        hDrawArea = dimensions.height;
        
        dimensions.width += xPadding * 2;
        dimensions.height += yPadding * 2;
    }
    else if (dimensions.width > 0 && dimensions.height > 0)
    {
        wDrawArea = dimensions.width - xPadding * 2;
        hDrawArea = dimensions.height - yPadding * 2;
        
        // Handle strings with fixed dimensions
        if (self.adjustsFontSizeToFit)
        {
            
            CGFloat fontSize = NSAttributedStringSingleFontSize(attributedString);
            
            if (fontSize)
            {
                CGFloat origFontSize = fontSize;
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
                NSMutableAttributedString *newAttributedString = [attributedString mutableCopy];
                
                [newAttributedString removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0,[newAttributedString length])];
                [newAttributedString addAttribute:NSParagraphStyleAttributeName
                                      value:paragraphStyle
                                      range:NSMakeRange(0,[newAttributedString length])];
                
                attributedString = newAttributedString;

                CGSize wantedSize = [self sizeForAttributedString:attributedString constrainedToSize:CGSizeMake(wDrawArea, 0)];
                if(wantedSize.width>wDrawArea || wantedSize.height>hDrawArea)
                {
                    float startScale = 1.0;
                    float endScale = 1.0;
                    do
                    {
                        fontSize = origFontSize / (endScale * 2.0);
                        startScale = endScale;
                        endScale = endScale*2;
                        attributedString = NSAttributedStringCopyWithNewFontSize(attributedString, fontSize);
                        wantedSize = [self sizeForAttributedString:attributedString constrainedToSize:CGSizeMake(wDrawArea, 0)];
                    }while (wantedSize.height>hDrawArea);
                    float midScale;
                    for(int i=0;i<4;++i)
                    {
                        midScale = (startScale + endScale) / 2.0f;
                        fontSize = origFontSize / midScale;
                        wantedSize = [self sizeForAttributedString:attributedString constrainedToSize:CGSizeMake(wDrawArea, 0)];
                        if(wantedSize.height>hDrawArea)
                        {
                            startScale = midScale;
                        }
                        else
                        {
                            endScale = midScale;
                        }
                    }
                    fontSize = origFontSize / (endScale * 1.05f);
                    attributedString = NSAttributedStringCopyWithNewFontSize(attributedString, fontSize);
                }
            }
        }
        
        // Handle vertical alignment
        CGSize actualSize = [self sizeForAttributedString:attributedString constrainedToSize:CGSizeMake(wDrawArea, 0)];
        if (self.verticalAlignment == CCVerticalTextAlignmentBottom)
        {
            yOffset = hDrawArea - actualSize.height;
        }
        else if (self.verticalAlignment == CCVerticalTextAlignmentCenter)
        {
            yOffset = (hDrawArea - actualSize.height)/2;
        }
    }
    
    // Handle baseline adjustments
    yOffset += self.baselineAdjustment * scaleFactor * scale + yPadding;
    xOffset += xPadding;
    
    // Round dimensions to nearest number that is dividable by 2
    dimensions.width = ceilf(dimensions.width/2)*2;
    dimensions.height = ceilf(dimensions.height/2)*2;
    
    // get nearest power of two
    CGSize POTSize = CGSizeMake(CCNextPOT(dimensions.width), CCNextPOT(dimensions.height));
    
    // Mac crashes if the width or height is 0
    if( POTSize.width == 0 )
        POTSize.width = 2;
    
    if( POTSize.height == 0)
        POTSize.height = 2;
    
    CGRect drawArea = CGRectMake(xOffset, yOffset, wDrawArea, hDrawArea);
    
    unsigned char* data = calloc(POTSize.width, POTSize.height * 4);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data, POTSize.width, POTSize.height, 8, POTSize.width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    if (!context)
    {
        free(data);
        return NULL;
    }
    
    
    if (!hasShadow && !hasOutline) {
        [self drawAttributedString:attributedString inContext:context inRect:drawArea];
        
    } else if (hasShadow && !hasOutline) {
        [self applyShadowOnContext:context color:self.shadowColor.CGColor blurRadius:shadowBlurRadius offset:shadowOffset];
        [self drawAttributedString:attributedString inContext:context inRect:drawArea];
        
    } else if (!hasShadow && hasOutline) {
        CGContextSaveGState(context);
        [self applyOutlineOnContext:context color:self.outlineColor.CGColor width:outlineWidth];
        [self drawAttributedString:attributedString inContext:context inRect:drawArea];
        CGContextRestoreGState(context);
        [self drawAttributedString:attributedString inContext:context inRect:drawArea];
        
        
    } else if (hasShadow && hasOutline) {
        CGContextSaveGState(context);
        [self applyOutlineOnContext:context color:self.outlineColor.CGColor width:outlineWidth];
        [self applyShadowOnContext:context color:self.shadowColor.CGColor blurRadius:shadowBlurRadius offset:shadowOffset];
        [self drawAttributedString:attributedString inContext:context inRect:drawArea];
        CGContextRestoreGState(context);
        CGContextSaveGState(context);
        [self applyOutlineOnContext:context color:self.outlineColor.CGColor width:outlineWidth];
        [self drawAttributedString:attributedString inContext:context inRect:drawArea];
        CGContextRestoreGState(context);
        [self drawAttributedString:attributedString inContext:context inRect:drawArea];
        
        
    }
    
    CGContextRelease(context);
    
    CCTexture* texture = NULL;
    
    // Initialize the texture
    if (fullColor)
    {
        // RGBA8888 format
        texture = [[CCTexture alloc] initWithData:data pixelFormat:CCTexturePixelFormat_RGBA8888 pixelsWide:POTSize.width pixelsHigh:POTSize.height contentSizeInPixels:dimensions contentScale:[CCDirector sharedDirector].contentScaleFactor];
        [texture setPremultipliedAlpha:YES];
    }
    else
    {
        NSUInteger textureSize = POTSize.width * POTSize.height;
        
        // A8 format (alpha channel only)
        unsigned char* dst = data;
        for(int i = 0; i<textureSize; i++)
            dst[i] = data[i*4+3];
        
        texture = [[CCTexture alloc] initWithData:data pixelFormat:CCTexturePixelFormat_A8 pixelsWide:POTSize.width pixelsHigh:POTSize.height contentSizeInPixels:dimensions contentScale:[CCDirector sharedDirector].contentScaleFactor];
        self.shader = [CCShader positionTextureA8ColorShader];
    }
    
    free(data);
    
    return texture;
}
@end

@implementation CCBPLabelTTF

- (id) init
{
    self = [super init];
    if(self)
    {
        _fontSize = 12;
        _adjustsFontSizeToFit = NO;
        _dimensions = CGSizeZero;
        _dimensionsType = CCSizeTypePoints;
        _label = [[CCExtLabelTTF alloc] init];
        _label.positionType = CCPositionTypeNormalized;
        _label.anchorPoint = CGPointMake(0.5f, 0.5f);
        _label.position = CGPointMake(0.5f, 0.5f);
        [self addProtectedChild:_label];
    }
    return self;
}

- (NSArray*) keysForwardedToLabel
{
    return @[@"string",
             @"fontName",
             @"horizontalAlignment",
             @"verticalAlignment",
             @"fontColor",
             @"outlineColor",
             @"outlineWidth",
             @"shadowColor",
             @"shadowBlurRadius",
             @"shadowOffset",
             @"shadowOffsetType"];
}

- (void) setValue:(id)value forKey:(NSString *)key
{
    if ([[self keysForwardedToLabel] containsObject:key])
    {
        [_label setValue:value forKey:key];
        [self needsLayout];
        return;
    }
    [super setValue:value forKey:key];
}

- (id) valueForKey:(NSString *)key
{
    if ([[self keysForwardedToLabel] containsObject:key])
    {
        return [_label valueForKey:key];
    }
    return [super valueForKey:key];
}

-(void) setAdjustsFontSizeToFit:(BOOL)value
{
    _adjustsFontSizeToFit = value;
    [self needsLayout];
}

- (void) setDimensionsType:(CCSizeType)dimensionsType
{
    _dimensionsType = dimensionsType;
    [self needsLayout];
}

- (void) setDimensions:(CGSize)dimensions
{
    _dimensions = dimensions;
    [self needsLayout];
}

- (void) layout
{
    CGSize paddedLabelSize = [self convertContentSizeToPoints:self.dimensions type:self.dimensionsType];
    
    /*if(_owerflowType == CCTextOwerflowShrink && _fontSize && self.dimensions.width && self.dimensions.height)
    {
        _label.fontSize = _fontSize;
        _label.dimensions = CGSizeMake(paddedLabelSize.width, 0);
        if(_label.contentSize.height>paddedLabelSize.height)
        {
            float startScale = 1.0;
            float endScale = 1.0;
            float fontSize = _fontSize;
            do
            {
                _label.fontSize = fontSize / (endScale * 2.0);
                startScale = endScale;
                endScale = endScale*2;
            }while (_label.contentSize.height>paddedLabelSize.height);
            float midScale;
            for(int i=0;i<4;++i)
            {
                midScale = (startScale + endScale) / 2.0f;
                _label.fontSize = fontSize / midScale;
                if(_label.contentSize.height>paddedLabelSize.height)
                {
                    startScale = midScale;
                }
                else
                {
                    endScale = midScale;
                }
            }
            _label.fontSize = fontSize / (endScale * 1.05f);
            _label.dimensions = paddedLabelSize;
        }
        else
        {
            _label.dimensions = paddedLabelSize;
            _label.fontSize = _fontSize;
        }
    }
    else*/
    _label.adjustsFontSizeToFit = _owerflowType == CCTextOwerflowShrink;
    {
        _label.dimensions = paddedLabelSize;
        _label.fontSize = _fontSize;
    }
    self.contentSize = _label.contentSize;
    [super layout];
    
}

- (void)setWorldWrap:(BOOL) worldWrap
{
    _label.worldWrap = worldWrap;
    _worldWrap = worldWrap;
}

- (void) setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    [self needsLayout];
}

- (void) setAlignment:(int)alignment
{
    _label.horizontalAlignment = alignment;
    [self needsLayout];
}

- (int) alignment
{
    return _label.horizontalAlignment;
}

@end
