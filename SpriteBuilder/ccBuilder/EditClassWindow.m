/*
 *
 * Copyright (c) 2014 Martin Walsh
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "EditClassWindow.h"
#import "PlugInManager.h"
#import "PlugInNode.h"

@implementation EditClassWindow

- (id)init
{
    self = [super init];
    if (self) {
        _haveChildren = false;
        // Initialization code here.
    }
    
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    PlugInManager* pim = [PlugInManager sharedManager];
    
    NSMutableArray *plugIns = [NSMutableArray array];
    
    PlugInNode *currentPlugIn;
    
    NSArray* nodeNames = pim.plugInsNodeNames;
    for (NSString* nodeName in nodeNames)
    {
        PlugInNode* pluginNode = [pim plugInNodeNamed:nodeName];
        [plugIns addObject:pluginNode];
        if([pluginNode.className isEqualToString:_className])
            currentPlugIn = pluginNode;
    }
    
    [plugIns sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"ordering" ascending:YES]]];
    
    
    // Setup menu
    
    NSMenu* menu = [popup menu];
    [menu removeAllItems];
    
    for (PlugInNode* plugin in plugIns)
    {
        if(plugin.isJoint || plugin.isAbstract)
            continue;
        // Add to sequence selector
        NSMenuItem* item;
        item = [[NSMenuItem alloc] initWithTitle:plugin.nodeClassName action:@selector(selectedClass:) keyEquivalent:@""];
        item.target = self;
        item.representedObject = plugin.nodeClassName;
        item.enabled = !self.haveChildren || plugin.canHaveChildren || !currentPlugIn.canHaveChildren;
        [menu addItem:item];
    }
    
    [popup setTitle:_className];
}

- (void) selectedClass:(id)sender
{

    NSString* selectedTitle = [sender representedObject];
    
    [popup setTitle:selectedTitle];
    self.className = selectedTitle;
}

@end
