//
//  CCBPSprite9Slice.m
//  SpriteBuilder
//
//  Created by Viktor on 12/17/13.
//
//

#import "CCBPSprite9Slice.h"
#import "AppDelegate.h"
#import "InspectorController.h"

@implementation CCBPSprite9Slice


- (void)setMargin:(float)margin
{
    margin = clampf(margin, 0, 0.5);
	[super setMargin:margin];
}

// ---------------------------------------------------------------------

- (void)setMarginLeft:(float)marginLeft
{
    marginLeft = clampf(marginLeft, 0, 1);
	
	if(self.marginRight + marginLeft >= 1)
	{
		[[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The left & right margins should add up to less than 1"];
        [[InspectorController sharedController] refreshProperty:@"marginLeft"];
		return;
	}
	[super setMarginLeft:marginLeft];
}

- (void)setMarginRight:(float)marginRight
{
    marginRight = clampf(marginRight, 0, 1);
	if(self.marginLeft + marginRight >= 1)
	{
		[[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The left & right margins should add up to less than 1"];
        [[InspectorController sharedController] refreshProperty:@"marginRight"];
		
		return;
	}
	
	[super setMarginRight:marginRight];
}

- (void)setMarginTop:(float)marginTop
{
    marginTop = clampf(marginTop, 0, 1);
	if(self.marginBottom + marginTop >= 1)
	{
		[[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The top & bottom margins should add up to less than 1"];
        [[InspectorController sharedController] refreshProperty:@"marginTop"];
		return;
	}
	
	[super setMarginTop:marginTop];
   
}

- (void)setMarginBottom:(float)marginBottom
{
    marginBottom = clampf(marginBottom, 0, 1);
	if(self.marginTop + marginBottom >= 1)
	{
		[[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The top & bottom margins should add up to less than 1"];
        [[InspectorController sharedController] refreshProperty:@"marginBottom"];
		return;
	}
	
	[super setMarginBottom:marginBottom];
}

@end
