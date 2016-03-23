//
//  CCBPButton.h
//  SpriteBuilder
//
//  Created by Viktor on 9/25/13.
//
//

#import "CCProtectedNode.h"
#import "cocos2d.h"

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

@interface CCBPButton : CCProtectedNode
{
    NSMutableDictionary* _backgroundSpriteFrames;
    NSMutableDictionary* _backgroundColors;
    NSMutableDictionary* _backgroundOpacities;
    NSMutableDictionary* _labelColors;
    NSMutableDictionary* _labelOpacities;
    float _originalScaleX;
    float _originalScaleY;
    
    float _originalHitAreaExpansion;
}

@property (nonatomic,readonly) CCSprite9Slice* background;
@property (nonatomic,readonly) CCLabelTTF* label;
@property (nonatomic,assign) float horizontalPadding;
@property (nonatomic,assign) float verticalPadding;
@property (nonatomic,strong) NSString* title;
@property (nonatomic,assign) BOOL togglesSelectedState;

/// -----------------------------------------------------------------------
/// @name Creating Buttons
/// -----------------------------------------------------------------------

/**
 *  Initializes a new button with a title and no background. Uses default font and font size.
 *
 *  @param title The title text of the button.
 *
 *  @return A new button.
 */
- (id) initWithTitle:(NSString*) title;

/**
 *  Initializes a new button with a title and no background.
 *
 *  @param title    The title text of the button.
 *  @param fontName Name of the TTF font to use for the title label.
 *  @param size     Font size for the title label.
 *
 *  @return A new button.
 */
- (id) initWithTitle:(NSString *)title fontName:(NSString*)fontName fontSize:(float)size;

/**
 *  Initializes a new button with the specified title for the label and sprite frame for its background.
 *
 *  @param title       The title text of the button.
 *  @param spriteFrame Stretchable background image.
 *
 *  @return A new button.
 */
- (id) initWithTitle:(NSString*) title spriteFrame:(CCSpriteFrame*) spriteFrame;

/**
 *  Initializes a new button with the speicified title for the label, sprite frames for its background in different states.
 *
 *  @param title       The title text of the button.
 *  @param spriteFrame Stretchable background image for the normal state.
 *  @param highlighted Stretchable background image for the highlighted state.
 *  @param disabled    Stretchable background image for the disabled state.
 *
 *  @return A new button.
 */
- (id) initWithTitle:(NSString*) title spriteFrame:(CCSpriteFrame*) spriteFrame highlightedSpriteFrame:(CCSpriteFrame*) highlighted disabledSpriteFrame:(CCSpriteFrame*) disabled;

/**
 *  Sets the background color for the specified state. The color is multiplied into the background sprite frame.
 *
 *  @param color Color applied to background image.
 *  @param state State to apply the color to.
 */
- (void) setBackgroundColor:(CCColor*) color forState:(CCBPControlState) state;

/**
 *  Gets the background color for the specified state.
 *
 *  @param state State to get the color for.
 *
 *  @return Background color.
 */
- (CCColor*) backgroundColorForState:(CCBPControlState)state;

/**
 *  Sets the background's opacity for the specified state.
 *
 *  @param opacity Opacity to apply to the background image
 *  @param state   State to apply the opacity to.
 */
- (void) setBackgroundOpacity:(CGFloat) opacity forState:(CCBPControlState) state;

/**
 *  Gets the background opacity for the specified state.
 *
 *  @param state State to get the opacity for.
 *
 *  @return Opacity.
 */
- (CGFloat) backgroundOpacityForState:(CCBPControlState)state;

/**
 *  Sets the label's color for the specified state.
 *
 *  @param color Color applied to the label.
 *  @param state State to set the color for.
 */
- (void) setLabelColor:(CCColor*) color forState:(CCBPControlState) state;

/**
 *  Gets the label's color for the specified state.
 *
 *  @param state State to get the color for.
 *
 *  @return Label color.
 */
- (CCColor*) labelColorForState:(CCBPControlState) state;

/**
 *  Sets the label's opacity for the specified state.
 *
 *  @param opacity Opacity applied to the label.
 *  @param state   State to set the opacity for.
 */
- (void) setLabelOpacity:(CGFloat) opacity forState:(CCBPControlState) state;

/**
 *  Gets the label's opacity for the specified state.
 *
 *  @param state State to get the opacity for.
 *
 *  @return Label opacity.
 */
- (CGFloat) labelOpacityForState:(CCBPControlState) state;

/**
 *  Sets the background's sprite frame for the specified state. The sprite frame will be stretched to the preferred size of the label. If set to `NULL` no background will be drawn.
 *
 *  @param spriteFrame Sprite frame to use for drawing the background.
 *  @param state       State to set the background for.
 */
- (void) setBackgroundSpriteFrame:(CCSpriteFrame*)spriteFrame forState:(CCBPControlState)state;

/**
 *  Gets the background's sprite frame for the specified state.
 *
 *  @param state State to get the sprite frame for.
 *
 *  @return Background sprite frame.
 */
- (CCSpriteFrame*) backgroundSpriteFrameForState:(CCBPControlState)state;

/** Sets the left margin exclusively. */
@property (nonatomic, assign) float marginLeft;

/** Sets the right margin exclusively. */
@property (nonatomic, assign) float marginRight;

/** Sets the top margin exclusively. */
@property (nonatomic, assign) float marginTop;

/** Sets the bottom margin exclusively. */
@property (nonatomic, assign) float marginBottom;

/** Sets the left margin exclusively. */
@property (nonatomic, assign) float offsetLeft;

/** Sets the right margin exclusively. */
@property (nonatomic, assign) float offsetRight;

/** Sets the top margin exclusively. */
@property (nonatomic, assign) float offsetTop;

/** Sets the bottom margin exclusively. */
@property (nonatomic, assign) float offsetBottom;

@property (nonatomic, assign) float zoomOnClick;

@property (nonatomic,assign) BOOL adjustsFontSizeToFit;

@property (nonatomic,assign) CGFloat fontSize;

@property (nonatomic,assign) float leftPadding;
@property (nonatomic,assign) float rightPadding;
@property (nonatomic,assign) float topPadding;
@property (nonatomic,assign) float bottomPadding;

@property (nonatomic,assign) CCBPControlState state;

@property (nonatomic,assign) CGFloat imageScale;

@end
