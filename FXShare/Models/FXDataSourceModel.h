//
//  FXMainModel.h
//  FXShare
//
//  Created by Zeacone on 16/9/18.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MountProtocol) {
    MountProtocolNFS,
    MountProtocolCIFS,
};

@interface FXDataSourceModel : NSObject

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) NSString *remoteAddress;

@property (nonatomic, copy) NSString *localAddress;

@property (nonatomic, assign) MountProtocol protocol;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *password;

@end
