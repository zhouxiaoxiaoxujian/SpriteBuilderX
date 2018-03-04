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

#import "ResolutionSettingsWindow.h"
#import "AppDelegate.h"

@implementation ResolutionSettingsWindow

@synthesize resolutions;

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    predefinedResolutions = [[NSMutableArray alloc] init];
    
    // iOS
    [predefinedResolutions addObject:[ResolutionSetting setting_iPhone5Landscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_iPhone5Portrait]];
    [predefinedResolutions addObject:[ResolutionSetting setting_iPhone6Landscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_iPhone6Portrait]];
    [predefinedResolutions addObject:[ResolutionSetting setting_iPhone6PlusLandscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_iPhone6PlusPortrait]];
    [predefinedResolutions addObject:[ResolutionSetting setting_iPhoneXLandscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_iPhoneXPortrait]];
    
    [predefinedResolutions addObject:[ResolutionSetting setting_iPadLandscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_iPadPortrait]];
    [predefinedResolutions addObject:[ResolutionSetting setting_iPadRetinaLandscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_iPadRetinaPortrait]];
    
    [predefinedResolutions addObject:[ResolutionSetting setting_iPadPro10Landscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_iPadPro10Portrait]];
    [predefinedResolutions addObject:[ResolutionSetting setting_iPadPro12Landscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_iPadPro12Portrait]];
    
    // Android
    [predefinedResolutions addObject:[ResolutionSetting setting_Android1280x720Landscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_Android1280x720Portrait]];

    [predefinedResolutions addObject:[ResolutionSetting setting_Android1920x1080Landscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_Android1920x1080Portrait]];

    [predefinedResolutions addObject:[ResolutionSetting setting_Android854x480Landscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_Android854x480Portrait]];

    [predefinedResolutions addObject:[ResolutionSetting setting_Android800x480Landscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_Android800x480Portrait]];

    [predefinedResolutions addObject:[ResolutionSetting setting_Android960x540Landscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_Android960x540Portrait]];
    
    [predefinedResolutions addObject:[ResolutionSetting setting_Android1024x600Landscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_Android1024x600Portrait]];
    
    [predefinedResolutions addObject:[ResolutionSetting setting_Android1280x800Landscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_Android1280x800Portrait]];
    
    [predefinedResolutions addObject:[ResolutionSetting setting_Android2960x1440Landscape]];
    [predefinedResolutions addObject:[ResolutionSetting setting_Android2960x1440Portrait]];
    
    int i = 0;
    for (ResolutionSetting* setting in predefinedResolutions)
    {
        NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:setting.name action:@selector(addPredefined:) keyEquivalent:@""];
        item.target = self;
        item.tag = i;
        [addPredefinedPopup.menu addItem:item];
        
        i++;
    }
}

- (IBAction)resolutionChange:(NSPopUpButton *)sender {
    [self recalcSceneScale];
}

-(void) recalcSceneScale {
    if (self.sceneScaleType > kCCBSceneScaleTypeCUSTOM) {
        [self recallcScalesForScaleType:self.sceneScaleType];
    } else
    if (self.sceneScaleType == kCCBSceneScaleTypeDEFAULT) {
        [self recallcScalesForScaleType:[AppDelegate appDelegate].projectSettings.sceneScaleType];
    }
}

