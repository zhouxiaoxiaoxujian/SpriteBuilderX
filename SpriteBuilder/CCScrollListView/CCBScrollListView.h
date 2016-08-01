//
//  CCScrollListView.m
//  CocosBuilder
//
//  Created by Mikhail Perekhodtsev on 8/6/13.
//
//

#import "cocos2d.h"
#import "CCScrollView.h"

@class ItemStruct;
@class IndexItem;

@interface CCBScrollListView : CCScrollView
{
    NSMutableDictionary *_items;
    NSMutableDictionary *_selectorIndex;
    NSEnumerator *_curitem;
}

-(void)RecalcPositions;
-(CCNode *)AddElement:(NSString *)name;
-(CCNode *)nodeFromTemplate;

@property (nonatomic, retain) CCNode* template;
@property (nonatomic, assign) BOOL horizontal;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger gravity;
@property (nonatomic, assign) NSInteger magnetic;

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