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

- (void) layout
{
    _needsLayout = NO;
    if (self.direction == CCLayoutBoxDirectionHorizontal)
    {
        // Get the maximum height
        float maxHeight = 0;
        for (CCNode* child in self.children)
        {
            float height = child.contentSizeInPoints.height * [[child valueForKey:@"scaleY"] floatValue];
            if (height > maxHeight) maxHeight = height;
        }
        
        // Position the nodes
        float width = 0;
        for (CCNode* child in self.children)
        {
            if(child.visible)
            {
                CGSize childSize = child.contentSizeInPoints;
                
                childSize.width *= [[child valueForKey:@"scaleX"] floatValue];
                childSize.height *= [[child valueForKey:@"scaleY"] floatValue];
                
                CGPoint offset = CGPointMake(childSize.width/2, childSize.height/2);
                CGPoint localPos = ccp(roundf(width), roundf((maxHeight-childSize.height)/2.0f));
                CGPoint position = ccpAdd(localPos, offset);
                
                child.position = position;
                child.positionType = CCPositionTypePoints;
                
                width += childSize.width;
                width += self.spacing;
            }
        }
        
        // Account for last added increment
        width -= self.spacing;
        if (width < 0) width = 0;
        
        self.contentSizeType = CCSizeTypePoints;
        self.contentSize = CGSizeMake(roundUpToEven(width), roundUpToEven(maxHeight));
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
        
        // Position the nodes
        float height = 0;
        for (CCNode* child in self.children)
        {
            if(child.visible)
            {
                CGSize childSize = child.contentSizeInPoints;
                
                childSize.width *= [[child valueForKey:@"scaleX"] floatValue];
                childSize.height *= [[child valueForKey:@"scaleY"] floatValue];
                
                CGPoint offset = CGPointMake(childSize.width/2, childSize.height/2);
                CGPoint localPos = ccp(roundf((maxWidth-childSize.width)/2.0f), roundf(height));
                CGPoint position = ccpAdd(localPos, offset);
                
                child.position = position;
                child.positionType = CCPositionTypePoints;
                
                height += childSize.height;
                height += self.spacing;
            }
        }
        
        // Account for last added increment
        height -= self.spacing;
        if (height < 0) height = 0;
        
        self.contentSizeType = CCSizeTypePoints;
        self.contentSize = CGSizeMake(roundUpToEven(maxWidth), roundUpToEven(height));
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

@end
