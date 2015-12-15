//
//  CCBPButton.m
//  SpriteBuilder
//
//  Created by Viktor on 9/25/13.
//
//

#import "CCBPButton.h"
#import "CCSpriteFrame.h"
#import "CCTexture.h"
#import "AppDelegate.h"
#import "InspectorController.h"
#import "CCSprite9Slice.h"
#import "PositionPropertySetter.h"

@implementation CCBPButton

- (id) init
{
    self = [super init];
    if (!self) return NULL;
    
    self.userInteractionEnabled = NO;
    self.zoomOnClick = 1.0f;
    
    _adjustsFontSizeToFit = YES;
    
    return self;
}

/*- (void) setContentSizeType:(CCSizeType)contentSizeType
{
    [self setPreferredSizeType:contentSizeType];
}

- (CCSizeType) contentSizeType
{
    return self.preferredSizeType;
}*/

- (NSArray*) keysForwardedToLabel
{
    return @[@"fontName",
             @"fontColor",
             @"outlineColor",
             @"outlineWidth",
             @"shadowColor",
             @"shadowBlurRadius",
             @"shadowOffset",
             @"shadowOffsetType",
             @"horizontalAlignment",
             @"verticalAlignment"];
}

- (void) setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    _needsLayout = true;
}

- (void) layout
{
    CGSize contentSize = [self convertContentSizeToPoints:self.preferredSize type:self.contentSizeType];
    CGSize paddedLabelSize = CGSizeMake(contentSize.width - self.horizontalPadding * 2, contentSize.height -  self.verticalPadding * 2);
    
    if(_adjustsFontSizeToFit && paddedLabelSize.width>0 && paddedLabelSize.height>0)
    {
        self.label.fontSize = _fontSize;
        self.label.dimensions = CGSizeMake(paddedLabelSize.width, 0);
        if(self.label.contentSize.height>paddedLabelSize.height)
        {
            float startScale = 1.0;
            float endScale = 1.0;
            float fontSize = _fontSize;
            do
            {
                self.label.fontSize = fontSize / (endScale * 2.0);
                startScale = endScale;
                endScale = endScale*2;
            }while (self.label.contentSize.height>paddedLabelSize.height);
            float midScale;
            for(int i=0;i<4;++i)
            {
                midScale = (startScale + endScale) / 2.0f;
                self.label.fontSize = fontSize / midScale;
                if(self.label.contentSize.height>paddedLabelSize.height)
                {
                    startScale = midScale;
                }
                else
                {
                    endScale = midScale;
                }
            }
            self.label.fontSize = fontSize / (endScale * 1.05f);
            self.label.dimensions = CGSizeMake(paddedLabelSize.width, paddedLabelSize.height);
        }
    }
    else
    {
        self.label.scale = 1.0f;
        self.label.dimensions = paddedLabelSize;
        self.label.fontSize = _fontSize;
    }
    
    self.background.contentSize = contentSize;
    self.background.anchorPoint = ccp(0.5f,0.5f);
    self.background.positionType = CCPositionTypeNormalized;
    self.background.position = ccp(0.5f,0.5f);
    
    self.label.positionType = CCPositionTypeNormalized;
    self.label.position = ccp(0.5f, 0.5f);
    
    _needsLayout = NO;
}

-(void) setAdjustsFontSizeToFit:(BOOL)value
{
    _adjustsFontSizeToFit = value;
    _needsLayout = YES;
}

-(void) setContentSize:(CGSize)size
{
    [self setPreferredSize:size];
    [self setMaxSize:size];
    [super setContentSize:size];
}

-(CGSize) contentSize
{
    return self.preferredSize;
}

-(void)onSetSizeFromTexture
{
    CCSpriteFrame * spriteFrame = _backgroundSpriteFrames[@(CCControlStateNormal)];
    if(spriteFrame == nil)
        return;
    
    [[AppDelegate appDelegate] saveUndoStateWillChangeProperty:@"contentSize"];
    
    self.contentSize = spriteFrame.texture.contentSize;
    self.contentSizeType = CCSizeTypeMake(CCSizeUnitPoints, CCSizeUnitPoints);
    self.maxSize = self.preferredSize;
    self.maxSizeType = self.preferredSizeType;
    
    [self willChangeValueForKey:@"contentSize"];
    [self didChangeValueForKey:@"contentSize"];
    [[InspectorController sharedController] refreshProperty:@"contentSize"];
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

@end
