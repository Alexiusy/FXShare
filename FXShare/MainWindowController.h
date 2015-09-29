//
//  MainWindowController.h
//  FXShare
//
//  Created by Zeacone on 15/9/25.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainWindowController : NSWindowController

@property (strong) IBOutlet NSWindow *mainWindow;
@property (strong) IBOutlet NSWindow *configWindow;

/**
 *  Show the configuration panel which you can add a new mount information.
 *  It includes protocol, mount path, local point, username and password.
 */
- (IBAction)showConfigWindowAsSheet:(NSButton *)sender;

/**
 *  Add new information.
 */
- (IBAction)confirmConfiguration:(NSButton *)sender;

/**
 *  Cancel adding new information
 */
- (IBAction)cancelConfiguration:(NSButton *)sender;

@end
