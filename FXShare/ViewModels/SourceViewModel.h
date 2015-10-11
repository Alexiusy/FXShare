//
//  SourceViewModel.h
//  FXShare
//
//  Created by Zeacone on 15/10/11.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SourceViewModel : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *protocol, *username, *url, *path;

@end
