//
//  MainWindowController.m
//  FXShare
//
//  Created by Zeacone on 15/9/25.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import "MainWindowController.h"
#import "CheckPing.h"

@interface MainWindowController ()

@end

@implementation MainWindowController

//@synthesize sourcedata;

#pragma mark - Lifecycle

- (instancetype)initWithWindowNibName:(NSString *)windowNibName{
    if (self = [super initWithWindowNibName:windowNibName]) {
        [self showWindow:self];
        
        NSString *archivePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"archive"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
            [[NSFileManager defaultManager] createFileAtPath:archivePath contents:nil attributes:nil];
        }
        self.sourcedata = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:archivePath]];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - IBAction of config panel.

- (IBAction)showConfigWindowAsSheet:(NSButton *)sender {
    [self.mainWindow beginSheet:self.configWindow completionHandler:^(NSModalResponse returnCode) {
        NSString *archivePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"archive"];
        [NSKeyedArchiver archiveRootObject:self.sourcedata toFile:archivePath];
    }];
}

- (IBAction)confirmConfiguration:(NSButton *)sender {
    [self.mainWindow endSheet:self.configWindow];
}

- (IBAction)cancelConfiguration:(NSButton *)sender {
    [self.mainWindow endSheet:self.configWindow];
    [[CheckPing sharedChecker] pingTool];
}
@end
