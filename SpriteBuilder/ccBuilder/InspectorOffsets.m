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

#import "InspectorOffsets.h"
#import "AppDelegate.h"

@implementation InspectorOffsets

- (void) setPropertyForSelection:(id)value withSuffix:(NSString*)suffix
{
    [[AppDelegate appDelegate] saveUndoStateWillChangeProperty:propertyName];
    
    [selection setValue:value forKey:[propertyName stringByAppendingString:suffix]];
    [self updateAffectedProperties];
}

- (id) propertyForSelectionWithSuffix:(NSString*)suffix
{
    return [selection valueForKey:[propertyName stringByAppendingString:suffix]];
}


- (void) setLeft:(float)left
{
    [self setPropertyForSelection:[NSNumber numberWithFloat:left] withSuffix:@"Left"];
}

- (float) left
{
    return [[self propertyForSelectionWithSuffix:@"Left"] floatValue];
}

- (void) setRight:(float)right
{
    [self setPropertyForSelection:[NSNumber numberWithFloat:right] withSuffix:@"Right"];
}

- (float) right
{
    return [[self propertyForSelectionWithSuffix:@"Right"] floatValue];
}

- (void) setTop:(float)top
{
    [self setPropertyForSelection:[NSNumber numberWithFloat:top] withSuffix:@"Top"];
}

- (float) top
{
    return [[self propertyForSelectionWithSuffix:@"Top"] floatValue];
}

- (void) setBottom:(float)bottom
{
    [self setPropertyForSelection:[NSNumber numberWithFloat:bottom] withSuffix:@"Bottom"];
}

- (float) bottom
{
    return [[self propertyForSelectionWithSuffix:@"Bottom"] floatValue];
}

- (void) refresh
{
    [self willChangeValueForKey:@"left"];
    [self didChangeValueForKey:@"left"];
    
    [self willChangeValueForKey:@"top"];
    [self didChangeValueForKey:@"top"];
    
    [self willChangeValueForKey:@"right"];
    [self didChangeValueForKey:@"right"];
    
    [self willChangeValueForKey:@"bottom"];
    [self didChangeValueForKey:@"bottom"];
    [super refresh];
}

@end