+ (void)recallcScale:(ResolutionSetting*)resolution
    designResolution:(CGSize)designResolution
      designResScale:(float)designResolutionScale
           scaleType:(CCBSceneScaleType) scaleType {
    
    CGSize normalizedDesignRezolution;
    normalizedDesignRezolution.width = MAX(designResolution.width, designResolution.height);
    normalizedDesignRezolution.height = MIN(designResolution.width, designResolution.height);
    
    CGSize normalizedResolution;
    normalizedResolution.width = MAX(resolution.width, resolution.height);
    normalizedResolution.height = MIN(resolution.width, resolution.height);
    
    if(scaleType == kCCBSceneScaleTypeMINSCALE)
    {
        float scale1 = (normalizedResolution.height / resolution.resourceScale) / (normalizedDesignRezolution.height / designResolutionScale);
        float scale2 = (normalizedResolution.width / resolution.resourceScale) / (normalizedDesignRezolution.width / designResolutionScale);
        if(scale1<scale2)
        {
            resolution.mainScale = scale1;
            resolution.additionalScale = (normalizedResolution.width / resolution.resourceScale / resolution.mainScale) / (normalizedDesignRezolution.width / designResolutionScale );
        }
        else
        {
            resolution.mainScale = scale2;
            resolution.additionalScale = (normalizedResolution.height / resolution.resourceScale / resolution.mainScale) / (normalizedDesignRezolution.height / designResolutionScale);
        }
    }
    else if(scaleType == kCCBSceneScaleTypeMAXSCALE)
    {
        float scale1 = (normalizedResolution.height / resolution.resourceScale) / (normalizedDesignRezolution.height / designResolutionScale);
        float scale2 = (normalizedResolution.width / resolution.resourceScale) / (normalizedDesignRezolution.width / designResolutionScale);
        if(scale1>scale2)
        {
            resolution.mainScale = scale1;
            resolution.additionalScale = (normalizedResolution.width / resolution.resourceScale / resolution.mainScale) / (normalizedDesignRezolution.width / designResolutionScale );
        }
        else
        {
            resolution.mainScale = scale2;
            resolution.additionalScale = (normalizedResolution.height / resolution.resourceScale / resolution.mainScale) / (normalizedDesignRezolution.height / designResolutionScale);
        }
    }
    else if(scaleType == kCCBSceneScaleTypeMINSIZE)
    {
        resolution.mainScale = (normalizedResolution.height / resolution.resourceScale) / (normalizedDesignRezolution.height / designResolutionScale);
        resolution.additionalScale =   (normalizedResolution.width / resolution.resourceScale / resolution.mainScale) / (normalizedDesignRezolution.width / designResolutionScale );
    }
    else
    {
        resolution.mainScale = (normalizedResolution.width / resolution.resourceScale) / (normalizedDesignRezolution.width / designResolutionScale);
        resolution.additionalScale =   (normalizedResolution.height / resolution.resourceScale / resolution.mainScale) / (normalizedDesignRezolution.height / designResolutionScale);
    }
}

- (void)recallcScalesForScaleType:(CCBSceneScaleType) scaleType {
    for (ResolutionSetting* resolution in resolutions) {
        [ResolutionSettingsWindow recallcScale:resolution
          designResolution:CGSizeMake([AppDelegate appDelegate].projectSettings.designSizeWidth,
                                      [AppDelegate appDelegate].projectSettings.designSizeHeight)
            designResScale:[AppDelegate appDelegate].projectSettings.designResourceScale
                 scaleType:scaleType];
    }
}


- (void) copyResolutions:(NSMutableArray *)res
{
    resolutions = [NSMutableArray arrayWithCapacity:[res count]];
    for (ResolutionSetting* resolution in res)
    {
        [resolutions addObject:[resolution copy]];
    }
}

- (BOOL) sheetIsValid
{
    if ([resolutions count] > 0)
    {
        return YES;
    }
    else
    {
        // Display warning!
        NSAlert* alert = [NSAlert alertWithMessageText:@"Missing Resolution" defaultButton:@"OK" alternateButton:NULL otherButton:NULL informativeTextWithFormat:@"You need to have at least one valid resolution setting."];
        [alert beginSheetModalForWindow:[self window] modalDelegate:NULL didEndSelector:NULL contextInfo:NULL];
        
        return NO;
    }
}

- (void) addPredefined:(id)sender
{
    ResolutionSetting* setting = [predefinedResolutions objectAtIndex:[sender tag]];
    [arrayController addObject:setting];
    [self recalcSceneScale];
}


@end
