//
//  PingTool.m
//  FXShare
//
//  Created by Zeacone on 15/10/18.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import "FXPingTool.h"

#pragma mark - Basic configuration

#define CAPACITY 30
#define MAX_CONCURRENT_NUMBER 5

typedef struct LRU_Node {
    __unsafe_unretained NSString *key;
    __unsafe_unretained NSString *value;
    struct LRU_Node *prev;
    struct LRU_Node *next;
} LRU_Node;

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

#pragma mark - Pinging

@interface FXPingTool ()

@property (nonatomic, strong) SimplePing *simplePing;
@property (nonatomic, strong) NSMutableArray *connectionHosts;

@end

@implementation FXPingTool

#pragma mark - Start pinging

- (void)startPingWithHost:(NSString *)host completion:(resultBlock)completionHandler {
    self.resultBlk = completionHandler;
    self.simplePing = [SimplePing simplePingWithHostName:host];
    self.simplePing.delegate = self;
    [self.simplePing start];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self timeoutPing];
    });
}

- (void)dealloc {
    NSLog(@"Dealloc.");
}

#pragma mark - Deal with ping result

- (void)successPing {
    NSLog(@"%@ success!", self.simplePing.hostName);
    self.resultBlk(YES, self.simplePing.hostName, nil);
    [self killPing];
}

- (void)failPing:(NSString *)reason {
    NSLog(@"%@ %@", self.simplePing.hostName, reason);
    self.resultBlk(NO, self.simplePing.hostName, reason);
    [self killPing];
}

- (void)timeoutPing {
    if (self.simplePing) {
        [self failPing:@"timeout."];
    }
}

- (void)killPing {
    [self.simplePing stop];
    self.simplePing = nil;
}

#pragma mark - SimplePing delagate

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address {
    [self.simplePing sendPingWithData:nil];
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet {
    [self successPing];
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet error:(NSError *)error {
    [self failPing:@"Fail to send packet."];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error {
    [self failPing:[NSString stringWithFormat:@"Fail with error: %@", error]];
}

- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet {
    [self failPing:@"Receive unexpected packet."];
}

@end

#pragma mark - Checking

@interface FXCheckingTool ()

@property (nonatomic, strong) NSMutableArray *hosts, *onlineHosts;

// About LRU
@property (nonatomic) LRU_Node *head;
@property (nonatomic) LRU_Node *tail;
@property (nonatomic, assign) NSInteger capacity;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableDictionary *hash_hosts;

@end

@implementation FXCheckingTool

+ (instancetype)sharedCheckingTool {
    static FXCheckingTool *checkingTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        checkingTool = [[self alloc] init];
    });
    return checkingTool;
}

- (void)startChecking {
    
    self.hosts = [[NSMutableArray alloc] initWithObjects:@"104.128.83.142", @"104.12.32.22", @"104.12.32.23", @"104.12.32.24", @"104.12.32.25", @"104.12.32.26", @"104.12.32.27", @"104.12.32.28", @"104.12.32.29", @"104.12.32.30", @"104.12.32.31", @"104.12.32.32", @"104.12.32.33", @"104.12.32.34", @"104.12.32.35", @"104.12.32.36", @"104.128.83.143", @"104.12.32.38", @"104.12.32.39", @"104.12.32.40", nil];
    self.onlineHosts = [[NSMutableArray alloc] init];
    
    dispatch_async(get_check_server_connection_queue(), ^{
        NSTimer *timer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(executeChecking) userInfo:nil repeats:YES];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runloop addTimer:timer forMode:NSRunLoopCommonModes];
        [runloop run];
    });
    [self initLRUNode];
}

- (void)executeChecking {
    __weak typeof(self)weakSelf = self;
    
    for (NSString *host in self.hosts) {
        FXPingTool *pingTool = [[FXPingTool alloc] init];
        [pingTool startPingWithHost:host completion:^(BOOL result, NSString *host, NSString *remark) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (result && ![strongSelf.onlineHosts containsObject:host]) {
                [strongSelf setHost:host forKey:host];
            }
        }];
    }
}

- (BOOL)isHostOnline:(NSString *)host {
    return [self getHostFromKey:host] != nil;
}

- (void)initLRUNode {
    self.hash_hosts = [NSMutableDictionary dictionary];
    self.capacity = CAPACITY;
    self.count = 0;
    self.head->prev = NULL;
    self.head->next = self.tail;
    self.tail->prev = self.head;
    self.tail->next = NULL;
}

- (void)detachNode:(LRU_Node *)node {
    node->prev->next = node->next;
    node->next->prev = node->prev;
}

- (void)moveNodeToFront:(LRU_Node *)node {
    node->prev = self.head;
    node->next = self.head->next;
    self.head->next = node;
    node->next->prev = node;
}

- (void)removeNode {
    LRU_Node *node = self.tail->prev;
    [self detachNode:node];
    [self.hash_hosts removeObjectForKey:node->key];
    --self.count;
}

- (void)setHost:(NSString *)host forKey:(NSString *)key {
    if (![self.hash_hosts valueForKey:key]) {
        LRU_Node *node = {nil, nil, NULL, NULL};
        if (self.count == self.capacity) [self removeNode];
        
        node->key = key;
        node->value = host;
        [self.hash_hosts setObject:(__bridge id _Nonnull)(node) forKey:key];
        [self moveNodeToFront:node];
        ++self.count;
    }
}

- (NSString *)getHostFromKey:(NSString *)key {
    LRU_Node *node = (__bridge LRU_Node *)([self.hash_hosts valueForKey:key]);
    if (!node) {
        return nil;
    } else {
        [self detachNode:node];
        [self moveNodeToFront:node];
        return node->value;
    }
}

@end
