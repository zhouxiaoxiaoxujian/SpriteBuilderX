//
//  SettingsWindow.h
//  SpriteBuilderX
//
//  Created by Volodymyr Klymenko on 2/5/17.
//
//

#import "CCBModalSheetController.h"

@interface SettingsWindow : CCBModalSheetController <NSOpenSavePanelDelegate> {
}
@property (weak) IBOutlet NSButton *enableBackupCheckBox;
@property (weak) IBOutlet NSPopUpButton *backupIntervalPopUpButton;
@property (weak) IBOutlet NSTextField *backupPathField;
@property (weak) IBOutlet NSButton *selectPathButton;

@property (weak) IBOutlet NSTabView *settingsTabView;

@end
