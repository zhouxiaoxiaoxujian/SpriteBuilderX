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

#import "CCBPCCBFile.h"
#import "ResourceManager.h"
#import "CCBReaderInternal.h"
#import "CCBGlobals.h"
#import "CCBDocument.h"
#import "AppDelegate.h"
#import "CCNode+NodeInfo.h"
#import "PlugInNode.h"

#import "SequencerHandler.h"
#import "SequencerSequence.h"
#import "SequencerNodeProperty.h"

@implementation CCBPCCBFile

@synthesize ccbFile;

- (id) init
{
    self = [super init];
    if (!self) return NULL;
    
    return self;
}

- (void) setCcbFile:(CCNode *)cf
{
    ccbFile = cf;
    
    [self removeAllChildrenWithCleanup:YES];
    if (cf)
    {
        [self addChild:cf];
        self.contentSizeType = ccbFile.contentSizeType;
        self.contentSize = ccbFile.contentSize;
        self.anchorPoint = ccbFile.anchorPoint;
        cf.anchorPoint = ccp(0,0);
    }
    else
    {
        self.contentSize = CGSizeZero;
        self.anchorPoint = ccp(0,0);
    }
}

- (id) extraPropForKey:(NSString *)key
{
    if ([key isEqualToString:@"customClass"] && ccbFile)
    {
        return [ccbFile extraPropForKey:@"customClass"];
    }
    else if ([key isEqualToString:@"**sequences"] && ccbFile)
    {
        return [ccbFile extraPropForKey:@"*sequences"];
    }
    else if  ([key isEqualToString:@"**startSequence"] && ccbFile)
    {
        return [ccbFile extraPropForKey:@"*startSequence"];
    }
    else
    {
        if ([key containsString:@"@"])
        {
            NSArray *ar = [key componentsSeparatedByString:@"@"];
            
            CCNode *ret = [ccbFile findNodeWithUUID:[ar[0] integerValue]];
            if(ret)
            {
                return [ret extraPropForKey:ar[1]];
            }
            return nil;
        }
        return [super extraPropForKey:key];
    }
}

- (void) setExtraProp:(id)prop forKey:(NSString *)key
{
    if ([key containsString:@"@"])
    {
        NSArray *ar = [key componentsSeparatedByString:@"@"];
        
        CCNode *ret = [ccbFile findNodeWithUUID:[ar[0] integerValue]];
        if(ret)
        {
            [ret setExtraProp:prop forKey:ar[1]];
        }
        return;
    }
    [super setExtraProp:prop forKey:key];
}

+ (BOOL)isDisabledProperty:(NSString *)name node:(CCNode*)node
{
    SequencerSequence *sequence = [SequencerHandler sharedHandler].currentSequence;
    SequencerNodeProperty *sequencerNodeProperty = [node sequenceNodeProperty:name sequenceId:sequence.sequenceId];
    
    // Do not disable if animation hasn't been enabled
    if (!sequencerNodeProperty)
    {
        return NO;
    }
    
    // Do not disable if we are currently at a keyframe or beore
    if(![sequencerNodeProperty activeKeyframeAtTime:sequence.timelinePosition])
    {
        return NO;
    }
    else
    {
        if ([sequencerNodeProperty keyframeAtTime:sequence.timelinePosition] && ![name isEqualToString:@"visible"])
            return NO;
    }
    
    // Between keyframes - disable
    return YES;
}

- (void) setValue:(id)value forKey:(NSString *)key
{
    if ([key containsString:@"@"])
    {
        NSArray *ar = [key componentsSeparatedByString:@"@"];
        
        CCNode *ret = [ccbFile findNodeWithUUID:[ar[0] integerValue]];
        if(ret)
        {
            NSString *name = ar[1];
            id baseValue = [ret baseValueForProperty:name];
            if (baseValue)
            {
                NSDictionary* propInfo = [ret.plugIn.nodePropertiesDict objectForKey:name];
                NSString *type = propInfo[@"type"];
                if([type isEqualToString:@"Position"])
                {
                    NSArray* encodedVal = [NSArray arrayWithObjects:
                                          @([value pointValue].x),
                                          @([value pointValue].y),
                                          NULL];
                    [ret setBaseValue:encodedVal forProperty:name];
                }
                else
                {
                    [ret setBaseValue:value forProperty:name];
                }
            }
            if(![CCBPCCBFile isDisabledProperty:name node:ret])
                [ret setValue:value forKey:name];
        }
        return;
    }
    [super setValue:value forKey:key];
}

- (id) valueForKey:(NSString *)key
{
    if ([key containsString:@"@"])
    {
        NSArray *ar = [key componentsSeparatedByString:@"@"];
        
        CCNode *ret = [ccbFile findNodeWithUUID:[ar[0] integerValue]];
        if(ret)
        {
            id baseValue = [ret baseValueForProperty:ar[1]];
            if (baseValue)
            {
                NSDictionary* propInfo = [ret.plugIn.nodePropertiesDict objectForKey:ar[1]];
                NSString *type = propInfo[@"type"];
                if([type isEqualToString:@"Position"])
                {
                    NSPoint pt;
                    pt.x = [baseValue[0] floatValue];
                    pt.y = [baseValue[1] floatValue];
                    return [NSValue valueWithPoint:pt];
                }
                else if([type isEqualToString:@"Color3"])
                {
                    return [NSColor colorWithRed:[baseValue[0] floatValue] green:[baseValue[1] floatValue] blue:[baseValue[2] floatValue] alpha:1.0];
                }
                else if([type isEqualToString:@"Color4"])
                {
                    return [NSColor colorWithRed:[baseValue[0] floatValue] green:[baseValue[1] floatValue] blue:[baseValue[2] floatValue] alpha:[baseValue[3] floatValue]];
                }
                else if([type isEqualToString:@"FloatXY"])
                {
                    return baseValue;
                }
                else if([type isEqualToString:@"SpriteFrame"])
                {
                    return baseValue;
                }
                else if([type isEqualToString:@"ScaleLock"])
                {
                    return baseValue;
                }
                else
                {
                    return baseValue;
                }
            }
            return [ret valueForKey:ar[1]];
        }
        
        return nil;
    }
    return [super valueForKey:key];
}

- (NSMutableArray*) customProperties
{
    if (!ccbFile) return [NSMutableArray array];
    
    return [ccbFile customProperties];
}

@end
