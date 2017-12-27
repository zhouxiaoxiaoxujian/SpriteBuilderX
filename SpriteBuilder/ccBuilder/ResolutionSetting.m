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

#import "ResolutionSetting.h"

@implementation ResolutionSetting

@synthesize enabled;
@synthesize name;
@synthesize width;
@synthesize height;
@synthesize ext;
@synthesize resourceScale;
@synthesize mainScale;
@synthesize additionalScale;
@synthesize centeredOrigin;
@synthesize exts;

- (id) init
{
    self = [super init];
    if (!self) return NULL;
    
    enabled = NO;
    self.name = @"Custom";
    self.width = 1000;
    self.height = 1000;
    self.ext = @" ";
    self.resourceScale = 1;
    self.mainScale = 1;
    self.additionalScale = 1;
    
    return self;
}

- (id) initWithSerialization:(id)serialization
{
    self = [self init];
    if (!self) return NULL;
    
    self.enabled = YES;
    self.name = [serialization objectForKey:@"name"];
    self.width = [[serialization objectForKey:@"width"] intValue];
    self.height = [[serialization objectForKey:@"height"] intValue];
    self.ext = [serialization objectForKey:@"ext"];
		// TODO should store separate values for these.
    //float scale = [[serialization objectForKey:@"scale"] floatValue];
    self.resourceScale = [[serialization objectForKey:@"resourceScale"] floatValue];
    self.mainScale = [[serialization objectForKey:@"mainScale"] floatValue];
    self.additionalScale = [[serialization objectForKey:@"additionalScale"] floatValue];
    self.centeredOrigin = [[serialization objectForKey:@"centeredOrigin"] boolValue];
    if(self.resourceScale == 0)
    {
        float scale = [[serialization objectForKey:@"scale"] floatValue];
        self.resourceScale = scale;
        self.mainScale = scale;
        self.additionalScale = scale;
    }
    
    return self;
}

-(void)setresourceScale:(float)_scale
{
	NSAssert(_scale > 0.0, @"scale must be positive.");
	
//	if(_scale <= 0.0){
//		NSLog(@"WARNING: scale must be positive. (1.0 was substituted for %f)", _scale);
//		_scale = 1.0;
//	}
	
	resourceScale = _scale;
}

- (id) serialize
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject:name forKey:@"name"];
    [dict setObject:[NSNumber numberWithInt:width] forKey:@"width"];
    [dict setObject:[NSNumber numberWithInt:height] forKey:@"height"];
    [dict setObject:ext forKey:@"ext"];
    [dict setObject:[NSNumber numberWithFloat:resourceScale] forKey:@"resourceScale"];
    [dict setObject:[NSNumber numberWithFloat:mainScale] forKey:@"mainScale"];
    [dict setObject:[NSNumber numberWithFloat:additionalScale] forKey:@"additionalScale"];
    [dict setObject:[NSNumber numberWithBool:centeredOrigin] forKey:@"centeredOrigin"];
    
    return dict;
}

- (void) setExt:(NSString *)e
{
    
    ext = [e copy];
    
    if (!e || [e isEqualToString:@" "] || [e isEqualToString:@""])
    {
        exts = [[NSArray alloc] init];
    }
    else
    {
        exts = [e componentsSeparatedByString:@" "];
    }
}

- (void) dealloc
{
    self.ext = NULL;
    
}

