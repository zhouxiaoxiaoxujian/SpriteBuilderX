//
//  CCBPEditBox.h
//  SpriteBuilder
//
//  Created by Sergey on 12/11/15.
//
//

#import "CCTextField.h"

@interface CCBPEditBox : CCNode

/** The font size of the text field, defined in the unit specified by the heightUnit component of the contentSizeType. */
@property (nonatomic,assign) float fontSize;

/** The platform font to use for the text. */
@property (nonatomic,strong) NSString* fontName;

/** The color of the text (If not using shadow or outline). */
@property (nonatomic,strong) CCColor* fontColor;

/** The font size of the text field, defined in the unit specified by the heightUnit component of the contentSizeType. */
@property (nonatomic,assign) float placeholderFontSize;

/** The platform font to use for the text. */
@property (nonatomic,strong) NSString* placeholderFontName;

/** The color of the text (If not using shadow or outline). */
@property (nonatomic,strong) CCColor* placeholderFontColor;

/** The text displayed by the text field. */
@property (nonatomic,strong) NSString* string;

@property (nonatomic,strong) NSString* placeholder;

/** The sprite frame used to render the text field's background. */
@property (nonatomic,strong) CCSpriteFrame* backgroundSpriteFrame;

/** The background's sprite 9 slice. */
@property (nonatomic,readonly) CCSprite9Slice* background;

@property (nonatomic,assign) int inputFlag;
@property (nonatomic,assign) int keyboardReturnType;
@property (nonatomic,assign) int inputMode;
@property (nonatomic,assign) int maxLength;

/** Sets the left margin exclusively. */
@property (nonatomic, assign) float marginLeft;

/** Sets the right margin exclusively. */
@property (nonatomic, assign) float marginRight;

/** Sets the top margin exclusively. */
@property (nonatomic, assign) float marginTop;

/** Sets the bottom margin exclusively. */
@property (nonatomic, assign) float marginBottom;

@end