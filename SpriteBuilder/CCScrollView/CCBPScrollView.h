//
//  CCBPScrollView.h
//  SpriteBuilder
//
//  Created by Viktor on 12/17/13.
//
//

#import "CCScrollView.h"

@interface CCBPScrollView : CCScrollView

@property (nonatomic,assign) BOOL clipContent;
@property (nonatomic,assign) BOOL inertialScroll;
@property (nonatomic,assign) BOOL scrollBarEnabled;
@property (nonatomic,readonly) CGRect clippingRect;

@property (nonatomic,assign) CGFloat scrollBarWidth;
@property (nonatomic,assign) BOOL scrollBarAutoHideEnabled;
@property (nonatomic,assign) BOOL scrollHideIfSizeFit;
@property (nonatomic,assign) CGPoint scrollBarPosition;
@property (nonatomic,assign) CCPositionType scrollBarPositionType;
@property (nonatomic,retain) CCColor* scrollBarColor;
@property (nonatomic,assign) CGFloat scrollBarOpacity;

@end
