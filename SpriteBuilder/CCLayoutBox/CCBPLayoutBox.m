//
//  CCBPLayoutBox.m
//  SpriteBuilder
//
//  Created by Viktor on 12/17/13.
//
//

#import "CCBPLayoutBox.h"
#import "cocos2d.h"
#import "PositionPropertySetter.h"
#import "CCBPCCBFile.h"

@implementation CCBPLayoutBox

-(CGRect) clippingRect
{
    CCNode* parent = self;
    
    CGRect parentRect = CGRectMake(0, 0, INT_MAX, INT_MAX);
    
    while (parent)
    {
        parent = parent.parent;
        if([parent respondsToSelector:NSSelectorFromString(@"clippingRect")])
        {
            NSValue *value = [parent valueForKey:@"clippingRect"];
            if(value)
                parentRect = [value CGRectValue];
            break;
        }
    }
    
    CGRect ret;
    if(_clipContent)
    {
        CGPoint positionInWorldCoords = [self convertToWorldSpace:ccp(0, 0)];
        CGPoint rightCornerPosition = [self convertToWorldSpace:CGPointMake(self.contentSizeInPoints.width, self.contentSizeInPoints.height)];
        CGFloat contentScaleFactor = [[CCDirector sharedDirector] contentScaleFactor];
        
        positionInWorldCoords = ccpMult(positionInWorldCoords, contentScaleFactor);
        rightCornerPosition = ccpMult(rightCornerPosition, contentScaleFactor);
        
        ret = CGRectMake(positionInWorldCoords.x, positionInWorldCoords.y,(rightCornerPosition.x - positionInWorldCoords.x), (rightCornerPosition.y - positionInWorldCoords.y));
    }
    else
    {
        ret = CGRectMake(0, 0, INT_MAX, INT_MAX);
    }
    if(!CGRectEqualToRect(parentRect, CGRectZero))
        ret = CGRectIntersection(ret, parentRect);
    return ret;
}

static float roundUpToEven(float f)
{
    return ceilf(f/2.0f) * 2.0f;
}

- (CGSize) convertContentSizeToPoints:(CGSize)contentSize type:(CCSizeType)type
{
    CGSize size = CGSizeZero;
    CCDirector* director = [CCDirector sharedDirector];
    
    CCSizeUnit widthUnit = type.widthUnit;
    CCSizeUnit heightUnit = type.heightUnit;
    
    __weak CCNode *parent = _parent;
    if([parent isKindOfClass:[CCBPCCBFile class]])
        parent = parent.parent;
    
    // Width
    if (widthUnit == CCSizeUnitPoints)
    {
        size.width = contentSize.width;
    }
    else if (widthUnit == CCSizeUnitUIPoints)
    {
        size.width = director.UIScaleFactor * contentSize.width;
    }
    else if (widthUnit == CCSizeUnitNormalized)
    {
        size.width = contentSize.width * parent.contentSizeInPoints.width;
    }
    else if (widthUnit == CCSizeUnitInsetPoints)
    {
        size.width = parent.contentSizeInPoints.width - contentSize.width;
    }
    else if (widthUnit == CCSizeUnitInsetUIPoints)
    {
        size.width = parent.contentSizeInPoints.width - contentSize.width * director.UIScaleFactor;
    }
    
    // Height
    if (heightUnit == CCSizeUnitPoints)
    {
        size.height = contentSize.height;
    }
    else if (heightUnit == CCSizeUnitUIPoints)
    {
        size.height = director.UIScaleFactor * contentSize.height;
    }
    else if (heightUnit == CCSizeUnitNormalized)
    {
        size.height = contentSize.height * parent.contentSizeInPoints.height;
    }
    else if (heightUnit == CCSizeUnitInsetPoints)
    {
        size.height = parent.contentSizeInPoints.height - contentSize.height;
    }
    else if (heightUnit == CCSizeUnitInsetUIPoints)
    {
        size.height = parent.contentSizeInPoints.height - contentSize.height * director.UIScaleFactor;
    }
    
    return size;
}

