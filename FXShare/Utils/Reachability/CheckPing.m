//
//  CheckPing.m
//  FXShare
//
//  Created by Zeacone on 15/10/13.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import "CheckPing.h"

@interface CheckPing ()

@property (nonatomic, strong) NSMutableArray *connectionHosts;

@end

@implementation CheckPing

+ (instancetype)sharedChecker {
    static CheckPing *checker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        checker = [[self alloc] init];
    });
    return checker;
}

#pragma mark - Basic configuration

static dispatch_group_t get_check_server_connection_group() {
    static dispatch_group_t check_server_group;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        check_server_group = dispatch_group_create();
    });
    return check_server_group;
}

static dispatch_queue_t get_check_server_connection_queue() {
    static dispatch_queue_t check_server_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        check_server_queue = dispatch_queue_create("server.connection.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return check_server_queue;
}

- (void)pingTool {
    
    PingTool *pingTool = [[PingTool alloc] init];
    [pingTool pingTool];
//    self.connectionHosts = [[NSMutableArray alloc] initWithObjects:@"104.128.83.142", @"104.12.32.22", @"104.12.32.23", @"104.12.32.24", @"104.12.32.25", @"104.12.32.26", @"104.12.32.27", @"104.12.32.28", @"104.12.32.29", @"104.12.32.30", @"104.12.32.31", @"104.12.32.32", @"104.12.32.33", @"104.12.32.34", @"104.12.32.35", @"104.12.32.36", @"104.128.83.143", @"104.12.32.38", @"104.12.32.39", @"104.12.32.40", nil];
//    
//    dispatch_async(get_check_server_connection_queue(), ^{
//        NSTimer *timer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(executeChecking) userInfo:nil repeats:YES];
//        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
//        [runloop addTimer:timer forMode:NSDefaultRunLoopMode];
//        [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    });
}

- (void)executeChecking {
    
    for (NSString *host in self.connectionHosts) {
        dispatch_group_async(get_check_server_connection_group(), get_check_server_connection_queue(), ^{
//            @autoreleasepool {
//                PingTool *pinger = [[PingTool alloc] init];
//                [pinger pingWithHost:host];
                [SimplePingHelper ping:host target:self sel:@selector(result:)];
//            }
        });
    }
    
    dispatch_group_notify(get_check_server_connection_group(), get_check_server_connection_queue(), ^{
        NSLog(@"All done.");
    });
    
//    [SimplePingHelper ping:@"104.128.84.143" target:self sel:@selector(result:)];
}

- (void)result:(NSNumber *)success {
    NSLog(@"result = %hhd, thread = %@", success.boolValue, [NSThread currentThread]);
//    if (!self.connectionHosts) {
//        self.connectionHosts = [[NSMutableArray alloc] init];
//    }
//    if (success.boolValue) {
//        [self.connectionHosts addObject:success];
//    }
}



@end
