//
//  SpriteBuilderSettings.h
//  SpriteBuilderX
//
//  Created by Volodymyr Klymenko on 2/5/17.
//
//

#define sbsettings [NSUserDefaults standardUserDefaults]

#import "CCBModalSheetController.h"

@interface SpriteBuilderSettings : CCBModalSheetController <NSOpenSavePanelDelegate> {
    bool enableBackup;
    int selectedTab;
    int selectedBackupTimeInterval;
    NSString *backupPath;
}
@property (weak) IBOutlet NSButton *enableBackupCheckBox;
@property (weak) IBOutlet NSPopUpButton *backupIntervalPopUpButton;
@property (weak) IBOutlet NSTextField *backupPathField;
@property (weak) IBOutlet NSButton *selectPathButton;

@property (weak) IBOutlet NSTabView *settingsTabView;

+(NSString *) defaultBackupPath;

@end
