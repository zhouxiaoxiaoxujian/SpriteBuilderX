//
//  CCLabelTTF.m
//  SpriteBuilder
//
//  Created by Sergey on 09/01/17.
//
//

#import "CCBPGradientLabelBase.h"
#import "CCDirector.h"
#include "ccUtils.h"
#import "NSAttributedString+CCAdditions.h"
#import "CCTexture_Private.h"

@implementation CCBPGradientLabelBase

- (id) init
{
    if ( (self = [super init]) )
    {
        self.gradientColor1 = [CCColor redColor];
        self.gradientColor2 = [CCColor blueColor];
    }
    return self;
    
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (void) setGradientColor1:(CCColor *)gradientColor1
{
    _gradientColor1 = gradientColor1;
    [self performSelector:@selector(setTextureDirty)];
}

- (void) setGradientColor2:(CCColor *)gradientColor2
{
    _gradientColor2 = gradientColor2;
    [self performSelector:@selector(setTextureDirty)];
}

- (void) setGradientType:(CCGradientLabelGradientType)gradientType
{
    _gradientType = gradientType;
    [self performSelector:@selector(setTextureDirty)];
}

#pragma clang diagnostic pop

- (CGSize) sizeForAttributedString:(NSAttributedString *)attrString constrainedToSize:(CGSize) size {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    
    CFRange suggestedRange;
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, size,  &suggestedRange);
    CFRelease(framesetter);
    
    return suggestedSize;
}

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

- (void) drawGradientStringWithSize:(CGSize)size inRect:(CGRect)rect context:(CGContextRef)context
{
    NSMutableAttributedString* maskAttributedString = [self.attributedString mutableCopy];
    NSMutableAttributedStringFixPlatformSpecificAttributes(maskAttributedString, [CCColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:self.fontColor.alpha], self.fontName, self.fontSize * [CCDirector sharedDirector].contentScaleFactor, self.horizontalAlignment);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceGray();
    CGContextRef maskContext = CGBitmapContextCreate(NULL, size.width, size.height, 8, size.width, colorspace, 0);
    CGColorSpaceRelease(colorspace);
    [self drawAttributedString:maskAttributedString inContext:maskContext inRect:rect];
    CGImageRef alphaMask = CGBitmapContextCreateImage(maskContext);
    CGContextRelease(maskContext);
    
    // Create a gradient from white to red
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat colors [] = {
        self.gradientColor1.red * self.fontColor.red, self.gradientColor1.green * self.fontColor.green, self.gradientColor1.blue * self.fontColor.blue, self.gradientColor1.alpha,
        self.gradientColor2.red * self.fontColor.red, self.gradientColor2.green * self.fontColor.green, self.gradientColor2.blue * self.fontColor.blue, self.gradientColor2.alpha,
    };
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, locations, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, CGRectMake(0, 0, size.width, size.height), alphaMask);
    
    CGPoint startPoint;
    CGPoint endPoint;
    if(_gradientType == CCGradientLabelGradientTypeHorizontal)
    {
        startPoint = CGPointMake(0, size.height/2);
        endPoint = CGPointMake(size.width, size.height/2);
    }
    else
    {
        startPoint = CGPointMake(size.width/2, 0);
        endPoint = CGPointMake(size.width/2, size.height);
    }
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    
    CGContextRestoreGState(context);
    CGImageRelease(alphaMask);
}

- (BOOL) updateTexture
{
    if (!self.attributedString) return NO;
    if (!_isTextureDirty) return NO;
    
    _isTextureDirty = NO;
    
#if __CC_PLATFORM_IOS
    // Handle fonts on iOS 5
    if ([CCConfiguration sharedConfiguration].OSVersion < CCSystemVersion_iOS_6_0)
    {
        return [self updateTextureOld];
    }
#endif
    
    NSMutableAttributedString* formattedAttributedString = [self.attributedString mutableCopy];
    
    BOOL useFullColor = YES;
    
    NSMutableAttributedStringFixPlatformSpecificAttributes(formattedAttributedString, self.fontColor, self.fontName, self.fontSize, self.horizontalAlignment);
    
    
    // Generate a new texture from the attributed string
    CCTexture *tex;
    
    tex = [self createTextureWithAttributedString:NSAttributedStringCopyAdjustedForContentScaleFactor(formattedAttributedString)
                                     useFullColor:useFullColor];
    
    if(!tex) return NO;
    
    self.shader = (useFullColor ? [CCShader positionTextureColorShader] : [CCShader positionTextureA8ColorShader]);
    
    // Update texture and content size
    [self setTexture:tex];
    
    CGRect rect = CGRectZero;
    rect.size = [self.texture contentSize];
    [self setTextureRect: rect];
    
    return YES;
    
}

