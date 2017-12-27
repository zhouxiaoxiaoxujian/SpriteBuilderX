//
//  CCNode+PositionExtentions.m
//  SpriteBuilder
//
//  Created by Michael Daniels on 4/8/14.
//
//

#import "CCProtectedNode.h"
#import "CCNode_Private.h"

@interface CCProtectedNode ()
{
    BOOL _isInActiveScene;
    BOOL _needsLayout;
    NSMutableArray *_protectedChildren;
}
// lazy allocs
-(void) protectedChildrenAlloc;
// helper that reorder a child
-(void) insertProtectedChild:(CCNode*)child z:(NSInteger)z;
-(void) detachProtectedChild:(CCNode *)child cleanup:(BOOL)doCleanup;
@end

@implementation CCProtectedNode

@synthesize protectedChildren = _protectedChildren;

-(id) init
{
    if ((self=[super init]) ) {
        _isInActiveScene = NO;
    }
    
    return self;
}

-(void) onEnter
{
    [super onEnter];
    [_protectedChildren makeObjectsPerformSelector:@selector(onEnter)];
    _isInActiveScene = YES;
}

-(void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    [_protectedChildren makeObjectsPerformSelector:@selector(onEnterTransitionDidFinish)];
}

-(void) onExitTransitionDidStart
{
    [super onExitTransitionDidStart];
    [_protectedChildren makeObjectsPerformSelector:@selector(onExitTransitionDidStart)];
}

-(void) onExit
{
    [super onExit];
    _isInActiveScene = NO;
    [_protectedChildren makeObjectsPerformSelector:@selector(onExit)];
}

- (void)updateDisplayedColor:(ccColor4F) parentColor
{
    [super updateDisplayedColor:parentColor];
    
    for (CCNode* item in _protectedChildren) {
        [item updateDisplayedColor:_displayColor];
    }
}

- (void)updateDisplayedOpacity:(CGFloat)parentOpacity
{
    [super updateDisplayedOpacity:parentOpacity];
    
    for (CCNode* item in _protectedChildren) {
        [item updateDisplayedOpacity:_displayColor.a];
    }
}

- (void)cleanup
{
    [_protectedChildren makeObjectsPerformSelector:@selector(cleanup)];
    [super cleanup];
}

- (void) contentSizeChanged
{
    [super contentSizeChanged];
    
    // Update the children (if needed)
    for (CCNode* child in _protectedChildren)
    {
        if (!CCPositionTypeIsBasicPoints(child.positionType))
        {
            // This is a position type affected by content size
            child->_isTransformDirty = _isInverseDirty = YES;
        }
    }
}

-(void) viewDidResizeTo: (CGSize) newViewSize
{
    [super viewDidResizeTo:newViewSize];
    for (CCNode* child in _protectedChildren) [child viewDidResizeTo: newViewSize];
}

static inline GLKMatrix4
CCNodeTransform(CCNode *node, GLKMatrix4 parentTransform)
{
    CGAffineTransform t = [node nodeToParentTransform];
    float z = node->_vertexZ;
    
    // Convert to 4x4 column major GLK matrix.
    return GLKMatrix4Multiply(parentTransform, GLKMatrix4Make(
                                                              t.a,  t.b, 0.0f, 0.0f,
                                                              t.c,  t.d, 0.0f, 0.0f,
                                                              0.0f, 0.0f, 1.0f, 0.0f,
                                                              t.tx, t.ty,    z, 1.0f
                                                              ));
}

-(void) visit:(CCRenderer *)renderer parentTransform:(const GLKMatrix4 *)parentTransform
{
    // quick return if not visible. children won't be drawn.
    if (!_visible) return;
    
    [self layout];
    
    [self sortAllChildren];
    [self sortAllProtectedChildren];
    
    GLKMatrix4 transform = CCNodeTransform(self, *parentTransform);
    BOOL drawn = NO;
    
    for(CCNode *child in _protectedChildren){
        [child visit:renderer parentTransform:&transform];
    }
    
    for(CCNode *child in _children){
        if(!drawn && child.zOrder >= 0){
            [self draw:renderer transform:&transform];
            drawn = YES;
        }
        
        [child visit:renderer parentTransform:&transform];
    }
    
    if(!drawn) [self draw:renderer transform:&transform];
    
    // reset for next frame
    _orderOfArrival = 0;
}

// XXX: Yes, nodes might have a sort problem once every 15 days if the game runs at 60 FPS and each frame sprites are reordered.
static NSUInteger globalProtectedOrderOfArrival = 1;

// used internally to alter the zOrder variable. DON'T call this method manually
-(void) _setZOrder:(NSInteger) z
{
    _zOrder = z;
}

// helper used by reorderChild & add
-(void) insertProtectedChild:(CCNode*)child z:(NSInteger)z
{
    _isReorderChildDirty=YES;
    
    [_protectedChildren addObject:child];
    child.zOrder = z;
}

