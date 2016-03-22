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

@interface CCBPImage : CCProtectedNode

@property (nonatomic,assign) CGFloat imageScale;
@property (nonatomic,readonly) CCSprite9Slice* background;

/** Sets the left margin exclusively. */
@property (nonatomic, assign) float marginLeft;

/** Sets the right margin exclusively. */
@property (nonatomic, assign) float marginRight;

/** Sets the top margin exclusively. */
@property (nonatomic, assign) float marginTop;

/** Sets the bottom margin exclusively. */
@property (nonatomic, assign) float marginBottom;

/** The currently displayed spriteFrame. */
//@property (nonatomic,strong) CCSpriteFrame* spriteFrame;

- (id)initWithTexture:(CCTexture *)texture rect:(CGRect)rect rotated:(BOOL)rotated;

@end
