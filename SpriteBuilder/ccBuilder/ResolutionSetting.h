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

#import <Foundation/Foundation.h>

@interface ResolutionSetting : NSObject
{
    BOOL enabled;
    NSString* name;
    int width;
    int height;
    NSString* ext;
    BOOL centeredOrigin;
    NSArray* exts;
}

@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,copy) NSString* name;
@property (nonatomic,assign) int width;
@property (nonatomic,assign) int height;
@property (nonatomic,copy) NSString* ext;
@property (nonatomic,assign) float resourceScale;
@property (nonatomic,assign) float mainScale;
@property (nonatomic,assign) float additionalScale;
@property (nonatomic,assign) BOOL centeredOrigin;
@property (nonatomic,readonly) NSArray* exts;

// Fixed resolutions
+ (ResolutionSetting*) settingPhone;
+ (ResolutionSetting*) settingPhoneHd;
+ (ResolutionSetting*) settingTabletHd;

// iOS resolutions
+ (ResolutionSetting*) setting_iPhone;
+ (ResolutionSetting*) setting_iPhoneLandscape;
+ (ResolutionSetting*) setting_iPhonePortrait;
+ (ResolutionSetting*) setting_iPhoneRetina;
+ (ResolutionSetting*) setting_iPhoneRetinaLandscape;
+ (ResolutionSetting*) setting_iPhoneRetinaPortrait;
+ (ResolutionSetting*) setting_iPhone5Landscape;
+ (ResolutionSetting*) setting_iPhone5Portrait;

+ (ResolutionSetting*) setting_iPhone6;
+ (ResolutionSetting*) setting_iPhone6Landscape;
+ (ResolutionSetting*) setting_iPhone6Portrait;

+ (ResolutionSetting*) setting_iPhone6Plus;
+ (ResolutionSetting*) setting_iPhone6PlusLandscape;
+ (ResolutionSetting*) setting_iPhone6PlusPortrait;

+ (ResolutionSetting*) setting_iPad;
+ (ResolutionSetting*) setting_iPadLandscape;
+ (ResolutionSetting*) setting_iPadPortrait;
+ (ResolutionSetting*) setting_iPadRetina;
+ (ResolutionSetting*) setting_iPadRetinaLandscape;
+ (ResolutionSetting*) setting_iPadRetinaPortrait;

+ (ResolutionSetting*) setting_iPhoneX;
+ (ResolutionSetting*) setting_iPhoneXLandscape;
+ (ResolutionSetting*) setting_iPhoneXPortrait;

+ (ResolutionSetting*) setting_iPadPro10;
+ (ResolutionSetting*) setting_iPadPro10Landscape;
+ (ResolutionSetting*) setting_iPadPro10Portrait;

+ (ResolutionSetting*) setting_iPadPro12;
+ (ResolutionSetting*) setting_iPadPro12Landscape;
+ (ResolutionSetting*) setting_iPadPro12Portrait;

// Android resolutions
+ (ResolutionSetting*) setting_Android1280x720;
+ (ResolutionSetting*) setting_Android1280x720Landscape;
+ (ResolutionSetting*) setting_Android1280x720Portrait;

+ (ResolutionSetting*) setting_Android1920x1080;
+ (ResolutionSetting*) setting_Android1920x1080Landscape;
+ (ResolutionSetting*) setting_Android1920x1080Portrait;

+ (ResolutionSetting*) setting_Android854x480;
+ (ResolutionSetting*) setting_Android854x480Landscape;
+ (ResolutionSetting*) setting_Android854x480Portrait;

+ (ResolutionSetting*) setting_Android800x480;
+ (ResolutionSetting*) setting_Android800x480Landscape;
+ (ResolutionSetting*) setting_Android800x480Portrait;

+ (ResolutionSetting*) setting_Android960x540;
+ (ResolutionSetting*) setting_Android960x540Landscape;
+ (ResolutionSetting*) setting_Android960x540Portrait;

+ (ResolutionSetting*) setting_Android1024x600;
+ (ResolutionSetting*) setting_Android1024x600Landscape;
+ (ResolutionSetting*) setting_Android1024x600Portrait;

+ (ResolutionSetting*) setting_Android1280x800;
+ (ResolutionSetting*) setting_Android1280x800Landscape;
+ (ResolutionSetting*) setting_Android1280x800Portrait;

+ (ResolutionSetting*) setting_Android2960x1440;
+ (ResolutionSetting*) setting_Android2960x1440Landscape;
+ (ResolutionSetting*) setting_Android2960x1440Portrait;


- (id) initWithSerialization:(id)serialization;

- (id) serialize;

@end
