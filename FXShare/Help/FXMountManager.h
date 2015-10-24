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
typedef void(^endBlock)(BOOL result, NSDictionary *parameter);

@interface FXMountManager : NSObject

/**
 *  Mount with parameter.
 *
 *  @param parameter         Parameter to mount. Include username, password, remote url and local path.
 *  @param startHandler      Callback of starting mount.
 *  @param completionHandler Callback of ending mount.
 *  @param timeout           Set timeout.
 */
- (void)mountWithParameter:(NSDictionary *)parameter start:(startBlock)startHandler completion:(endBlock)completionHandler timeout:(NSTimeInterval)timeout;

/**
 *  Unmount with parameter.
 *
 *  @param parameter Parameter to unmount include username, password, remote url and local path.
 */
- (void)unmountWithParameter:(NSDictionary *)parameter;

/**
 *  Check if the mount disconnect.
 *
 *  @param parameter Mount parameter.
 */
- (void)isMountParameterOnline:(NSDictionary *)parameter;

@end
