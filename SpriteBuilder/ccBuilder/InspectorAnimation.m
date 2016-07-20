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

@implementation InspectorAnimation

- (void) willBeAdded
{
    // Setup menu
    NSString* sf = [self propertyForSelection];
    
    NSArray *sequences = [selection extraPropForKey:@"**sequences"];
    
    NSMenu* menu = [popup menu];
    [menu removeAllItems];
    
    NSMenuItem* emptyItem = [[NSMenuItem alloc] initWithTitle:kCCBNullString action:@selector(selectedSequence:) keyEquivalent:@""];
    emptyItem.target = self;
    emptyItem.tag = -1;
    emptyItem.representedObject = NULL;
    [menu addItem:emptyItem];
    
    BOOL found = false;
    
    for (SequencerSequence* seq in sequences)
    {
        // Add to sequence selector
        NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:seq.name action:@selector(selectedSequence:) keyEquivalent:@""];
        item.target = self;
        item.tag = seq.sequenceId;
        item.representedObject = seq.name;
        [menu addItem:item];
        if(sf && [seq.name isEqualToString:sf])
            found = YES;
    }

    NSString* selectedTitle = sf;
    if (!found || !selectedTitle || [selectedTitle isEqualToString:@""])
    {
        [selection setExtraProp:nil forKey:propertyName];
        selectedTitle = kCCBNullString;
    }
    
    [popup setTitle:selectedTitle];
}

- (void) selectedSequence:(id)sender
{
    [[AppDelegate appDelegate] saveUndoStateWillChangeProperty:propertyName];
    
    id item = [sender representedObject];
    
    NSString* selectedTitle = item;
    if (!selectedTitle || [selectedTitle isEqualToString:@""])
    {
        selectedTitle = kCCBNullString;
    }
    
    [popup setTitle:selectedTitle];
    [self setPropertyForSelection:item];
}
@end
