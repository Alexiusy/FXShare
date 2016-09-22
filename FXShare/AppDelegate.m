//
//  AppDelegate.m
//  FXShare
//
//  Created by Zeacone on 16/9/18.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic, strong) MainWindowController *mainWindowController;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.window.styleMask = self.window.styleMask | NSFullSizeContentViewWindowMask;
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.titlebarAppearsTransparent = YES;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(openNewWindow) userInfo:nil repeats:NO];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)openNewWindow {
    self.mainWindowController = [[MainWindowController alloc] initWithWindowNibName:@"MainWindowController"];
    [self.mainWindowController.window makeKeyAndOrderFront:self];
    [self.mainWindowController.window setLevel:kCGBaseWindowLevelKey];
    [self.window orderOut:self];
}

@end
