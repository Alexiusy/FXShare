//
//  AppDelegate.m
//  FXShare
//
//  Created by Zeacone on 15/9/25.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self.window setLevel:kCGBaseWindowLevelKey];
    
    self.mainController = [[MainWindowController alloc] initWithWindowNibName:@"MainWindowController"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)click:(NSButton *)sender {
    [self.mainController.mainWindow makeKeyAndOrderFront:self];
    [self.mainController.mainWindow setLevel:kCGBaseWindowLevelKey];
    [self.window orderOut:self];
}
@end
