//
//  PingTool.m
//  FXShare
//
//  Created by Zeacone on 15/10/18.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import "PingTool.h"

@interface PingTool ()

@property (nonatomic, strong) SimplePing *simplePing;
@property (nonatomic, strong) NSMutableArray *connectionHosts;

@end

@implementation PingTool

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

- (void)startPing {
    
    self.connectionHosts = [[NSMutableArray alloc] initWithObjects:@"104.128.83.142", @"104.12.32.22", @"104.12.32.23", @"104.12.32.24", @"104.12.32.25", @"104.12.32.26", @"104.12.32.27", @"104.12.32.28", @"104.12.32.29", @"104.12.32.30", @"104.12.32.31", @"104.12.32.32", @"104.12.32.33", @"104.12.32.34", @"104.12.32.35", @"104.12.32.36", @"104.128.83.143", @"104.12.32.38", @"104.12.32.39", @"104.12.32.40", nil];
    
    dispatch_async(get_check_server_connection_queue(), ^{
        NSTimer *timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(executePing) userInfo:nil repeats:YES];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runloop addTimer:timer forMode:NSRunLoopCommonModes];
        [runloop run];
    });
}

#pragma mark - Start pinging

- (void)executePing {
    for (NSString *host in self.connectionHosts) {
        @autoreleasepool {
            SimplePing *pinger = [SimplePing simplePingWithHostName:host];
            pinger.delegate = self;
            [pinger start];
            [self performSelector:@selector(timeoutPing:) withObject:pinger afterDelay:3.0];
        }
    }
}

#pragma mark - Deal with ping result

- (void)successPing:(SimplePing *)pinger {
    [self killPing:pinger];
    NSLog(@"%@ success!", pinger.hostName);
}

- (void)failPing:(SimplePing *)pinger reason:(NSString *)reason {
    [self killPing:pinger];
    NSLog(@"%@ %@", pinger.hostName, reason);
}

- (void)timeoutPing:(SimplePing *)pinger {
    if (pinger) {
        [self failPing:pinger reason:[NSString stringWithFormat:@"%@ timeout.", pinger.hostName]];
    }
}

- (void)killPing:(SimplePing *)pinger {
    [pinger stop];
    pinger = nil;
}

#pragma mark - SimplePing delagate

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address {
    [pinger sendPingWithData:nil];
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet {
    [self successPing:pinger];
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet error:(NSError *)error {
    [self failPing:pinger reason:@"Fail to send packet."];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error {
    [self failPing:pinger reason:[NSString stringWithFormat:@"Fail with error: %@", error]];
}

- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet {
    [self failPing:pinger reason:@"Receive unexpected packet."];
}

@end
