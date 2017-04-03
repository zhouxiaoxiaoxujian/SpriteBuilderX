//
//  CCBPSprite9Slice.h
//  SpriteBuilder
//
//  Created by Viktor on 12/17/13.
//
//

#import "CCProtectedNode.h"
#import "cocos2d.h"
#import "CCBPSprite9SliceBase.h"

@interface CCBPSprite9Slice : CCProtectedNode

@property (nonatomic,readonly) CCBPSprite9SliceBase* background;

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
