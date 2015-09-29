//
//  MainWindowController.m
//  FXShare
//
//  Created by Zeacone on 15/9/25.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import "MainWindowController.h"

@interface MainWindowController ()

@end

@implementation MainWindowController

#pragma mark - Lifecycle

- (instancetype)initWithWindowNibName:(NSString *)windowNibName{
    if (self = [super initWithWindowNibName:windowNibName]) {
        [self showWindow:self];
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
        
    }];
}

- (IBAction)confirmConfiguration:(NSButton *)sender {
    [self.mainWindow endSheet:self.configWindow];
}

- (IBAction)cancelConfiguration:(NSButton *)sender {
    [self.mainWindow endSheet:self.configWindow];
}
@end
