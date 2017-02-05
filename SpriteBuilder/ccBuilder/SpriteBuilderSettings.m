//
//  SpriteBuilderSettings.m
//  SpriteBuilderX
//
//  Created by Volodymyr Klymenko on 2/5/17.
//
//

#import "SpriteBuilderSettings.h"
#import "NSString+RelativePath.h"

typedef void (^DirectorySetterBlock)(NSString *directoryPath);

@interface SpriteBuilderSettings ()

@end

@implementation SpriteBuilderSettings

- (instancetype)init {
    self = [self initWithWindowNibName:@"SpriteBuilderSettings"];
    
    if (self) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir;
        NSString *defaultPath = [self defaultBackupPath];
        if(![fileManager fileExistsAtPath:defaultPath isDirectory:&isDir]) {
            if(![fileManager createDirectoryAtPath:defaultPath withIntermediateDirectories:YES attributes:nil error:NULL]) {
                NSLog(@"Error: Create SBXBackups folder failed %@", defaultPath);
            }
        }
        [self loadSBSettings];
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
    if (enableBackup) {
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
    [self.settingsTabView selectTabViewItemAtIndex:selectedTab];
    [self.backupIntervalPopUpButton selectItemWithTag:selectedBackupTimeInterval];
    [self.backupPathField setStringValue:backupPath];
}

- (IBAction)enableBackup:(NSButton *)sender {
    if (sender.state == NSOnState) {
        enableBackup = YES;
    } else {
        enableBackup = NO;
    }
    [self updateButtons];
}

-(void) loadSBSettings {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    enableBackup = [[settings valueForKey:@"enableBackup"] boolValue];
    selectedTab = [[settings valueForKey:@"selectedTab"] intValue];
    selectedBackupTimeInterval = [[settings valueForKey:@"selectedBackupTimeInterval"] intValue];
    backupPath = ([settings valueForKey:@"backupPath"] != nil) ? [settings valueForKey:@"backupPath"] : [self defaultBackupPath];
}

- (void)saveSBSettings {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:@(self.backupIntervalPopUpButton.selectedTag) forKey:@"selectedBackupTimeInterval"];
    [settings setObject:@([self.settingsTabView.selectedTabViewItem.identifier intValue]) forKey:@"selectedTab"];
    [settings setObject:@(enableBackup) forKey:@"enableBackup"];
    [settings setObject:self.backupPathField.stringValue forKey:@"backupPath"];
    [settings synchronize];
}

- (IBAction)resetBackupSettings:(id)sender {
    selectedBackupTimeInterval = 60;
    backupPath = [self defaultBackupPath];
    [self.backupIntervalPopUpButton selectItemWithTag:selectedBackupTimeInterval];
    [self.backupPathField setStringValue:backupPath];
}

-(NSString *) defaultBackupPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *defaultPath = [[paths firstObject] stringByAppendingPathComponent:@"SBXBackups"];
    return defaultPath;
}

- (IBAction)acceptSheet:(id)sender {
    [self saveSBSettings];
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
    [openDlg setDirectoryURL:[NSURL URLWithString:currentPath]];
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
