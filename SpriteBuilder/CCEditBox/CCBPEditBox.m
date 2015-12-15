//
//  CCBPTextField.m
//  SpriteBuilder
//
//  Created by Viktor on 10/24/13.
//
//

#import "CCBPEditBox.h"
#import "CCControlSubclass.h"
#import "AppDelegate.h"
#import "InspectorController.h"

@implementation CCBPEditBox
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
    
    _label = [[CCLabelTTF alloc] initWithString:_string fontName:_fontName fontSize:_fontSize];
    _label.horizontalAlignment = CCTextAlignmentLeft;
    _label.verticalAlignment = CCVerticalTextAlignmentCenter;
    _label.anchorPoint = CGPointMake(0, 0);
    _label.adjustsFontSizeToFit = NO;
    
    _background = [[CCSprite9Slice alloc] init];
    [_background setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    [_background setPosition:CGPointMake(0.0f, 0.0f)];
    CCSizeType sizeType;
    sizeType.heightUnit = CCSizeUnitNormalized;
    sizeType.widthUnit = CCSizeUnitNormalized;
    [_background setContentSizeType:sizeType];
    [_background setContentSize:CGSizeMake(1.0f, 1.0f)];
    [self addChild:_background];
    [self addChild:_label];
    
    [self updateFont];
    
    return self;
}

- (void) setBackgroundSpriteFrame:(CCSpriteFrame*)spriteFrame
{
    [_background setSpriteFrame:spriteFrame];
}

- (CCSpriteFrame*) backgroundSpriteFrame
{
    return _background.spriteFrame;
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

- (void)setFontName:(NSString*) name
{
    _fontName = name;
    [self updateFont];
}

- (void)setPlaceholderFontName:(NSString*) name
{
    _placeholderFontName = name;
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

- (void)setPlaceholderFontSize:(float) fontSize
{
    _placeholderFontSize = fontSize;
    [self updateFont];
}

- (void)setPlaceholderFontColor:(CCColor*) placeholderFontColor
{
    _placeholderFontColor = placeholderFontColor;
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
    _label.horizontalAlignment = CCTextAlignmentLeft;
    _label.verticalAlignment = CCVerticalTextAlignmentCenter;
    if(self.string && self.string.length>0)
    {
        _label.fontSize = _fontSize;
        _label.fontName = _fontName;
        _label.fontColor = _fontColor;
        _label.string = self.string;
    }
    else
    {
        _label.fontSize = _placeholderFontSize;
        _label.fontName = _placeholderFontName;
        _label.fontColor = _placeholderFontColor;
        _label.string = self.placeholder;
    }
}

- (void)setMarginLeft:(float)marginLeft
{
    self.background.marginLeft = marginLeft;
}

- (void)setMarginRight:(float)marginRight
{
    self.background.marginRight = marginRight;
}

- (void)setMarginTop:(float)marginTop
{
    self.background.marginTop = marginTop;
}

- (float)marginBottom
{
    return self.background.marginBottom;
}

- (float)marginLeft
{
    return self.background.marginLeft;
}

- (float)marginRight
{
    return self.background.marginRight;
}

- (float)marginTop
{
    return self.background.marginTop;
}

- (void)setMarginBottom:(float)marginBottom
{
    self.background.marginBottom = marginBottom;
}

-(void)onSetSizeFromTexture
{
    CCSpriteFrame * spriteFrame = self.background.spriteFrame;
    if(spriteFrame == nil)
        return;
    
    [[AppDelegate appDelegate] saveUndoStateWillChangeProperty:@"contentSize"];
    
    self.contentSize = spriteFrame.texture.contentSize;
    
    [self willChangeValueForKey:@"contentSize"];
    [self didChangeValueForKey:@"contentSize"];
    [[InspectorController sharedController] refreshProperty:@"contentSize"];
    
}


@end