//
//  SettingsManager.m
//  SpriteBuilderX
//
//  Created by Sergey on 08.02.17.
//
//

#import "SettingsManager.h"


@implementation SettingsManager

+ (id)instance {
    static SettingsManager *sharedSettingsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSettingsManager = [[self alloc] init];
    });
    return sharedSettingsManager;
}

- (id)init {
    if (self = [super init]) {
        //someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
    }
    return self;
}

+(NSString *) defaultBackupPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *productName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    NSString *defaultPath = [[[paths firstObject] stringByAppendingPathComponent:productName] stringByAppendingPathComponent:@"Backups"];
    return defaultPath;
}

- (void) setBackupPath:(NSString *)backupPath
{
    [SBUserDefaults setObject:backupPath forKey:@"backupPath"];
}

- (NSString*) backupPath
{
    id backupPath = [SBUserDefaults valueForKey:@"backupPath"];
    if(!backupPath)
        return [SettingsManager defaultBackupPath];
    return backupPath;
}

- (void) setBackupInterval:(NSInteger)backupInterval
{
    [SBUserDefaults setObject:[NSNumber numberWithInteger:backupInterval] forKey:@"backupInterval"];
}

- (NSInteger) backupInterval
{
    id backupInterval = [SBUserDefaults valueForKey:@"backupInterval"];
    if(!backupInterval)
        return 60;
    return [backupInterval integerValue];
}

- (void) setEnableBackup:(BOOL)enableBackup
{
    [SBUserDefaults setObject:[NSNumber numberWithBool:enableBackup] forKey:@"enableBackup"];
}

- (BOOL) enableBackup
{
    id enableBackup = [SBUserDefaults valueForKey:@"enableBackup"];
    if(!enableBackup)
        return YES;
    return [enableBackup boolValue];
}

-(void) setSelectedSettingsTab:(int)selectedSettingsTab {
    [SBUserDefaults setObject:@(selectedSettingsTab) forKey:@"selectedSettingsTab"];
}

-(int) selectedSettingsTab {
    id selectedTab = [SBUserDefaults objectForKey:@"selectedSettingsTab"];
    if (!selectedTab) {
        return 0;
    }
    return [selectedTab intValue];
}

- (void) save
{
    [SBUserDefaults synchronize];
}

- (void)resetBackupSettings
{
    self.enableBackup = YES;
    self.backupInterval = 60;
    self.backupPath = [SettingsManager defaultBackupPath];
}

@end
