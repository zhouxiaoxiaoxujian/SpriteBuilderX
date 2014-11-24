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
    _placeholderFontSize = self.fontSize;
    
    _fontName = @"Helvetica";
    _placeholderFontName = @"Helvetica";
    _placeholder = @"";
    self.fontSize = 17;
    _maxLength = -1;
    self.padding = 0;
    _placeholderFontSize = self.fontSize;
    
    _label = [[CCLabelTTF alloc] initWithString:self.string fontName:_fontName fontSize:self.fontSize];
    _label.horizontalAlignment = CCTextAlignmentLeft;
    _label.verticalAlignment = CCVerticalTextAlignmentCenter;
    _label.anchorPoint = CGPointMake(0, 0.5);
    
    [self addChild:_label];
    
    return self;
}

- (float) fontSizeInPoints
{
    if (self.contentSizeType.heightUnit == CCSizeUnitUIPoints)
    {
        return self.fontSize * [CCDirector sharedDirector].UIScaleFactor;
    }
    else
    {
        return self.fontSize;
    }
}

- (float) placeholderFontSizeInPoints
{
    if (self.contentSizeType.heightUnit == CCSizeUnitUIPoints)
    {
        return _placeholderFontSize * [CCDirector sharedDirector].UIScaleFactor;
    }
    else
    {
        return _placeholderFontSize;
    }
}

- (void)setString:(NSString*) string
{
    [super setString:string];
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
    [super setFontSize:fontSize];
    [self updateFont];
}

- (void)setPlaceholderFontSize:(float) placeholderFontSize
{
    _placeholderFontSize = placeholderFontSize;
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

- (void) addUITextView
{}

- (void) removeUITextView
{}

- (void) updateFont
{
    _label.dimensions = self.preferredSize;
    _label.dimensions = CGSizeMake(self.preferredSize.width,0);
    _label.position = CGPointMake(0, self.preferredSize.height/2);
    if(self.string && self.string.length>0)
    {
        _label.fontName = self.fontName;
        _label.fontColor = _fontColor;
        _label.fontSize = self.fontSizeInPoints;
        _label.string = self.string;
    }
    else
    {
        _label.fontName = self.placeholderFontName;
        _label.fontColor = _placeholderFontColor;
        _label.fontSize = self.placeholderFontSizeInPoints;
        _label.string = self.placeholder;
    }
}

- (void) layout
{
    [super layout];
    [self updateFont];
}

@end
