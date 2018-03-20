/*
 * CocosBuilder: http://www.cocosbuilder.com
 *
 * Copyright (c) 2012 Zynga Inc.
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

#import "InspectorSeparator.h"
#import "AppDelegate.h"
#import "InspectorController.h"
#import "SettingsManager.h"

@implementation InspectorSeparator

- (BOOL)isExpanded
{
    id value = [SBSettings.expandedSeparators valueForKey:propertyName];
    
    //fix, avoid to collapse custom class
    //otherwise Node if other like: Node, Sprite was closed - there is no way to open it
    NSString *customClass = [selection extraPropForKey:@"customClass"];
    if (customClass && [customClass isEqualToString:propertyName]) {
        return YES;
    }
    return !value || [value intValue] == NSOnState;
}

- (void)setIsExpanded:(BOOL)isExpanded
{
    // Finish editing
    if (![[view window] makeFirstResponder:[view window]])
    {
        return;
    }

    NSMutableDictionary *expandedSeparators = [SBSettings.expandedSeparators mutableCopy];
    [expandedSeparators setObject:@(_disclosureButton.state) forKey:propertyName];
    SBSettings.expandedSeparators = expandedSeparators;
    [SBSettings save];
    [[InspectorController sharedController] updateInspectorFromSelection];
}

- (BOOL)isSeparator
{
    return YES;
}

@end
