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

#import "CCProtectedNode.h"
#import "cocos2d.h"

@class CCExtLabelTTF;

typedef NS_ENUM(unsigned char, CCTextOwerflow)
{
    //In NONE mode, the dimensions is (0,0) and the content size will change dynamically to fit the label.
    CCTextOwerflowNone,
    /**
     *In CLAMP mode, when label content goes out of the bounding box, it will be clipped.
     */
    CCTextOwerflowClamp,
    /**
     * In SHRINK mode, the font size will change dynamically to adapt the content size.
     */
    CCTextOwerflowShrink,
    /**
     *In RESIZE_HEIGHT mode, you can only change the width of label and the height is changed automatically.
     */
    CCTextOwerflowResizeHeight
};

@interface CCBPLabelTTF : CCProtectedNode

// Add property to maintain backwards compatibility
@property (nonatomic,readonly) CCExtLabelTTF* label;
@property (nonatomic,assign) int alignment;
@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic,assign) BOOL adjustsFontSizeToFit;
@property (nonatomic,assign) CGSize dimensions;
@property (nonatomic,assign) CCSizeType dimensionsType;
@property (nonatomic,assign) CCTextOwerflow owerflowType;
@property (nonatomic,assign) BOOL worldWrap;

@end
