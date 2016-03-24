//
//  CCBPSlider.h
//  SpriteBuilder
//
//  Created by Viktor on 10/28/13.
//
//

#import "CCProtectedNode.h"
#import "cocos2d.h"

/**
 *  A CCSlider object is a visual control used to select a single value from a continuous range of values. An indicator, or an handle, notes the current value of the slider and can be moved by the user to change the setting.
 */

/**
 The possible states for a CCControl.
 */
typedef NS_ENUM(NSUInteger, CCBPControlState)
{
    /** The normal, or default state of a control — that is, enabled but neither selected nor highlighted. */
    CCBPControlStateNormal       = 0,
    
    /** Highlighted state of a control. A control enters this state when a touch down, drag inside or drag enter is performed. You can retrieve and set this value through the highlighted property. */
    CCBPControlStateHighlighted  = 1,
    
    /** Disabled state of a control. This state indicates that the control is currently disabled. You can retrieve and set this value through the enabled property. */
    CCBPControlStateDisabled     = 2,
};

@interface CCBPSlider : CCProtectedNode
{
    NSMutableDictionary* _handleSpriteFrames;
}
/** The background's sprite 9 slice. */
@property (nonatomic,readonly) CCSprite9Slice* background;
/** The background's sprite 9 slice. */
@property (nonatomic,readonly) CCSprite9Slice* progress;
/** The handle's sprite. */
@property (nonatomic,readonly) CCSprite* handle;

/** Sets the left margin exclusively. */
@property (nonatomic, assign) float marginLeft;

/** Sets the right margin exclusively. */
@property (nonatomic, assign) float marginRight;

/** Sets the top margin exclusively. */
@property (nonatomic, assign) float marginTop;

/** Sets the bottom margin exclusively. */
@property (nonatomic, assign) float marginBottom;

@property (nonatomic, assign) float zoomScale;


@property (nonatomic,assign) int percent;
@property (nonatomic, assign) int maxPercent;

@property (nonatomic,assign) CGFloat imageScale;

@property (nonatomic,assign) CCBPControlState state;

#pragma mark Customizing the Appearance of the Slider

/**
 *  Sets the background's sprite frame for the specified state. The sprite frame will be stretched to the preferred size of the label. If set to `NULL` no background will be drawn.
 *
 *  @param spriteFrame Sprite frame to use for drawing the background.
 *  @param state       State to set the background for.
 */
- (void) setBackgroundSpriteFrame:(CCSpriteFrame*)spriteFrame;

/**
 *  Gets the background's sprite frame for the specified state.
 *
 *  @param state State to get the sprite frame for.
 *
 *  @return Background sprite frame.
 */
- (CCSpriteFrame*) backgroundSpriteFrame;

/**
 *  Sets the background's sprite frame for the specified state. The sprite frame will be stretched to the preferred size of the label. If set to `NULL` no background will be drawn.
 *
 *  @param spriteFrame Sprite frame to use for drawing the background.
 *  @param state       State to set the background for.
 */
- (void) setProgressSpriteFrame:(CCSpriteFrame*)spriteFrame;

/**
 *  Gets the background's sprite frame for the specified state.
 *
 *  @param state State to get the sprite frame for.
 *
 *  @return Background sprite frame.
 */
- (CCSpriteFrame*) progressSpriteFrame;

/**
 *  Sets the handle's sprite frame for the specified state. If set to `NULL` no handle will be drawn.
 *
 *  @param spriteFrame Sprite frame to use for drawing the handle.
 *  @param state       State to set the handle for.
 */
- (void) setHandleSpriteFrame:(CCSpriteFrame*)spriteFrame forState:(CCBPControlState)state;

/**
 *  Gets the handle's sprite frame for the specified state.
 *
 *  @param state State to get the sprite frame for.
 *
 *  @return Handle sprite frame.
 */
- (CCSpriteFrame*) handleSpriteFrameForState:(CCBPControlState)state;

@end
