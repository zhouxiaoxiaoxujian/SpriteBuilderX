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

@property (nonatomic,assign) BOOL clipContent;
@property (nonatomic,readonly) CGRect clippingRect;

@end