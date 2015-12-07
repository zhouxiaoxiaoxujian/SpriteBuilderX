//
//  CCBPSlider.h
//  SpriteBuilder
//
//  Created by Viktor on 10/28/13.
//
//

#import "CCSlider.h"

@interface CCBPSlider : CCSlider

/** Sets the left margin exclusively. */
@property (nonatomic, assign) float marginLeft;

/** Sets the right margin exclusively. */
@property (nonatomic, assign) float marginRight;

/** Sets the top margin exclusively. */
@property (nonatomic, assign) float marginTop;

/** Sets the bottom margin exclusively. */
@property (nonatomic, assign) float marginBottom;

/** Progress spriteFrame. */
@property (nonatomic,strong) CCSpriteFrame* progressSpriteFrame;

@property (nonatomic, assign) float zoomScale;

@property (nonatomic, assign) int maxPercent;

@end