- (void) layout
{
    CCNode *parent = _parent;
    if([parent isKindOfClass:[CCBPCCBFile class]])
        parent = parent.parent;
    if(!parent)
        return;
    
    _needsLayout = NO;
    
    CGSize dimensionsSize = [self convertContentSizeToPoints:self.dimensions type:self.dimensionsType];
    if (self.direction == CCLayoutBoxDirectionHorizontal)
    {
        // Get the maximum height
        float maxHeight = 0;
        for (CCNode* child in self.children)
        {
            float height = child.contentSizeInPoints.height * [[child valueForKey:@"scaleY"] floatValue];
            if (height > maxHeight) maxHeight = height;
        }
        
        if(dimensionsSize.height > 0)
            maxHeight = dimensionsSize.height;
        
        // Position the nodes
        float width = 0;
        float offset = 0;
        
        if(dimensionsSize.width > 0)
        {

            for (CCNode* child in self.children)
            {
                if(child.visible)
                {
                    CGSize childSize = child.contentSizeInPoints;
                    width += childSize.width * [[child valueForKey:@"scaleX"] floatValue];
                    width += self.spacing;
                }
            }
            if(self.children.count)
                width -= self.spacing;
            // Account for last added increment
            if (width < 0) width = 0;
            
            width = (dimensionsSize.width - width)/2;
            offset = width;
        }
        
        for (CCNode* child in self.children)
        {
            if(child.visible)
            {
                CGSize childSize = child.contentSizeInPoints;
                
                childSize.width *= [[child valueForKey:@"scaleX"] floatValue];
                childSize.height *= [[child valueForKey:@"scaleY"] floatValue];
                
                CGPoint offset = CGPointMake(childSize.width/2, childSize.height/2);
                CGPoint localPos = ccp(width, (maxHeight-childSize.height)/2.0f);
                CGPoint position = ccpAdd(localPos, offset);
                
                child.position = position;
                child.positionType = CCPositionTypePoints;
                
                width += childSize.width;
                width += self.spacing;
            }
        }
        
        // Account for last added increment
        if(self.children.count)
            width -= self.spacing;
        if (width < 0) width = 0;
        
        self.contentSizeType = CCSizeTypePoints;
        self.contentSize = CGSizeMake(roundUpToEven(width + offset), roundUpToEven(maxHeight));
        if([_parent isKindOfClass:[CCBPCCBFile class]])
        {
            _parent.contentSizeType = CCSizeTypePoints;
            _parent.contentSize = CGSizeMake(roundUpToEven(width + offset), roundUpToEven(maxHeight));
        }
        _needsLayout = NO;
    }
    else
    {
        // Get the maximum width
        float maxWidth = 0;
        for (CCNode* child in self.children)
        {
            float width = child.contentSizeInPoints.width * [[child valueForKey:@"scaleX"] floatValue];
            if (width > maxWidth) maxWidth = width;
        }
        
        if(dimensionsSize.width != 0)
            maxWidth = dimensionsSize.width;
        
        // Position the nodes
        float height = 0;
        float offset = 0;
        
        if(dimensionsSize.height > 0)
        {
            
            for (CCNode* child in self.children)
            {
                if(child.visible)
                {
                    CGSize childSize = child.contentSizeInPoints;
                    height += childSize.height * [[child valueForKey:@"scaleY"] floatValue];
                    height += self.spacing;
                }
            }
            if(self.children.count)
                height -= self.spacing;
            // Account for last added increment
            if (height < 0) height = 0;
            
            height = (dimensionsSize.height - height)/2;
            offset = height;
        }
        
        for (CCNode* child in [self.children reverseObjectEnumerator])
        {
            if(child.visible)
            {
                CGSize childSize = child.contentSizeInPoints;
                
                childSize.width *= [[child valueForKey:@"scaleX"] floatValue];
                childSize.height *= [[child valueForKey:@"scaleY"] floatValue];
                
                CGPoint offset = CGPointMake(childSize.width/2, childSize.height/2);
                CGPoint localPos = ccp((maxWidth-childSize.width)/2.0f, height);
                CGPoint position = ccpAdd(localPos, offset);
                
                child.position = position;
                child.positionType = CCPositionTypePoints;
                
                height += childSize.height;
                height += self.spacing;
            }
        }
        
        // Account for last added increment
        if(self.children.count)
            height -= self.spacing;
        if (height < 0) height = 0;
        
        self.contentSizeType = CCSizeTypePoints;
        self.contentSize = CGSizeMake(roundUpToEven(maxWidth), roundUpToEven(height + offset));
        if([_parent isKindOfClass:[CCBPCCBFile class]])
        {
            _parent.contentSizeType = CCSizeTypePoints;
            _parent.contentSize = CGSizeMake(roundUpToEven(maxWidth), roundUpToEven(height + offset));
        }
        _needsLayout = NO;
    }
}

-(void)visit:(CCRenderer *)renderer parentTransform:(const GLKMatrix4 *)parentTransform
{
    if(_clipContent)
    {
        CGPoint positionInWorldCoords = [self convertToWorldSpace:ccp(0, 0)];
        CGPoint rightCornerPosition = [self convertToWorldSpace:CGPointMake(self.contentSizeInPoints.width, self.contentSizeInPoints.height)];
        CGFloat contentScaleFactor = [[CCDirector sharedDirector] contentScaleFactor];
        
        positionInWorldCoords = ccpMult(positionInWorldCoords, contentScaleFactor);
        rightCornerPosition = ccpMult(rightCornerPosition, contentScaleFactor);
        
        
        [renderer enqueueBlock:^{
            glEnable(GL_SCISSOR_TEST);
            glScissor(positionInWorldCoords.x, positionInWorldCoords.y,(rightCornerPosition.x - positionInWorldCoords.x), (rightCornerPosition.y - positionInWorldCoords.y));
        } globalSortOrder:0 debugLabel:nil threadSafe:YES];
        
        [super visit:renderer parentTransform:parentTransform];
        
        [renderer enqueueBlock:^{
            glDisable(GL_SCISSOR_TEST);
        } globalSortOrder:0 debugLabel:nil threadSafe:YES];
    }
    else
    {
        [super visit:renderer parentTransform:parentTransform];
    }
}

- (void) setDimensionsType:(CCSizeType)dimensionsType
{
    _dimensionsType = dimensionsType;
    [self needsLayout];
}

- (void) setDimensions:(CGSize)dimensions
{
    _dimensions = dimensions;
    [self needsLayout];
}

@end
