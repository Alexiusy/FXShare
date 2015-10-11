//
//  SourceViewModel.m
//  FXShare
//
//  Created by Zeacone on 15/10/11.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import "SourceViewModel.h"

@implementation SourceViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.protocol = @"CIFS";
        self.count = 2;
        self.username = @"Zeacone";
        self.url = @"127.0.0.1/cifs";
        self.path = @"/Users/Zeacone/Desktop/show/";
    }
    return self;
}

@end
