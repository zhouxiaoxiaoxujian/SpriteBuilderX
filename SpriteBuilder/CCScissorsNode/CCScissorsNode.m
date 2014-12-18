//
//  CCBPLayoutBox.m
//  SpriteBuilder
//
//  Created by Viktor on 12/17/13.
//
//

#import "CCScissorsNode.h"
#import "cocos2d.h"

@implementation CCScissorsNode

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
    
    CGPoint positionInWorldCoords = [self convertToWorldSpace:ccp(0, 0)];
    CGPoint rightCornerPosition = [self convertToWorldSpace:CGPointMake(self.contentSizeInPoints.width, self.contentSizeInPoints.height)];
    CGFloat contentScaleFactor = [[CCDirector sharedDirector] contentScaleFactor];
    
    positionInWorldCoords = ccpMult(positionInWorldCoords, contentScaleFactor);
    rightCornerPosition = ccpMult(rightCornerPosition, contentScaleFactor);
    
    CGRect ret = CGRectMake(positionInWorldCoords.x, positionInWorldCoords.y,(rightCornerPosition.x - positionInWorldCoords.x), (rightCornerPosition.y - positionInWorldCoords.y));
    if(!CGRectEqualToRect(parentRect, CGRectZero))
        ret = CGRectIntersection(ret, parentRect);
    return ret;
}

-(void)visit:(CCRenderer *)renderer parentTransform:(const GLKMatrix4 *)parentTransform
{

    CGPoint positionInWorldCoords = [self convertToWorldSpace:ccp(0, 0)];
    CGPoint rightCornerPosition = [self convertToWorldSpace:CGPointMake(self.contentSizeInPoints.width, self.contentSizeInPoints.height)];
    CGFloat contentScaleFactor = [[CCDirector sharedDirector] contentScaleFactor];
    
    positionInWorldCoords = ccpMult(positionInWorldCoords, contentScaleFactor);
    rightCornerPosition = ccpMult(rightCornerPosition, contentScaleFactor);
    
    
    [renderer enqueueBlock:^{
        glEnable(GL_SCISSOR_TEST);
        CGRect rect = self.clippingRect;
        glScissor(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    } globalSortOrder:0 debugLabel:nil threadSafe:YES];
    
    [super visit:renderer parentTransform:parentTransform];
    
    [renderer enqueueBlock:^{
        glDisable(GL_SCISSOR_TEST);
    } globalSortOrder:0 debugLabel:nil threadSafe:YES];
}

@end
