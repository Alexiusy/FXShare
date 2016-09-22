//
//  FXNewInfoController.h
//  FXShare
//
//  Created by Zeacone on 16/9/19.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FXDatabaseManager.h"

@interface FXNewInfoController : NSWindowController

@property (nonatomic, assign) void(^feedbackBlock)(void);

- (IBAction)selectProtocol:(NSPopUpButton *)sender;


@property (weak) IBOutlet NSTextField *remoteField;

@property (weak) IBOutlet NSTextField *localField;

@property (weak) IBOutlet NSTextField *userField;
@property (weak) IBOutlet NSSecureTextField *passField;

- (IBAction)confirm:(NSButton *)sender;
- (IBAction)cancel:(NSButton *)sender;


@end
