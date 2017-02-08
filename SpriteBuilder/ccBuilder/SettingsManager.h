//
//  SettingsManager.h
//  SpriteBuilderX
//
//  Created by Sergey on 08.02.17.
//
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

@property (nonatomic,assign) BOOL enableBackup;
@property (nonatomic,assign) NSInteger backupInterval;
@property (nonatomic,copy) NSString *backupPath;

+ (instancetype) instance;

- (void)synchronize;

- (void)resetBackupSettings;

@end
