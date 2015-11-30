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
    
    
    if (self.protocol.selectedTag == 0) {
        
    }
    NSDictionary *inputConfig = [NSDictionary dictionaryWithObjectsAndKeys:self.username.stringValue, @"username", self.password.stringValue, @"password", self.url.stringValue, @"url", self.path.stringValue, @"path", nil];
    [[NSUserDefaults standardUserDefaults] setObject:inputConfig forKey:@"inputConfig"];
}

- (IBAction)confirmConfiguration:(NSButton *)sender {
    [self.mainWindow endSheet:self.configWindow];
}

- (IBAction)cancelConfiguration:(NSButton *)sender {
    [self.mainWindow endSheet:self.configWindow];
}

- (IBAction)connect:(NSButton *)sender {
    dispatch_group_t mount_group = dispatch_group_create();
    dispatch_queue_t mount_queue = dispatch_queue_create("mount.queue", DISPATCH_QUEUE_CONCURRENT);
    
    // Add semaphore to control queue-concurrent.
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(5);
    for (NSDictionary *parameter in self.sourceData) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        FXMountManager *mountManager = [[FXMountManager alloc] init];
        dispatch_group_async(mount_group, mount_queue, ^{
            [mountManager mountWithParameter:parameter onQueue:mount_queue start:^{
                NSLog(@"Mount start.");
            } completion:^(NSInteger status, AsyncRequestID requestID, CFArrayRef mountpoints) {
                NSLog(@"Mount complete.");
            } timeout:30.0];
        });
        dispatch_semaphore_signal(semaphore);
    }
    dispatch_group_notify(mount_group, mount_queue, ^{
        NSLog(@"Time to stop progress indicator.");
    });
}

- (IBAction)disconnect:(NSButton *)sender {
}

- (IBAction)cancelConnect:(NSButton *)sender {
}

- (IBAction)modify:(NSButton *)sender {
}
@end
