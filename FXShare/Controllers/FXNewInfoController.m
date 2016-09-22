//
//  FXNewInfoController.m
//  FXShare
//
//  Created by Zeacone on 16/9/19.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import "FXNewInfoController.h"

@interface FXNewInfoController ()

@property (nonatomic, strong) FXDataSourceModel *model;

@end

@implementation FXNewInfoController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    // 设置标题栏透明
    self.window.styleMask = self.window.styleMask | NSFullSizeContentViewWindowMask;
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.titlebarAppearsTransparent = YES;
    
    self.model = [FXDataSourceModel new];
    
    
}

- (IBAction)selectProtocol:(NSPopUpButton *)sender {
    
    sender.title = sender.selectedItem.title;
    if ([sender.title isEqualToString:@"NFS"]) {
        self.model.protocol = MountProtocolNFS;
    } else {
        self.model.protocol = MountProtocolCIFS;
    }
}

- (IBAction)confirm:(NSButton *)sender {
    
    self.model.remoteAddress = self.remoteField.stringValue;
    self.model.localAddress = self.localField.stringValue;
    self.model.username = self.userField.stringValue;
    self.model.password = self.passField.stringValue;
    
    _feedbackBlock();
    
    [[FXDatabaseManager defaultDatabaseManager] insertModel:self.model];
    [self.window orderOut:nil];
}

- (void)dealloc {
    NSLog(@"hahahaha");
}

- (IBAction)cancel:(NSButton *)sender {
    _feedbackBlock();
    [self.window orderOut:nil];
}
@end
