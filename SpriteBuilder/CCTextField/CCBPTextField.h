//
//  CCBPTextField.h
//  SpriteBuilder
//
//  Created by Viktor on 10/24/13.
//
//

#import "CCTextField.h"

@interface CCBPTextField : CCNode

/** The font size of the text field, defined in the unit specified by the heightUnit component of the contentSizeType. */
@property (nonatomic,assign) float fontSize;

/** The platform font to use for the text. */
@property (nonatomic,strong) NSString* fontName;

/** The color of the text (If not using shadow or outline). */
@property (nonatomic,strong) CCColor* fontColor;

/** The color of the text (If not using shadow or outline). */
@property (nonatomic,strong) CCColor* placeholderFontColor;

/** The text displayed by the text field. */
@property (nonatomic,strong) NSString* string;

@property (nonatomic,strong) NSString* placeholder;

@property (nonatomic,assign) int inputFlag;
@property (nonatomic,assign) int keyboardReturnType;
@property (nonatomic,assign) int inputMode;
@property (nonatomic,assign) int maxLength;

/** The horizontal alignment technique of the text. */
@property (nonatomic,assign) CCTextAlignment horizontalAlignment;

/** The vertical alignment technique of the text. */
@property (nonatomic,assign) CCVerticalTextAlignment verticalAlignment;

@end
