//
//  AppDelegate.h
//  FXShare
//
//  Created by Zeacone on 15/9/25.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MainWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong) MainWindowController *mainController;

- (IBAction)click:(NSButton *)sender;

@end