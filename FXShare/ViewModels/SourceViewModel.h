//
//  SourceViewModel.h
//  FXShare
//
//  Created by Zeacone on 15/10/11.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SourceViewModel : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger count, selectedProtocol;
@property (nonatomic, copy) NSString *protocol, *username, *password, *url, *path;

@end
