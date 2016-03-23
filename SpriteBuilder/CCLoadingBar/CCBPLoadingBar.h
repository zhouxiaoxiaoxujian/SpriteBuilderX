//
//  CCBPLoadingBar.h
//  SpriteBuilder
//
//  Created by Sergey on 12/08/15.
//
//

#import "CCProtectedNode.h"
#import "cocos2d.h"

/**
 *  Declares the possible directions for laying out nodes in a CCLayoutBox.
 */
typedef NS_ENUM(NSUInteger, CCLoadingBarDirection)
{
    CCLoadingBarDirectionLeft,
    CCLoadingBarDirectionRight,
};

@interface CCBPLoadingBar : CCProtectedNode

/** Sets the left margin exclusively. */
@property (nonatomic, assign) float marginLeft;

/** Sets the right margin exclusively. */
@property (nonatomic, assign) float marginRight;

/** Sets the top margin exclusively. */
@property (nonatomic, assign) float marginTop;

/** Sets the bottom margin exclusively. */
@property (nonatomic, assign) float marginBottom;

/** Progress spriteFrame. */
@property (nonatomic,strong) CCSpriteFrame* spriteFrame;

/**
 *  The direction is either left or right.
 */
@property (nonatomic,assign) CCLoadingBarDirection direction;

/** Sets the bottom margin exclusively. */
@property (nonatomic, assign) float percentage;

/** The background's sprite 9 slice. */
@property (nonatomic,readonly) CCSprite9Slice* background;

@property (nonatomic,assign) CGFloat imageScale;

@end
