//
//  FXMountManager.h
//  FXShare
//
//  Created by Zeacone on 15/10/24.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NetFS/NetFS.h>

typedef void(^startBlock)();
typedef void(^endBlock)(NSInteger status, AsyncRequestID requestID, CFArrayRef mountpoints);

@interface FXMountManager : NSObject

@property (nonatomic, assign) startBlock startBlk;
@property (nonatomic, assign) endBlock endBlk;

/**
 *  Mount with parameter.
 *
 *  @param parameter         Parameter to mount. Include username, password, remote url and local path.
 *  @param startHandler      Callback of starting mount.
 *  @param completionHandler Callback of ending mount.
 *  @param timeout           Set timeout.
 */
- (void)mountWithParameter:(NSDictionary *)parameter onQueue:(dispatch_queue_t)queue start:(startBlock)startHandler completion:(endBlock)completionHandler timeout:(NSTimeInterval)timeout;

/**
 *  Unmount with parameter.
 *
 *  @param parameter         parameter Parameter to unmount include username, password, remote url and local path.
 *  @param completionHandler Callback of unmount result.
 */
- (void)unmountWithParameter:(NSDictionary *)parameter completion:(void(^)(BOOL result, NSString *reason))completionHandler;

/**
 *  Check if the mount disconnect.
 *
 *  @param parameter Mount parameter.
 */
- (BOOL)isMountParameterOnline:(NSDictionary *)parameter;

@end
