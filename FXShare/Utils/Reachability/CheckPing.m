//
//  CheckPing.m
//  FXShare
//
//  Created by Zeacone on 15/10/13.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import "CheckPing.h"

@implementation CheckPing

+ (instancetype)sharedChecker {
    static CheckPing *checker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        checker = [[self alloc] init];
    });
    return checker;
}

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
    dispatch_group_async(get_check_server_connection_group(), get_check_server_connection_queue(), ^{
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(executeChecking) userInfo:nil repeats:YES];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runloop addTimer:timer forMode:NSRunLoopCommonModes];
        [runloop run];
    });
}

- (void)executeChecking {
    [SimplePingHelper ping:@"104.128.84.143" target:self sel:@selector(result:)];
}

- (void)result:(NSNumber *)success {
    NSLog(@"result = %hhd, thread = %@", success.boolValue, [NSThread currentThread]);
}

- (void)connectionPool {
    
}

@end
