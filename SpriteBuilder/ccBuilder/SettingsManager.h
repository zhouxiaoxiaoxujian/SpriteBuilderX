//
//  SettingsManager.h
//  SpriteBuilderX
//
//  Created by Sergey on 08.02.17.
//
//

#define SBSettings [SettingsManager instance]

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

@property (nonatomic,assign) BOOL enableBackup;
@property (nonatomic,assign) NSInteger backupInterval;
@property (nonatomic,strong) NSString *backupPath;
@property (nonatomic,assign) int selectedSettingsTab;

@property (nonatomic,assign) float defaultSpriteAnchorX;
@property (nonatomic,assign) float defaultSpriteAnchorY;

+ (instancetype) instance;
- (void)save;
- (void)resetBackupSettings;

@end
