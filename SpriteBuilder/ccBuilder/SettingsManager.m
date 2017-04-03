//
//  SettingsManager.m
//  SpriteBuilderX
//
//  Created by Sergey on 08.02.17.
//
//

#import "SettingsManager.h"
#import "AppDelegate.h"

@implementation SettingsManager

+ (instancetype)instance {
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

-(NSString *) defaultSBFolderPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *productName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    NSString *defaultPath = [[paths firstObject] stringByAppendingPathComponent:productName];
    return defaultPath;
}

-(NSString *) defaultBackupPath {
    NSString *defaultPath = [[self defaultSBFolderPath] stringByAppendingPathComponent:@"Backups"];
    return defaultPath;
}

-(NSString *) defaultMiscFilesPath {
    NSString *defaultPath = [[self defaultSBFolderPath] stringByAppendingPathComponent:@"MiscFiles"];
    return defaultPath;
}

- (void) setStoreMiscFilesAtPath:(BOOL)storeMiscFilesAtPath  {
    [SBUserDefaults setObject:[NSNumber numberWithBool:storeMiscFilesAtPath] forKey:@"storeMiscFilesAtPath"];
}

- (BOOL) storeMiscFilesAtPath {
    id storeMiscFilesAtPath = [SBUserDefaults valueForKey:@"storeMiscFilesAtPath"];
    if(!storeMiscFilesAtPath)
        return YES;
    return [storeMiscFilesAtPath boolValue];
}

- (void) setMiscFilesPath:(NSString *)miscFilesPath {
    [SBUserDefaults setObject:miscFilesPath forKey:@"miscFilesPath"];
}

- (NSString*) miscFilesPath {
    id miscFilesPath = [SBUserDefaults valueForKey:@"miscFilesPath"];
    if(!miscFilesPath)
        return [self defaultMiscFilesPath];
    return miscFilesPath;
}

- (void) setBackupPath:(NSString *)backupPath
{
    [SBUserDefaults setObject:backupPath forKey:@"backupPath"];
}

- (NSString*) backupPath
{
    id backupPath = [SBUserDefaults valueForKey:@"backupPath"];
    if(!backupPath)
        return [self defaultBackupPath];
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

-(void) setDefaultSpriteAnchorX:(float)defaultSpriteAnchorX {
    [SBUserDefaults setObject:@(defaultSpriteAnchorX) forKey:@"defaultSpriteAnchorX"];
}

-(float) defaultSpriteAnchorX {
    id anchorX = [SBUserDefaults objectForKey:@"defaultSpriteAnchorX"];
    if (!anchorX) {
        return 0.5;
    }
    return [anchorX floatValue];
}

-(void) setDefaultSpriteAnchorY:(float)defaultSpriteAnchorY {
    [SBUserDefaults setObject:@(defaultSpriteAnchorY) forKey:@"defaultSpriteAnchorY"];
}

-(float) defaultSpriteAnchorY {
    id anchorY = [SBUserDefaults objectForKey:@"defaultSpriteAnchorY"];
    if (!anchorY) {
        return 0.5;
    }
    return [anchorY floatValue];
}

- (void) save
{
    [SBUserDefaults synchronize];
}

- (void)resetBackupSettings
{
    self.enableBackup = YES;
    self.backupInterval = 60;
    self.backupPath = [self defaultBackupPath];
}

- (void) resetPathsSettings {
    self.storeMiscFilesAtPath = YES;
    self.miscFilesPath = [self defaultMiscFilesPath];
}

- (NSString *) miscFilesPathForFile:(NSString *) filePath {
    if (!self.storeMiscFilesAtPath) {
        return filePath;
    }
    NSString *projPath = [[AppDelegate appDelegate].projectSettings.projectPathDir stringByDeletingLastPathComponent];
    NSString *miscFilePath = [filePath stringByReplacingOccurrencesOfString:projPath withString:self.miscFilesPath];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:[miscFilePath stringByDeletingLastPathComponent]
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    return miscFilePath;
}


@end
