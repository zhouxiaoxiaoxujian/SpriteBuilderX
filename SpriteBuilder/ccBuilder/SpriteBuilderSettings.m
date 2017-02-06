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
        [self loadSBSettings];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir;
        if(![fileManager fileExistsAtPath:backupPath isDirectory:&isDir]) {
            if(![fileManager createDirectoryAtPath:backupPath withIntermediateDirectories:YES attributes:nil error:NULL]) {
                NSLog(@"Error: Create backups folder failed %@", backupPath);
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
    enableBackup = [[sbsettings valueForKey:@"enableBackup"] boolValue];
    selectedTab = [[sbsettings valueForKey:@"selectedTab"] intValue];
    selectedBackupTimeInterval = [[sbsettings valueForKey:@"selectedBackupTimeInterval"] intValue];
    backupPath = ([sbsettings valueForKey:@"backupPath"] != nil) ? [sbsettings valueForKey:@"backupPath"] : [SpriteBuilderSettings defaultBackupPath];
}

- (void)saveSBSettings {
    [sbsettings setObject:@(self.backupIntervalPopUpButton.selectedTag) forKey:@"selectedBackupTimeInterval"];
    [sbsettings setObject:@([self.settingsTabView.selectedTabViewItem.identifier intValue]) forKey:@"selectedTab"];
    [sbsettings setObject:@(enableBackup) forKey:@"enableBackup"];
    [sbsettings setObject:self.backupPathField.stringValue forKey:@"backupPath"];
    [sbsettings synchronize];
}

- (IBAction)resetBackupSettings:(id)sender {
    selectedBackupTimeInterval = 60;
    backupPath = [SpriteBuilderSettings defaultBackupPath];
    [self.backupIntervalPopUpButton selectItemWithTag:selectedBackupTimeInterval];
    [self.backupPathField setStringValue:backupPath];
}

+(NSString *) defaultBackupPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *productName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    NSString *defaultPath = [[[paths firstObject] stringByAppendingPathComponent:productName] stringByAppendingPathComponent:@"Backups"];
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
