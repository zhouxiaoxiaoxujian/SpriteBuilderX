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

@interface CCBPEditBox()
{
    BOOL _fontDirty;
}
@end

@implementation CCBPEditBox
{
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
    
    _fontDirty = YES;
    
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
    [self addProtectedChild:_background];
    [self addProtectedChild:_label];
    
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

-(void) visit:(CCRenderer *)renderer parentTransform:(const GLKMatrix4 *)parentTransform
{
    [super visit:renderer parentTransform:parentTransform];
    if(_fontDirty)
    {
        _label.dimensions = self.contentSizeInPoints;
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
        _fontDirty = NO;
    }
}

- (void) updateFont
{
    _fontDirty = YES;
}

- (void)setMarginLeft:(float)marginLeft
{
    marginLeft = clampf(marginLeft, 0, 1);
    
    if(self.marginRight + marginLeft >= 1)
    {
        [[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The left & right margins should add up to less than 1"];
        [[InspectorController sharedController] refreshProperty:@"marginLeft"];
        return;
    }
    [self.background setMarginLeft:marginLeft];
}

- (void)setMarginRight:(float)marginRight
{
    marginRight = clampf(marginRight, 0, 1);
    if(self.marginLeft + marginRight >= 1)
    {
        [[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The left & right margins should add up to less than 1"];
        [[InspectorController sharedController] refreshProperty:@"marginRight"];
        
        return;
    }
    
    [self.background setMarginRight:marginRight];
}

- (void)setMarginTop:(float)marginTop
{
    marginTop = clampf(marginTop, 0, 1);
    if(self.marginBottom + marginTop >= 1)
    {
        [[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The top & bottom margins should add up to less than 1"];
        [[InspectorController sharedController] refreshProperty:@"marginTop"];
        return;
    }
    
    [self.background setMarginTop:marginTop];
    
}

- (void)setMarginBottom:(float)marginBottom
{
    marginBottom = clampf(marginBottom, 0, 1);
    if(self.marginTop + marginBottom >= 1)
    {
        [[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The top & bottom margins should add up to less than 1"];
        [[InspectorController sharedController] refreshProperty:@"marginBottom"];
        return;
    }
    
    [self.background setMarginBottom:marginBottom];
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