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

#import "CCBPText.h"

@implementation CCBPText
{
    CGFloat _fontSize;
    BOOL _needsLayout;
    BOOL _adjustsFontSizeToFit;
}

- (id) init
{
    self = [super init];
    if (!self) return NULL;
    
    _needsLayout = YES;
    _fontSize = 12;
    _adjustsFontSizeToFit = YES;
    
    return self;
}

-(void) setAdjustsFontSizeToFit:(BOOL)value
{
    _adjustsFontSizeToFit = value;
    _needsLayout = YES;
}

-(BOOL) adjustsFontSizeToFit
{
    return _adjustsFontSizeToFit;
}

/*
-(void) setContentSize:(CGSize)size
{
    self.dimensions = size;
    _needsLayout = YES;
}

-(CGSize) contentSize
{
    return self.dimensions;
}*/

- (void) layout
{
    CGSize paddedLabelSize = [self convertContentSizeToPoints:self.dimensions type:self.dimensionsType];
    
    if(_adjustsFontSizeToFit && _fontSize && self.dimensions.width && self.dimensions.height)
    {
        super.fontSize = _fontSize;
        super.dimensions = CGSizeMake(paddedLabelSize.width, 0);
        if(super.contentSize.height>paddedLabelSize.height)
        {
            float startScale = 1.0;
            float endScale = 1.0;
            float fontSize = _fontSize;
            do
            {
                super.fontSize = fontSize / (endScale * 2.0);
                startScale = endScale;
                endScale = endScale*2;
            }while (super.contentSize.height>paddedLabelSize.height);
            float midScale;
            for(int i=0;i<4;++i)
            {
                midScale = (startScale + endScale) / 2.0f;
                super.fontSize = fontSize / midScale;
                if(super.contentSize.height>paddedLabelSize.height)
                {
                    startScale = midScale;
                }
                else
                {
                    endScale = midScale;
                }
            }
            super.fontSize = fontSize / (endScale * 1.05f);
            super.dimensions = CGSizeMake(paddedLabelSize.width, paddedLabelSize.height);
        }
        else
        {
            super.dimensions = paddedLabelSize;
            super.fontSize = _fontSize;
        }
    }
    else
    {
        super.dimensions = paddedLabelSize;
        super.fontSize = _fontSize;
    }
    _needsLayout = NO;

}

- (void) visit:(CCRenderer *)renderer parentTransform:(const GLKMatrix4 *)parentTransform
{
    if (_needsLayout) [self layout];
    [super visit:renderer parentTransform:parentTransform];
}

- (void) setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    _needsLayout = true;
}

-(CGFloat) fontSize
{
    return _fontSize;
}

@end
