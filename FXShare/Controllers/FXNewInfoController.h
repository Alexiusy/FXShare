//
//  FXNewInfoController.h
//  FXShare
//
//  Created by Zeacone on 16/9/19.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FXDatabaseManager.h"

@protocol FXNewInfoDelegate <NSObject>

- (void)feedbackModel:(FXDataSourceModel *)model;

@end

@interface FXNewInfoController : NSWindowController

@property (nonatomic, weak) id<FXNewInfoDelegate> delegate;

@property (nonatomic, assign) void(^feedbackBlock)(FXDataSourceModel *model);

- (IBAction)selectProtocol:(NSPopUpButton *)sender;


@property (weak) IBOutlet NSTextField *remoteField;

@property (weak) IBOutlet NSTextField *localField;

@property (weak) IBOutlet NSTextField *userField;
@property (weak) IBOutlet NSSecureTextField *passField;

- (IBAction)confirm:(NSButton *)sender;
- (IBAction)cancel:(NSButton *)sender;


@end
