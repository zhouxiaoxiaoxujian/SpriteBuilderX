//
//  CCBPScrollView.m
//  SpriteBuilder
//
//  Created by Viktor on 12/17/13.
//
//

#import "CCBPScrollView.h"

#import "cocos2d.h"

@implementation CCBPScrollView

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
    ret = CGRectIntersection(ret, parentRect);
    return ret;
}

- (id) init
{
    self = [super init];
    self.clipContent = NO;
    return self;
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
