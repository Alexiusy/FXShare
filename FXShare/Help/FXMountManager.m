//
//  FXMountManager.m
//  FXShare
//
//  Created by Zeacone on 15/10/24.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import "FXMountManager.h"

static AsyncRequestID requestID = NULL;

@implementation FXMountManager

- (void)mountWithParameter:(NSDictionary *)parameter onQueue:(dispatch_queue_t)queue start:(startBlock)startHandler completion:(endBlock)completionHandler timeout:(NSTimeInterval)timeout {
    
    // TODO
    // Convert to UTF-8 for supporting Chinese. Add mount_option and open_options.
    NSString *username = parameter[@"username"];
    NSString *password = parameter[@"password"];
    NSString *url = parameter[@"url"];
    NSString *path = parameter[@"path"];
    
    CFMutableDictionaryRef open_options = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
    CFMutableDictionaryRef mount_options = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
    
    NetFSMountURLBlock block = (NetFSMountURLBlock) completionHandler;
    
    NetFSMountURLAsync((__bridge CFURLRef)([NSURL URLWithString:url]),
                       (__bridge CFURLRef)([NSURL URLWithString:path]),
                       (__bridge CFStringRef)(username),
                       (__bridge CFStringRef)(password),
                       open_options,
                       mount_options,
                       &requestID,
                       queue,
                       block);
}

- (void)unmountWithParameter:(NSDictionary *)parameter completion:(void(^)(BOOL result, NSString *reason))completionHandler {
    NSURL *localPathUrl = [NSURL URLWithString:parameter[@"path"]];
    [[NSFileManager defaultManager] unmountVolumeAtURL:localPathUrl options:NSFileManagerUnmountWithoutUI completionHandler:^(NSError * _Nullable errorOrNil) {
        if (errorOrNil) {
            completionHandler(NO, errorOrNil.localizedFailureReason);
        } else {
            completionHandler(YES, nil);
        }
    }];
}

- (BOOL)isMountParameterOnline:(NSDictionary *)parameter {
    NSArray *keys = [NSArray arrayWithObjects:NSURLVolumeURLKey, NSURLVolumeNameKey, NSURLVolumeIsRemovableKey, nil];
    NSArray *mountpoints = [[NSArray alloc] init];
    mountpoints = [[NSFileManager defaultManager] mountedVolumeURLsIncludingResourceValuesForKeys:keys options:NSVolumeEnumerationSkipHiddenVolumes];
    return [mountpoints containsObject:parameter[@"path"]];
}

@end
