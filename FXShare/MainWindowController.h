//
//  MainWindowController.h
//  FXShare
//
//  Created by Zeacone on 15/9/25.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainWindowController : NSWindowController {
//    @private
    NSString *_username;
//    NSMutableArray *sourcedata;
}

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

#pragma mark - Config window elements
@property (nonatomic, copy) NSString  *protocol;
@property (nonatomic, copy) NSString  *userField;
@property (nonatomic, copy) NSString  *passField;
@property (nonatomic, copy) NSString  *urlField;
@property (nonatomic, copy) NSString  *pathField;
@property (copy) NSMutableArray *sourcedata;

@end
