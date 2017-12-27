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
+ (ResolutionSetting*) settingIPhone;
+ (ResolutionSetting*) settingIPhoneLandscape;
+ (ResolutionSetting*) settingIPhonePortrait;
+ (ResolutionSetting*) settingIPhoneRetina;
+ (ResolutionSetting*) settingIPhoneRetinaLandscape;
+ (ResolutionSetting*) settingIPhoneRetinaPortrait;
+ (ResolutionSetting*) settingIPhone5Landscape;
+ (ResolutionSetting*) settingIPhone5Portrait;

+ (ResolutionSetting*) settingIPhone6;
+ (ResolutionSetting*) settingIPhone6Landscape;
+ (ResolutionSetting*) settingIPhone6Portrait;

+ (ResolutionSetting*) settingIPhone6Plus;
+ (ResolutionSetting*) settingIPhone6PlusLandscape;
+ (ResolutionSetting*) settingIPhone6PlusPortrait;

+ (ResolutionSetting*) settingIPad;
+ (ResolutionSetting*) settingIPadLandscape;
+ (ResolutionSetting*) settingIPadPortrait;
+ (ResolutionSetting*) settingIPadRetina;
+ (ResolutionSetting*) settingIPadRetinaLandscape;
+ (ResolutionSetting*) settingIPadRetinaPortrait;

+ (ResolutionSetting*) settingIPhoneX;
+ (ResolutionSetting*) settingIPhoneXLandscape;
+ (ResolutionSetting*) settingIPhoneXPortrait;

+ (ResolutionSetting*) settingIPadPro10;
+ (ResolutionSetting*) settingIPadPro10Landscape;
+ (ResolutionSetting*) settingIPadPro10Portrait;

+ (ResolutionSetting*) settingIPadPro12;
+ (ResolutionSetting*) settingIPadPro12Landscape;
+ (ResolutionSetting*) settingIPadPro12Portrait;

// Android resolutions
+ (ResolutionSetting*) settingAndroid1280x720;
+ (ResolutionSetting*) settingAndroid1280x720Landscape;
+ (ResolutionSetting*) settingAndroid1280x720Portrait;

+ (ResolutionSetting*) settingAndroid1920x1080;
+ (ResolutionSetting*) settingAndroid1920x1080Landscape;
+ (ResolutionSetting*) settingAndroid1920x1080Portrait;

+ (ResolutionSetting*) settingAndroid854x480;
+ (ResolutionSetting*) settingAndroid854x480Landscape;
+ (ResolutionSetting*) settingAndroid854x480Portrait;

+ (ResolutionSetting*) settingAndroid800x480;
+ (ResolutionSetting*) settingAndroid800x480Landscape;
+ (ResolutionSetting*) settingAndroid800x480Portrait;

+ (ResolutionSetting*) settingAndroid960x540;
+ (ResolutionSetting*) settingAndroid960x540Landscape;
+ (ResolutionSetting*) settingAndroid960x540Portrait;

+ (ResolutionSetting*) settingAndroid1024x600;
+ (ResolutionSetting*) settingAndroid1024x600Landscape;
+ (ResolutionSetting*) settingAndroid1024x600Portrait;

+ (ResolutionSetting*) settingAndroid1280x800;
+ (ResolutionSetting*) settingAndroid1280x800Landscape;
+ (ResolutionSetting*) settingAndroid1280x800Portrait;


- (id) initWithSerialization:(id)serialization;

- (id) serialize;

@end
