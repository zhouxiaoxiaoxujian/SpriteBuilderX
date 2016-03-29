//
//  CCScrollListView.m
//  CocosBuilder
//
//  Created by Mikhail Perekhodtsev on 8/6/13.
//
//

#import "CCBScrollListView.h"
#import "NodeGraphPropertySetter.h"
#import "CCBGlobals.h"
#import "AppDelegate.h"
#import "ResourceManager.h"
#import "CCBDocument.h"
#import "CCBReaderInternal.h"
#import "CCNode+NodeInfo.h"
#import "SequencerSequence.h"

@interface ItemStruct : NSObject
    @property (nonatomic, retain) CCNode *item;
    @property (nonatomic, retain) NSMutableDictionary *variables;
    @property (nonatomic, retain) NSMutableArray *selectors;
@end

@implementation ItemStruct
@end

@interface IndexItem : NSObject
    @property (nonatomic, retain) NSString *item;
    @property (nonatomic, retain) NSString *selector;
@end

@implementation IndexItem
@end

@implementation CCBScrollListView

-(id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _items = [[NSMutableDictionary alloc] init];
    
    _gravity = 0;
    
    return self;
}

-(void)RecalcPositions
{
    if (self.contentNode.children.count == 0) {
        return;
    }
    
    int num = 0;
    NSInteger childrenCount = self.contentNode.children.count;
    
    CCNode *node = [self.contentNode.children objectAtIndex:0];
    if (!node) {
        return;
    }
    
    CGSize contentsize = node.contentSizeInPoints;
    CGSize viewsize = self.contentSizeInPoints;
    
    if (_horizontal) {
        float yoffset = 0;
        
        switch (_gravity) {
            case 3:
            {
                yoffset = viewsize.height - contentsize.height;
                break;
            }
            case 4:
            {
                yoffset = 0;
                break;
            }
            case 5:
            {
                yoffset = viewsize.height/2 - contentsize.height/2;
                break;
            }
            default:
                break;
        }
        
        for (CCNode *pChild in self.contentNode.children) {
            pChild.position = ccp(pChild.contentSizeInPoints.width * num, yoffset);
            ++num;
        }
        
        //self.contentNode.position = ccp(0, -(viewsize.height - contentsize.height - yoffset));
        [self.contentNode setContentSize:CGSizeMake(MAX(contentsize.width * childrenCount, viewsize.width),
                                        MAX(contentsize.height, viewsize.height))];

        self.horizontalScrollEnabled = YES;
        self.verticalScrollEnabled = NO;
    }
    else {
        
        float xoffset = 0;
        switch (_gravity) {
            case 2:
            {
                xoffset = viewsize.width/2 - contentsize.width/2;
                break;
            }
            case 0:
            {
                xoffset = 0;
                break;
            }
            case 1:
            {
                xoffset = viewsize.width - contentsize.width;
                break;
            }
            default:
                break;
        }
        
        
        for (CCNode *pChild in self.contentNode.children) {
            pChild.position = ccp(xoffset, viewsize.height - pChild.contentSizeInPoints.height*(0.5f + num));
            ++num;
        }
        //self.contentNode.position = ccp(xoffset, -(viewsize.height - contentsize.height*childrenCount));
        
        [self.contentNode setContentSize:CGSizeMake(MAX(contentsize.width, viewsize.width),
                                        MAX(contentsize.height, viewsize.height))];

        self.horizontalScrollEnabled = NO;
        self.verticalScrollEnabled = YES;
    }
}

-(void) visit
{
    [self RecalcPositions];
    [super visit];
}

-(CCNode *)AddElement:(NSString *)name
{
    if ([_items objectForKey:name]) {
        return nil;
    }
    
    CCNode *node = [self nodeFromTemplate];
    if (!node) {
        return nil;
    }
    
    ItemStruct *item = [[ItemStruct alloc] init];
    item.item = node;
    [self.contentNode addChild:node];
    
    return node;
}

-(void)setCount:(NSInteger)count
{
    _count = count;
    [self.contentNode removeAllChildren];
    [_items removeAllObjects];
    for (int i = 0; i < count; i++) {
        [self AddElement:[NSString stringWithFormat:@"name%d", i]];
    }
    
    [self RecalcPositions];
}

-(void)setTemplate:(CCNode *)template
{
    _template = template;
    [self RecalcPositions];
}

-(void)setHorizontal:(BOOL)horizontal
{
    _horizontal = horizontal;
    [self RecalcPositions];
}

-(void)setGravity:(NSInteger)gravity
{
    _gravity = gravity;
    [self RecalcPositions];
}

-(void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    [self RecalcPositions];
}

-(CCNode *)nodeFromTemplate
{
    NSString *ccbFileName = [self extraPropForKey:@"template"];;
    CCNode* ccbFile = NULL;
    NSMutableArray* sequences = [NSMutableArray array];
    int startSequence = -1;
    CGSize parentSize = self.contentSize;
    
    if (ccbFileName && ![ccbFileName isEqualToString:@""])
    {
        AppDelegate* ad = [AppDelegate appDelegate];
        NSString* ccbFileNameAbs = [[ResourceManager sharedManager] toAbsolutePath:ccbFileName];
        
        // Check that it's not the current document (or we get an inifnite loop)
        if (![ad.currentDocument.filePath isEqualToString:ccbFileNameAbs])
        {
            // Load document dictionary
            NSMutableDictionary* doc = [NSMutableDictionary dictionaryWithContentsOfFile:ccbFileNameAbs];
            
            // Verify doc type and version
            if ([[doc objectForKey:@"fileType"] isEqualToString:@"CocosBuilder"]
                && [[doc objectForKey:@"fileVersion"] intValue] <= kCCBFileFormatVersion)
            {
                // Parse the node graph
                ccbFile = [CCBReaderInternal nodeGraphFromDictionary:[doc objectForKey:@"nodeGraph"] parentSize:parentSize fileVersion:[[doc objectForKey:@"fileVersion"] intValue]];
            }
            
            // Get first timeline
            NSArray* sequenceDicts = [doc objectForKey:@"sequences"];
            for (NSDictionary* seqDict in sequenceDicts)
            {
                SequencerSequence* seq = [[SequencerSequence alloc] initWithSerialization:seqDict];
                [sequences addObject:seq];
                
                if (seq.autoPlay) startSequence = seq.sequenceId;
            }
        }
    }

    return ccbFile;
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

- (NSArray*) ccbExcludePropertiesForSave
{
    return [NSArray arrayWithObjects:
                @"count",
                nil];
}

@end