-(void) detachProtectedChild:(CCNode *)child cleanup:(BOOL)doCleanup
{
    // IMPORTANT:
    //  -1st do onExit
    //  -2nd cleanup
    if (_isInActiveScene)
    {
        [child onExitTransitionDidStart];
        [child onExit];
    }
    
    //RecursivelyIncrementPausedAncestors(child, -child->_pausedAncestors);
    //child->_pausedAncestors = 0;
    
    // If you don't do cleanup, the child's actions will not get removed and the
    // its scheduledSelectors_ dict will not get released!
    if (doCleanup)
        [child cleanup];
    
    // set parent nil at the end (issue #476)
    [child setParent:nil];
    
    //[[[CCDirector sharedDirector] responderManager] markAsDirty];
    
    [_children removeObject:child];
}

-(void) reorderProtectedChild:(CCNode*) child z:(NSInteger)z
{
    NSAssert( child != nil, @"Child must be non-nil");
    
    _isReorderChildDirty = YES;
    
    [child setOrderOfArrival:globalProtectedOrderOfArrival++];
    child.zOrder = z;
}

-(void) protectedChildrenAlloc
{
    _protectedChildren = [[NSMutableArray alloc] init];
}

/* "add" logic MUST only be on this method
 * If a class want's to extend the 'addChild' behaviour it only needs
 * to override this method
 */
-(void) addProtectedChild: (CCNode*)child z:(NSInteger)z name:(NSString*)name
{
    NSAssert( child != nil, @"Argument must be non-nil");
    NSAssert( child.parent == nil, @"child already added to another node. It can't be added again");
    
    if( ! _protectedChildren )
        [self protectedChildrenAlloc];
    
    [self insertProtectedChild:child z:z];
    
    child.name = name;
    
    [child setParent: self];
    
    [child setOrderOfArrival: globalProtectedOrderOfArrival++];
    
    
    // Update pausing parameters
    //child->_pausedAncestors = _pausedAncestors + (_paused ? 1 : 0);
    //RecursivelyIncrementPausedAncestors(child, child->_pausedAncestors);
    
    if( _isInActiveScene ) {
        [child onEnter];
        [child onEnterTransitionDidFinish];
    }
    
    //[[[CCDirector sharedDirector] responderManager] markAsDirty];
}

-(void) addProtectedChild: (CCNode*) child z:(NSInteger)z
{
    NSAssert( child != nil, @"Argument must be non-nil");
    [self addProtectedChild:child z:z name:child.name];
}

-(void) addProtectedChild: (CCNode*) child
{
    NSAssert( child != nil, @"Argument must be non-nil");
    [self addProtectedChild:child z:child.zOrder name:child.name];
}

-(void) removeProtectedChild: (CCNode*)child
{
    [self removeProtectedChild:child cleanup:YES];
}

/* "remove" logic MUST only be on this method
 * If a class wants to extend the 'removeChild' behavior it only needs
 * to override this method
 */
-(void) removeProtectedChild: (CCNode*)child cleanup:(BOOL)cleanup
{
    // explicit nil handling
    if (child == nil)
        return;
    
    NSAssert([_children containsObject:child], @"This node does not contain the specified child.");
    
    [self detachProtectedChild:child cleanup:cleanup];
}

-(void) removeProtectedChildByName:(NSString*)name
{
    [self removeProtectedChildByName:name cleanup:YES];
}

-(void) removeProtectedChildByName:(NSString*)name cleanup:(BOOL)cleanup
{
    NSAssert( name, @"Invalid name");
    
    CCNode *child = [self getChildByName:name recursively:NO];
    
    if (child == nil)
        CCLOG(@"cocos2d: removeChildByName: child not found!");
    else
        [self removeChild:child cleanup:cleanup];
}

-(void) removeAllProtectedChildren
{
    [self removeAllProtectedChildrenWithCleanup:YES];
}

-(void) removeAllProtectedChildrenWithCleanup:(BOOL)cleanup
{
    // not using detachProtectedChild improves speed here
    for (CCNode* c in _children)
    {
        // IMPORTANT:
        //  -1st do onExit
        //  -2nd cleanup
        if (_isInActiveScene)
        {
            [c onExitTransitionDidStart];
            [c onExit];
        }
        
        //RecursivelyIncrementPausedAncestors(c, -c->_pausedAncestors);
        //c->_pausedAncestors = 0;
        
        if (cleanup)
            [c cleanup];
        
        // set parent nil at the end (issue #476)
        [c setParent:nil];
        
        //[[[CCDirector sharedDirector] responderManager] markAsDirty];
        
    }
    
    [_protectedChildren removeAllObjects];
}

- (void) sortAllProtectedChildren
{
    if (_isReorderChildDirty)
    {
        [_protectedChildren sortUsingSelector:@selector(compareZOrderToNode:)];
        
        //don't need to check children recursively, that's done in visit of each child
        
        _isReorderChildDirty = NO;
        
        //[[[CCDirector sharedDirector] responderManager] markAsDirty];
        
    }
}

- (void) needsLayout
{
    _needsLayout = YES;
}

- (void) layout
{
    _needsLayout = NO;
}


@end
