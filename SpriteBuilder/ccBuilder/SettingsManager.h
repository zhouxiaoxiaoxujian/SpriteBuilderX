//
//  SettingsManager.h
//  SpriteBuilderX
//
//  Created by Sergey on 08.02.17.
//
//

#define SBSettings [SettingsManager instance]

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SettingsManager : NSObject

@property (nonatomic,assign) BOOL enableBackup;
@property (nonatomic,assign) NSInteger backupInterval;
@property (nonatomic,strong) NSString *backupPath;
@property (nonatomic,assign) int selectedSettingsTab;

@property (nonatomic,assign) float defaultSpriteAnchorX;
@property (nonatomic,assign) float defaultSpriteAnchorY;

@property (nonatomic,assign) BOOL storeMiscFilesAtPath;
@property (nonatomic,strong) NSString *miscFilesPath;

@property (nonatomic,assign) CCPositionUnit defaultSpritePositionUnit;

@property (nonatomic, assign) BOOL restoreOpenedDocuments;
@property (nonatomic, strong) NSMutableDictionary *openedDocuments;
@property (nonatomic, assign) BOOL moveNodeOnCopy;

+ (instancetype) instance;
- (void) save;
- (void) resetBackupSettings;
- (void) resetPathsSettings;
- (NSString *) miscFilesPathForFile:(NSString *) filePath projectPathDir:(NSString *) projectPathDir;

@end
