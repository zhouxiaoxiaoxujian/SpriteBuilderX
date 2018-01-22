//
//  CCNode+PositionExtentions.h
//  SpriteBuilder
//
//  Created by Michael Daniels on 4/8/14.
//
//

#import "CCNode.h"

@interface CCProtectedNode : CCNode

/**
 *  Adds a child to the container with z-order as 0.
 *  If the child is added to a 'running' node, then 'onEnter' and 'onEnterTransitionDidFinish' will be called immediately.
 *
 *  @param node CCNode to add as a child.
 */
-(void) addProtectedChild: (CCNode*)node;

/**
 *  Adds a child to the container with a z-order.
 *  If the child is added to a 'running' node, then 'onEnter' and 'onEnterTransitionDidFinish' will be called immediately.
 *
 *  @param node CCNode to add as a child.
 *  @param z    Z depth of node.
 */
-(void) addProtectedChild: (CCNode*)node z:(NSInteger)z;

/**
 *  Adds a child to the container with z order and tag.
 *  If the child is added to a 'running' node, then 'onEnter' and 'onEnterTransitionDidFinish' will be called immediately.
 *
 *  @param node CCNode to add as a child.
 *  @param z    Z depth of node.
 *  @param name name tag.
 */
-(void) addProtectedChild: (CCNode*)node z:(NSInteger)z name:(NSString*)name;

/**
 *  Removes a child from the container forcing a cleanup. This method checks to ensure the parameter node is actually a child of this node.
 *
 *  @param child The child node to remove.
 */
-(void) removeProtectedChild:(CCNode*)child;

/**
 *  Removes a child from the container. It will also cleanup all running and scheduled actions depending on the cleanup parameter.
 *  This method checks to ensure the parameter node is actually a child of this node.
 *
 *  @param node    The child node to remove.
 *  @param cleanup Stops all scheduled events and actions.
 */
-(void) removeProtectedChild: (CCNode*)node cleanup:(BOOL)cleanup;

/**
 *  Removes a child from the container by name value forcing a cleanup.
 *
 *  @param name Name of node to be removed.
 */
-(void) removeProtectedChildByName:(NSString*)name;

/**
 *  Removes a child from the container by name value. It will also cleanup all running actions depending on the cleanup parameter
 *
 *  @param name    Name of node to be removed.
 *  @param cleanup Stops all scheduled events and actions.
 */
-(void) removeProtectedChildByName:(NSString*)name cleanup:(BOOL)cleanup;

/**
 *  Removes all children from the container forcing a cleanup.
 */
-(void) removeAllProtectedChildren;

/**
 *  Removes all children from the container and do a cleanup all running actions depending on the cleanup parameter.
 *
 *  @param cleanup Stops all scheduled events and actions.
 */
-(void) removeAllProtectedChildrenWithCleanup:(BOOL)cleanup;

-(void) sortAllProtectedChildren;

/**
 *  Used by sub-classes. This method should be called whenever the control needs to update its layout. It will force a call to the layout method at the beginning of the next draw cycle.
 */
- (void) needsLayout;

/**
 *  Used by sub classes. Override this method to do any layout needed by the component. This can include setting positions or sizes of child labels or sprites as well as the compontents contentSize.
 */
- (void) layout;

/** Array of child nodes. */
@property(nonatomic,readonly) NSArray *protectedChildren;

@end
