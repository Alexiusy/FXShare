//
//  PingTool.h
//  FXShare
//
//  Created by Zeacone on 15/10/18.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePing.h"

typedef void(^resultBlock)(BOOL result, NSString *host, NSString *remark);

@interface FXPingTool : NSObject <SimplePingDelegate>

/**
 *  A block for ping callback.
 */
@property (nonatomic, copy) resultBlock resultBlk;

- (void)startPingWithHost:(NSString *)host completion:(resultBlock)completionHandler;

@end

@interface FXCheckingTool : NSObject

+ (instancetype)sharedCheckingTool;
- (void)startChecking;
- (BOOL)isHostOnline:(NSString *)host;

@end
