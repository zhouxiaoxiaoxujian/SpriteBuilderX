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

#import "InspectorCustom.h"
#import "CCNode+NodeInfo.h"
#import "AppDelegate.h"
#import "CustomPropSetting.h"

@implementation InspectorCustom

- (void) setText:(NSString *)text
{
    if (!text) text = @"";
    
    [[AppDelegate appDelegate] saveUndoStateWillChangeProperty:propertyName];
    [selection setCustomPropertyNamed:propertyName value:text];
    [textField setStringValue:[selection customPropertyNamed:propertyName]];
    [self updateFont];
}

- (NSString*) text
{
    NSString *dash = @"-";
    if (propertyName.length == 1 && [propertyName isEqualToString:dash]) {
        textField.hidden = YES;
        propName.hidden = YES;
        horLine.hidden = NO;        
    }
    if (propertyName.length > 1 && [[propertyName substringToIndex:1] isEqualToString:dash]) {
        textField.hidden = YES;
        horLine.hidden = NO;
        propName.hidden = NO;
        propName.alignment = NSTextAlignmentLeft;
        propName.textColor = [NSColor disabledControlTextColor];

        horLine.frame = NSMakeRect(horLine.frame.origin.x,
                                   self.view.frame.size.height - horLine.frame.size.height * 3.0,
                                   horLine.frame.size.width,
                                   horLine.frame.size.height);
        propName.frame = NSMakeRect(10,
                                    horLine.frame.origin.y - propName.frame.size.height + 2,
                                    propName.frame.size.width,
                                    propName.frame.size.height);
    }
    [self updateFont];
    return [selection customPropertyNamed:propertyName];
}

-(NSString *) title {
    NSString *dash = @"-";
    if (propertyName.length > 1 && [[propertyName substringToIndex:1] isEqualToString:dash]) {
        return [propertyName substringFromIndex:1];
    }
    return propertyName;
}

-(void) updateFont {
    bool defaultValue = NO;
    for (CustomPropSetting *setting in selection.customProperties) {
        if ([setting.name isEqualToString:propertyName]) {
            if ([setting.value isEqualToString:setting.defaultValue]) {
                defaultValue = YES;
                break;
            }
        }
    }
    if (!defaultValue) {
        propName.font = [NSFont boldSystemFontOfSize:propName.font.pointSize];
        textField.textColor = [NSColor textColor];
    } else {
        propName.font = [NSFont systemFontOfSize:propName.font.pointSize];
        textField.textColor = [NSColor disabledControlTextColor];
    }
}

@end
