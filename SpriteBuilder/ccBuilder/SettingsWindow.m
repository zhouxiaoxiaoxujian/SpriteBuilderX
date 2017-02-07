//
//  SettingsWindow.m
//  SpriteBuilderX
//
//  Created by Volodymyr Klymenko on 2/5/17.
//
//

#import "SettingsWindow.h"
#import "NSString+RelativePath.h"
#import "SettingsManager.h"

typedef void (^DirectorySetterBlock)(NSString *directoryPath);

@interface SettingsWindow ()

@end

@implementation SettingsWindow

- (instancetype)init {
    self = [self initWithWindowNibName:@"SettingsWindow"];
    
    if (self) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir;
        if(![fileManager fileExistsAtPath:[SettingsManager instance].backupPath isDirectory:&isDir]) {
            if(![fileManager createDirectoryAtPath:[SettingsManager instance].backupPath withIntermediateDirectories:YES attributes:nil error:NULL]) {
                NSLog(@"Error: Create backups folder failed %@", [SettingsManager instance].backupPath);
            }
        }
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self updateUIValues];
    [self updateButtons];
    [self.backupPathField.window makeFirstResponder:nil];
}

-(void) updateButtons {
    if ([SettingsManager instance].enableBackup) {
        self.enableBackupCheckBox.state = NSOnState;
        self.backupIntervalPopUpButton.enabled = YES;
        self.backupPathField.enabled = YES;
        self.selectPathButton.enabled = YES;
    } else {
        self.enableBackupCheckBox.state = NSOffState;;
        self.backupIntervalPopUpButton.enabled = NO;
        self.backupPathField.enabled = NO;
        self.selectPathButton.enabled = NO;
    }
}

-(void) updateUIValues {
    //[self.settingsTabView selectTabViewItemAtIndex:selectedTab];
    [self.backupIntervalPopUpButton selectItemWithTag:[SettingsManager instance].backupInterval];
    [self.backupPathField setStringValue:[SettingsManager instance].backupPath];
}

- (IBAction)enableBackup:(NSButton *)sender {
    if (sender.state == NSOnState) {
        [SettingsManager instance].enableBackup = YES;
    } else {
        [SettingsManager instance].enableBackup = NO;
    }
    [self updateButtons];
}

- (IBAction)resetBackupSettings:(id)sender {
    [[SettingsManager instance] resetBackupSettings];
    [self updateUIValues];
    [self updateButtons];
}

- (IBAction)acceptSheet:(id)sender {
    [[SettingsManager instance] synchronize];
    [super acceptSheet:sender];
}


- (IBAction)cancelSheet:(id)sender {
    [super cancelSheet:sender];
}

- (IBAction)selectBackupsDirectory:(id)sender {
    
    [self selectPublishCurrentPath:self.backupPathField.stringValue dirSetterBlock:^(NSString *directoryPath) {
         self.backupPathField.stringValue = directoryPath;
     }];
}

- (void)selectPublishCurrentPath:(NSString *)currentPath dirSetterBlock:(DirectorySetterBlock)dirSetterBlock {
    if (!dirSetterBlock) {
        return;
    }
    if (!currentPath) {
        return;
    }
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setCanCreateDirectories:YES];
    [openDlg setDirectoryURL:[NSURL fileURLWithPath:currentPath]];
    openDlg.delegate = self;
    
    [openDlg beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
         if (result == NSOKButton) {
             NSArray *files = [openDlg URLs];
             for (NSUInteger i = 0; i < [files count]; i++) {
                 NSString *dirName = [files[i] path];
                 dirSetterBlock(dirName);
             }
         }
     }];
}

@end