+ (ResolutionSetting*) settingPhone
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"Phone";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"phone";
    setting.resourceScale = 1;
    
    return setting;
}
+ (ResolutionSetting*) settingPhoneHd
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"PhoneHd";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"phonehd phone";
    setting.resourceScale = 2;
    
    return setting;
}
+ (ResolutionSetting*) settingTabletHd
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"TabletHd";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"tablethd tablet phonehd phone";
    setting.resourceScale = 4;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhone
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"iPhone";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"phone";
    setting.resourceScale = 1;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhoneLandscape
{
    ResolutionSetting* setting = [self settingIPhone];
    
    setting.name = @"iPhone Landscape (short)";
    setting.width = 480;
    setting.height = 320;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhonePortrait
{
    ResolutionSetting* setting = [self settingIPhone];
    
    setting.name = @"iPhone Portrait (short)";
    setting.width = 320;
    setting.height = 480;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhoneRetina
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"iPhone";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"phonehd phone";
    setting.resourceScale = 2;
    
    return setting;
}
+ (ResolutionSetting*) settingIPhoneRetinaLandscape
{
    ResolutionSetting* setting = [self settingIPhoneRetina];
    
    setting.name = @"iPhone 4S Landscape";
    setting.width = 960;
    setting.height = 640;
    
    return setting;
}
+ (ResolutionSetting*) settingIPhoneRetinaPortrait
{
    ResolutionSetting* setting = [self settingIPhoneRetina];
    
    setting.name = @"iPhone 4S Portrait";
    setting.width = 640;
    setting.height = 960;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhone5Landscape
{
    ResolutionSetting* setting = [self settingIPhoneRetina];
    
    setting.name = @"iPhone 5 Landscape";
    setting.width = 1136;
    setting.height = 640;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhone5Portrait
{
    ResolutionSetting* setting = [self settingIPhoneRetina];
    
    setting.name = @"iPhone 5 Portrait";
    setting.width = 640;
    setting.height = 1136;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhone6
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"iPhone 6";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"phonehd phone";
    setting.resourceScale = 2;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhone6Landscape
{
    ResolutionSetting* setting = [self settingIPhone6];
    
    setting.name = @"iPhone 6 Landscape";
    setting.width = 1334;
    setting.height = 750;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhone6Portrait
{
    ResolutionSetting* setting = [self settingIPhone6];
    
    setting.name = @"iPhone 6 Portrait";
    setting.width = 750;
    setting.height = 1334;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhone6Plus
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"iPhone 6+";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"tablethd tablet phonehd phone";
    setting.resourceScale = 4;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhone6PlusLandscape
{
    ResolutionSetting* setting = [self settingIPhone6Plus];
    
    setting.name = @"iPhone 6+ Landscape";
    setting.width = 1920;
    setting.height = 1080;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhone6PlusPortrait
{
    ResolutionSetting* setting = [self settingIPhone6Plus];
    
    setting.name = @"iPhone 6+ Portrait";
    setting.width = 1080;
    setting.height = 1920;
    
    return setting;
}

+ (ResolutionSetting*) settingIPad
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"iPad";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"phonehd phone";
    setting.resourceScale = 2;
    
    return setting;
}

+ (ResolutionSetting*) settingIPadLandscape
{
    ResolutionSetting* setting = [self settingIPad];
    
    setting.name = @"iPad Landscape";
    setting.width = 1024;
    setting.height = 768;
    
    return setting;
}

+ (ResolutionSetting*) settingIPadPortrait
{
    ResolutionSetting* setting = [self settingIPad];
    
    setting.name = @"iPad Portrait";
    setting.width = 768;
    setting.height = 1024;
    
    return setting;
}

+ (ResolutionSetting*) settingIPadRetina
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"iPad Retina";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"tablethd phonehd phone";
    setting.resourceScale = 4;
    
    return setting;
}

+ (ResolutionSetting*) settingIPadRetinaLandscape
{
    ResolutionSetting* setting = [self settingIPadRetina];
    
    setting.name = @"iPad Retina Landscape";
    setting.width = 2048;
    setting.height = 1536;
    
    return setting;
}

+ (ResolutionSetting*) settingIPadRetinaPortrait
{
    ResolutionSetting* setting = [self settingIPadRetina];
    
    setting.name = @"iPad Retina Portrait";
    setting.width = 1536;
    setting.height = 2048;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhoneX {
    
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    setting.name = @"iPhone X";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"tablethd phonehd";
    setting.resourceScale = 4;
    return setting;
}

+ (ResolutionSetting*) settingIPhoneXLandscape {
    
    ResolutionSetting* setting = [self settingIPhoneX];
    setting.name = @"iPhone X Landscape";
    setting.width = 2436;
    setting.height = 1125;
    return setting;
}

+ (ResolutionSetting*) settingIPhoneXPortrait {
    
    ResolutionSetting* setting = [self settingIPhoneX];
    setting.name = @"iPhone X Portrait";
    setting.width = 1125;
    setting.height = 2436;
    return setting;
}

+ (ResolutionSetting*) settingIPadPro10 {
    
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    setting.name = @"iPad Pro 10";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"tablethd phonehd";
    setting.resourceScale = 4;
    return setting;
}

+ (ResolutionSetting*) settingIPadPro10Landscape {
    
    ResolutionSetting* setting = [self settingIPadPro10];
    setting.name = @"iPad Pro 10 Landscape";
    setting.width = 2224;
    setting.height = 1668;
    return setting;
}

+ (ResolutionSetting*) settingIPadPro10Portrait {
    
    ResolutionSetting* setting = [self settingIPadPro10];
    setting.name = @"iPad Pro 10 Portrait";
    setting.width = 1668;
    setting.height = 2224;
    return setting;
}

+ (ResolutionSetting*) settingIPadPro12 {
    
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    setting.name = @"iPad Pro 12";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"tablethd phonehd";
    setting.resourceScale = 4;
    return setting;
}

+ (ResolutionSetting*) settingIPadPro12Landscape {
    
    ResolutionSetting* setting = [self settingIPadPro12];
    setting.name = @"iPad Pro 12 Landscape";
    setting.width = 2732;
    setting.height = 2048;
    return setting;
}

+ (ResolutionSetting*) settingIPadPro12Portrait {
    
    ResolutionSetting* setting = [self settingIPadPro12];
    setting.name = @"iPad Pro 12 Portrait";
    setting.width = 2048;
    setting.height = 2732;
    return setting;
}

+ (ResolutionSetting*) settingAndroid1280x720 {
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"Android 1280x720";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"phonehd phone";
    setting.resourceScale = 2;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid1280x720Landscape {
    
    ResolutionSetting* setting = [self settingAndroid1280x720];
    setting.name = @"Android 1280x720 Landscape";
    setting.width = 1280;
    setting.height = 720;
    return setting;
}

+ (ResolutionSetting*) settingAndroid1280x720Portrait {
    
    ResolutionSetting* setting = [self settingAndroid1280x720];
    setting.name = @"Android 1280x720 Landscape";
    setting.width = 720;
    setting.height = 1280;
    return setting;
}

+ (ResolutionSetting*) settingAndroid1920x1080
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"Android 1920x1080";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"tablethd tablet phonehd phone";
    setting.resourceScale = 4;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid1920x1080Landscape
{
    ResolutionSetting* setting = [self settingAndroid1920x1080];
    
    setting.name = @"Android 1920x1080 Landscape";
    setting.width = 1920;
    setting.height = 1080;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid1920x1080Portrait
{
    ResolutionSetting* setting = [self settingAndroid1920x1080];
    
    setting.name = @"Android 1920x1080 Portrait";
    setting.width = 1080;
    setting.height = 1920;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid854x480
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"Android 854x480";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"phonehd phone";
    setting.resourceScale = 2;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid854x480Landscape
{
    ResolutionSetting* setting = [self settingAndroid854x480];
    
    setting.name = @"Android 854x480 Landscape";
    setting.width = 854;
    setting.height = 480;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid854x480Portrait
{
    ResolutionSetting* setting = [self settingAndroid854x480];
    
    setting.name = @"Android 854x480 Portrait";
    setting.width = 480;
    setting.height = 854;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid800x480
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"Android 800x480";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"phonehd phone";
    setting.resourceScale = 2;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid800x480Landscape
{
    ResolutionSetting* setting = [self settingAndroid800x480];
    
    setting.name = @"Android 800x480 Landscape";
    setting.width = 800;
    setting.height = 480;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid800x480Portrait
{
    ResolutionSetting* setting = [self settingAndroid800x480];
    
    setting.name = @"Android 800x480 Portrait";
    setting.width = 480;
    setting.height = 800;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid960x540
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"Android 960x540";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"phonehd phone";
    setting.resourceScale = 2;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid960x540Landscape
{
    ResolutionSetting* setting = [self settingAndroid960x540];
    
    setting.name = @"Android 960x540 Landscape";
    setting.width = 960;
    setting.height = 540;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid960x540Portrait
{
    ResolutionSetting* setting = [self settingAndroid960x540];
    
    setting.name = @"Android 960x540 Portrait";
    setting.width = 540;
    setting.height = 960;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid1024x600
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"Android 1024x600";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"phonehd phone";
    setting.resourceScale = 2;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid1024x600Landscape
{
    ResolutionSetting* setting = [self settingAndroid1024x600];
    
    setting.name = @"Android 1024x600 Landscape";
    setting.width = 1024;
    setting.height = 600;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid1024x600Portrait
{
    ResolutionSetting* setting = [self settingAndroid1024x600];
    
    setting.name = @"Android 1024x600 Portrait";
    setting.width = 600;
    setting.height = 1024;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid1280x800
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"Android 1280x800";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"phonehd phone";
    setting.resourceScale = 2;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid1280x800Landscape
{
    ResolutionSetting* setting = [self settingAndroid1280x800];
    
    setting.name = @"Android 1280x800 Landscape";
    setting.width = 1280;
    setting.height = 800;
    
    return setting;
}

+ (ResolutionSetting*) settingAndroid1280x800Portrait
{
    ResolutionSetting* setting = [self settingAndroid1280x800];
    
    setting.name = @"Android 1280x800 Portrait";
    setting.width = 800;
    setting.height = 1280;
    
    return setting;
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"%@ <0x%x> (%d x %d)", NSStringFromClass([self class]), (unsigned int)self, width, height];
}

- (id) copyWithZone:(NSZone*)zone
{
    ResolutionSetting* copy = [[ResolutionSetting alloc] init];
    
    copy.enabled = enabled;
    copy.name = name;
    copy.width = width;
    copy.height = height;
    copy.ext = ext;
    copy.resourceScale = resourceScale;
    copy.mainScale = mainScale;
    copy.additionalScale = additionalScale;
    copy.centeredOrigin = centeredOrigin;
    
    return copy;
}

@end
