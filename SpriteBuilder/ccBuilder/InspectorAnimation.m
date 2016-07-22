//
//  InspectorAnimation.m
//  SpriteBuilder
//
//  Created by John Twigg on 5/26/14.
//
//

#import "InspectorAnimation.h"
#import "AppDelegate.h"
#import "CCNode+NodeInfo.h"
#import "SequencerSequence.h"

#define kCCBNullString @"<NULL>"
#define kCCBDefaultString @"<Default>"

@implementation InspectorAnimation

- (void) willBeAdded
{
    // Setup menu
    NSNumber* sf = [self propertyForSelection];
    
    NSArray *sequences = [selection extraPropForKey:@"**sequences"];
    
    NSMenu* menu = [popup menu];
    [menu removeAllItems];
    
    NSMenuItem* defaultItem = [[NSMenuItem alloc] initWithTitle:kCCBDefaultString action:@selector(selectedSequence:) keyEquivalent:@""];
    defaultItem.target = self;
    defaultItem.tag = -2;
    defaultItem.representedObject = kCCBDefaultString;
    [menu addItem:defaultItem];
    
    NSMenuItem* emptyItem = [[NSMenuItem alloc] initWithTitle:kCCBNullString action:@selector(selectedSequence:) keyEquivalent:@""];
    emptyItem.target = self;
    emptyItem.tag = -1;
    emptyItem.representedObject = kCCBNullString;
    [menu addItem:emptyItem];
    
    BOOL found = false;
    
    NSString* selectedTitle = [sf intValue] ==-2?kCCBDefaultString:kCCBNullString;
    
    for (SequencerSequence* seq in sequences)
    {
        // Add to sequence selector
        NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:seq.name action:@selector(selectedSequence:) keyEquivalent:@""];
        item.target = self;
        item.tag = seq.sequenceId;
        item.representedObject = seq.name;
        [menu addItem:item];
        if(sf && seq.sequenceId == [sf intValue])
        {
            found = YES;
            selectedTitle = seq.name;
        }
    }
    
    [popup setTitle:selectedTitle];
}

- (void) selectedSequence:(id)sender
{
    [[AppDelegate appDelegate] saveUndoStateWillChangeProperty:propertyName];
    
    NSString* selectedTitle = [sender representedObject];
    
    [popup setTitle:selectedTitle];
    [self setPropertyForSelection:@([sender tag])];
}
@end
