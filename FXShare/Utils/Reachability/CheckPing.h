//
//  CheckPing.h
//  FXShare
//
//  Created by Zeacone on 15/10/13.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PingTool.h"
#import "SimplePingHelper.h"

@interface CheckPing : NSObject

@property (nonatomic, copy) NSString *host;

+ (instancetype)sharedChecker;
- (void)pingTool;

@end
