//
//  PingTool.h
//  FXShare
//
//  Created by Zeacone on 15/10/18.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePing.h"
#import "SimplePingHelper.h"

@interface PingTool : NSObject <SimplePingDelegate>

- (void)pingWithHost:(NSString *)host;
- (void)pingTool;

@end
