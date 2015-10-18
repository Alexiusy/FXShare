//
//  PingTool.h
//  FXShare
//
//  Created by Zeacone on 15/10/18.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePing.h"

@interface PingTool : NSObject <SimplePingDelegate>

- (void)startPing;

@end
