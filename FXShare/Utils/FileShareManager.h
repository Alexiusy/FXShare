//
//  FileShareManager.h
//  FXShare
//
//  Created by Zeacone on 15/9/27.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileShareManager : NSObject

- (void)connectWithParameter:(NSDictionary *)parameter start:(void(^)(BOOL start))startBlock result:(void(^)(BOOL result, NSInteger code))resultBlock;
- (void)checkConnectIsOnline:(NSDictionary *)parameter;
- (void)disConnectWithParameter:(NSDictionary *)parameter;
- (void)cancelConnectWithParameter:(NSDictionary *)parameter;

@end
