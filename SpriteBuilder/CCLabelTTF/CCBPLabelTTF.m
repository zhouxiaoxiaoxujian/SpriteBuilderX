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
#import "CCBPGradientLabelBase.h"

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
        _label = [[CCBPGradientLabelBase alloc] init];
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
             @"shadowOffsetType",
             @"gradientColor1",
             @"gradientColor2",
             @"gradientType"];
}

-(CGPoint)shadowOffsetInPoints
{
    return [_label shadowOffsetInPoints];
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
    
    if(_adjustsFontSizeToFit && _fontSize && paddedLabelSize.width && paddedLabelSize.height)
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
    else
    {
        _label.dimensions = paddedLabelSize;
        _label.fontSize = _fontSize;
    }
    self.contentSize = _label.contentSize;
    [super layout];
    
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
