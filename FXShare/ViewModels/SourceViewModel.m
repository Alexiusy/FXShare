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
        if (self.selectedProtocol == 0) {
            self.protocol = @"NFS";
        } else {
            self.protocol = @"CIFS";
        }
        self.count = 2;
        self.username = @"Zeacone";
        self.url = @"127.0.0.1/cifs";
        self.path = @"/Users/Zeacone/Desktop/show/";
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.selectedProtocol = [[aDecoder decodeObjectForKey:@"protocol"] integerValue];
        self.count            = [[aDecoder decodeObjectForKey:@"count"] integerValue];
        self.username         = [aDecoder decodeObjectForKey:@"username"];
        self.password         = [aDecoder decodeObjectForKey:@"password"];
        self.url              = [aDecoder decodeObjectForKey:@"url"];
        self.path             = [aDecoder decodeObjectForKey:@"path"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.selectedProtocol] forKey:@"protocol"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.count] forKey:@"count"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.path forKey:@"path"];
}

@end
