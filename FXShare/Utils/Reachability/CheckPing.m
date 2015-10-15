//
//  CheckPing.m
//  FXShare
//
//  Created by Zeacone on 15/10/13.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import "CheckPing.h"

@implementation CheckPing

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self pingTool];
    }
    return self;
}

- (void)pingTool {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group, queue, ^{
        
    });
}

@end
