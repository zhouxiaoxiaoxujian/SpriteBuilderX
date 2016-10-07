//
//  CCBPSprite9Slice.h
//  SpriteBuilder
//
//  Created by Viktor on 12/17/13.
//
//

#import "CCSprite9Slice.h"
#import "CCProtectedNode.h"


typedef NS_ENUM(NSUInteger, CCBPSprite9SliceRenderingType)
{
    CCBPSprite9SliceRenderingTypeSimple,
    CCBPSprite9SliceRenderingTypeSlice,
    CCBPSprite9SliceRenderingTypeTiled,
};

@interface CCBPSprite9SliceBase : CCSprite {
}


/// -----------------------------------------------------------------------
/// @name Accessing Margin Attributes
/// -----------------------------------------------------------------------

/**
 *  Sets the margin as a normalized percentage of the total image size.
 *  If set to 0.25, 25% of the left, right, top and bottom of the image, will be unstratched.
 */
@property (nonatomic, assign) float margin;

/** Sets the left margin exclusively. */
@property (nonatomic, assign) float marginLeft;

/** Sets the right margin exclusively. */
@property (nonatomic, assign) float marginRight;

/** Sets the top margin exclusively. */
@property (nonatomic, assign) float marginTop;

/** Sets the bottom margin exclusively. */
@property (nonatomic, assign) float marginBottom;

@property (nonatomic,assign) CCBPSprite9SliceRenderingType renderingType;

@end