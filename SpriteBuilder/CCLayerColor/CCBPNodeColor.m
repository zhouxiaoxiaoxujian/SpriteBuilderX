//
//  CCBPLayerColor.m
//  SpriteBuilder
//
//  Created by Viktor on 9/12/13.
//
//

#import "CCBPNodeColor.h"

@implementation CCBPNodeColor

- (id) init
{
    self = [super init];
    if (!self) return NULL;
    
    self.userInteractionEnabled = NO;
    self.opacity = 1.0;
    self.color = [CCColor whiteColor];
    
    return self;
}

@end