- (CCTexture*) createTextureWithAttributedString:(NSAttributedString*)attributedString useFullColor:(BOOL) fullColor
{
    fullColor = YES;
    self.shader = [CCShader positionTextureColorShader];
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
    if (dimensions.width == 0)
    {
        // Get dimensions for string without dimensions
        dimensions = [self sizeForAttributedString:attributedString constrainedToSize:dimensions];
        
        dimensions.width = ceil(dimensions.width);
        dimensions.height = ceil(dimensions.height);
        
        wDrawArea = dimensions.width;
        hDrawArea = dimensions.height;
        
        dimensions.width += xPadding * 2;
        dimensions.height += yPadding * 2;
    }
    else if (dimensions.height == 0 && dimensions.width > 0)
    {
        // Get dimensions for string with variable height
        CGSize actualSize = [self sizeForAttributedString:attributedString constrainedToSize:dimensions];
        
        dimensions.width = ceil(dimensions.width);
        dimensions.height = ceil(actualSize.height);
        
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
                // This is a string that can be resized (it only uses one font and size)
                CGSize wantedSize = [self sizeForAttributedString:attributedString constrainedToSize:CGSizeZero];
                
                CGFloat wScaleFactor = 1;
                CGFloat hScaleFactor = 1;
                if (wantedSize.width > wDrawArea)
                {
                    wScaleFactor = wDrawArea/wantedSize.width;
                }
                if (wantedSize.height > hDrawArea)
                {
                    hScaleFactor = hDrawArea/wantedSize.height;
                }
                
                if (wScaleFactor < hScaleFactor) scaleFactor = wScaleFactor;
                else scaleFactor = hScaleFactor;
                
                if (scaleFactor != 1)
                {
                    CGFloat newFontSize = fontSize * scaleFactor;
                    CGFloat minFontSize = self.minimumFontSize * scale;
                    if (minFontSize && newFontSize < minFontSize) newFontSize = minFontSize;
                    attributedString = NSAttributedStringCopyWithNewFontSize(attributedString, newFontSize);
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
        [self drawGradientStringWithSize:dimensions inRect:drawArea context:context];
        
    } else if (hasShadow && !hasOutline) {
        CGContextSaveGState(context);
        CCColor *tempColor = [CCColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        NSMutableAttributedString* tempAttributedString = [self.attributedString mutableCopy];
        NSMutableAttributedStringFixPlatformSpecificAttributes(tempAttributedString, tempColor, self.fontName, self.fontSize * [CCDirector sharedDirector].contentScaleFactor, self.horizontalAlignment);

        [self applyShadowOnContext:context color:self.shadowColor.CGColor blurRadius:shadowBlurRadius offset:CGPointMake(shadowOffset.x - dimensions.width, shadowOffset.y)];
        [self drawAttributedString:tempAttributedString inContext:context inRect:CGRectMake(xOffset + dimensions.width, yOffset, wDrawArea, hDrawArea)];
        CGContextRestoreGState(context);
        [self drawGradientStringWithSize:dimensions inRect:drawArea context:context];
        
    } else if (!hasShadow && hasOutline) {
        CGContextSaveGState(context);
        [self applyOutlineOnContext:context color:self.outlineColor.CGColor width:outlineWidth];
        [self drawAttributedString:attributedString inContext:context inRect:drawArea];
        CGContextRestoreGState(context);
        [self drawGradientStringWithSize:dimensions inRect:drawArea context:context];
        
        
    } else if (hasShadow && hasOutline) {
        CGContextSaveGState(context);
        CCColor *tempColor = [CCColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        NSMutableAttributedString* tempAttributedString = [self.attributedString mutableCopy];
        NSMutableAttributedStringFixPlatformSpecificAttributes(tempAttributedString, tempColor, self.fontName, self.fontSize * [CCDirector sharedDirector].contentScaleFactor, self.horizontalAlignment);
        
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        CGContextRef tempContext = CGBitmapContextCreate(NULL, POTSize.width, POTSize.height, 8, POTSize.width * 4, colorspace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorspace);
        
        [self applyOutlineOnContext:tempContext color:tempColor.CGColor width:outlineWidth];
        CGContextSetTextDrawingMode(tempContext, kCGTextFillStroke);
        [self drawAttributedString:tempAttributedString inContext:tempContext inRect:drawArea];
        
        CGImageRef shadowImage = CGBitmapContextCreateImage(tempContext);
        CGContextRelease(tempContext);
        
        [self applyShadowOnContext:context color:self.shadowColor.CGColor blurRadius:shadowBlurRadius offset:CGPointMake(shadowOffset.x - POTSize.width, shadowOffset.y)];
        CGContextDrawImage(context, CGRectMake(POTSize.width, 0, POTSize.width, POTSize.height), shadowImage);
        CGImageRelease(shadowImage);
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        [self applyOutlineOnContext:context color:self.outlineColor.CGColor width:outlineWidth];
        [self drawAttributedString:attributedString inContext:context inRect:drawArea];
        CGContextRestoreGState(context);
        [self applyShadowOnContext:context color:self.shadowColor.CGColor blurRadius:shadowBlurRadius offset:CGPointMake(shadowOffset.x, shadowOffset.y)];
        [self drawGradientStringWithSize:dimensions inRect:drawArea context:context];
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
