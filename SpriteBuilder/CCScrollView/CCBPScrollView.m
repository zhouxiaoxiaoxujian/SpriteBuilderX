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

/*-(void) visit:(CCRenderer *)renderer parentTransform:(const GLKMatrix4 *)parentTransform
{
    if(_clipContent)
    {
        glEnable(GL_SCISSOR_TEST);
        
        CGPoint worldPosition = [self convertToWorldSpace:CGPointZero];
        CGPoint rightCornerPosition = [self convertToWorldSpace:CGPointMake(self.contentSizeInPoints.width, self.contentSizeInPoints.height)];
        const CGFloat s = [[CCDirector sharedDirector] contentScaleFactor];
        
        glScissor(worldPosition.x,
                  worldPosition.y,
                  (rightCornerPosition.x - worldPosition.x),
                  (rightCornerPosition.y - worldPosition.y));
        
        [super visit:renderer parentTransform:parentTransform];
        
        glDisable(GL_SCISSOR_TEST);
    }
    else
    {
        [super visit:renderer parentTransform:parentTransform];
    }
}*/

@end
