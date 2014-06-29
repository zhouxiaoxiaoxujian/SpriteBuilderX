//
//  CCBPTextField.h
//  SpriteBuilder
//
//  Created by Viktor on 10/24/13.
//
//

#import "CCTextField.h"

@interface CCBPTextField : CCTextField

/** The platform font to use for the text. */
@property (nonatomic,strong) NSString* fontName;

/** The color of the text (If not using shadow or outline). */
@property (nonatomic,strong) CCColor* fontColor;

/** The platform font to use for the text. */
@property (nonatomic,strong) NSString* placeholderFontName;

/** The font size of the text. */
@property (nonatomic,assign) float placeholderFontSize;

/** The color of the text (If not using shadow or outline). */
@property (nonatomic,strong) CCColor* placeholderFontColor;

@property (nonatomic,strong) NSString* placeholder;

@property (nonatomic,assign) int inputFlag;
@property (nonatomic,assign) int keyboardReturnType;
@property (nonatomic,assign) int inputMode;
@property (nonatomic,assign) int maxLength;

@end
