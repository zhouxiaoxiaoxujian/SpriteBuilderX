//
//  CCBPTextField.m
//  SpriteBuilder
//
//  Created by Viktor on 10/24/13.
//
//

#import "CCBPTextField.h"
#import "CCControlSubclass.h"

@implementation CCBPTextField
{
    CCLabelTTF *_label;
}

- (id) init
{
    self = [super init];
    if (!self) return NULL;
    
    self.userInteractionEnabled = NO;
    
    _fontColor = [CCColor whiteColor];
    _placeholderFontColor = [CCColor whiteColor];
    
    _string = @"";
    _fontName = @"Helvetica";
    _placeholder = @"";
    _fontSize = 17;
    _maxLength = -1;
    
    _horizontalAlignment = CCTextAlignmentLeft;
    _verticalAlignment = CCVerticalTextAlignmentCenter;
    
    _label = [[CCLabelTTF alloc] initWithString:_string fontName:_fontName fontSize:_fontSize];
    _label.horizontalAlignment = _horizontalAlignment;
    _label.verticalAlignment = _verticalAlignment;
    _label.anchorPoint = CGPointMake(0, 0.5);
    _label.adjustsFontSizeToFit = NO;
    
    [self updateFont];
    
    [self addChild:_label];
    
    return self;
}

-(void) setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    [self updateFont];
}

- (void) setContentSizeType:(CCSizeType)contentSizeType
{
    [super setContentSizeType:contentSizeType];
    [self updateFont];
}

- (void)setString:(NSString*) string
{
    _string = string;
    [self updateFont];
}

- (void)setPlaceholder:(NSString*) placeholder
{
    _placeholder = placeholder;
    [self updateFont];
}

- (void)setFontColor:(CCColor*) color
{
    _fontColor = color;
    [self updateFont];
}

- (void)setFontSize:(float) fontSize
{
    _fontSize = fontSize;
    [self updateFont];
}

- (void)setPlaceholderFontColor:(CCColor*) placeholderFontColor
{
    _placeholderFontColor = placeholderFontColor;
    [self updateFont];
}

/*- (void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    [self.textField setEditable:false];
}*/

- (void)setHorizontalAlignment:(CCTextAlignment) horizontalAlignment
{
    _horizontalAlignment = horizontalAlignment;
    [self updateFont];
}

- (void)setVerticalAlignment:(CCVerticalTextAlignment) verticalAlignment
{
    _verticalAlignment = verticalAlignment;
    [self updateFont];
}

- (void) addUITextView
{}

- (void) removeUITextView
{}

- (void) updateFont
{
    _label.dimensions = self.contentSize;
    _label.dimensionsType = self.contentSizeType;
    _label.position = CGPointMake(0, self.contentSizeInPoints.height/2);
    _label.horizontalAlignment = _horizontalAlignment;
    _label.verticalAlignment = _verticalAlignment;
    _label.fontSize = self.fontSize;
    _label.fontName = self.fontName;
    if(self.string && self.string.length>0)
    {
        _label.fontColor = _fontColor;
        _label.string = self.string;
    }
    else
    {
        _label.fontColor = _placeholderFontColor;
        _label.string = self.placeholder;
    }
}

@end
