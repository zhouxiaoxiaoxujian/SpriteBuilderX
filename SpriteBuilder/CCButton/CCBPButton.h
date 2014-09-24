//
//  CCBPButton.h
//  SpriteBuilder
//
//  Created by Viktor on 9/25/13.
//
//

#import "CCButton.h"

@interface CCBPButton : CCButton
-(void)onSetSizeFromTexture;

/** Sets the left margin exclusively. */
@property (nonatomic, assign) float marginLeft;

/** Sets the right margin exclusively. */
@property (nonatomic, assign) float marginRight;

/** Sets the top margin exclusively. */
@property (nonatomic, assign) float marginTop;

/** Sets the bottom margin exclusively. */
@property (nonatomic, assign) float marginBottom;

/** Sets the left offset exclusively. */
@property (nonatomic, assign) float offsetLeft;

/** Sets the right offset exclusively. */
@property (nonatomic, assign) float offsetRight;

/** Sets the top offset exclusively. */
@property (nonatomic, assign) float offsetTop;

/** Sets the bottom offset exclusively. */
@property (nonatomic, assign) float offsetBottom;

@end
