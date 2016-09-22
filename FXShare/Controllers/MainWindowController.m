//
//  MainWindowController.m
//  FXShare
//
//  Created by Zeacone on 16/9/18.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import "MainWindowController.h"
#import "INAppStoreWindow.h"
#import "FXNewInfoController.h"

@interface MainWindowController ()

@property (nonatomic, strong) FXNewInfoController *infoController;

@end

@implementation MainWindowController

- (instancetype)initWithWindowNibName:(NSString *)windowNibName {
    self.models = [[FXDatabaseManager defaultDatabaseManager] queryFromDatabase];
    return [super initWithWindowNibName:windowNibName];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    // 设置标题栏透明
//    self.window.styleMask = self.window.styleMask | NSFullSizeContentViewWindowMask;
//    self.window.titleVisibility = NSWindowTitleHidden;
//    self.window.titlebarAppearsTransparent = YES;
    
    [self windowSetting];
    [self viewSetting];
}

- (void)windowSetting {
    
    INAppStoreWindow *window = (INAppStoreWindow *)self.window;
    window.titleBarHeight = 60;
    window.showsBaselineSeparator = NO;
    
    [window setTitleBarDrawingBlock:^(BOOL drawsAsMainWindow, CGRect drawingRect, CGRectEdge edge, CGPathRef clippingPath){
        // Custom drawing code!
        [[NSColor colorWithRed:0/255.0 green:150/255.0 blue:136/255.0 alpha:1.0] set];
        NSRectFill(drawingRect);
    }];
}

- (void)viewSetting {
    
    [self.scrollview setDrawsBackground:NO];
    self.tableView.backgroundColor = [NSColor clearColor];
//    [self.tableView setAlphaValue:0.2];
//    self.scrollview.backgroundColor = [NSColor clearColor];
    
    [self.tableView sizeLastColumnToFit];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - delegate/datasource of tableview
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.models.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
//    result.textField.stringValue = @"123";
    if ([tableColumn.identifier isEqualToString:@"number"])
    {
        result.textField.stringValue = [NSString stringWithFormat:@"%ld", row+1];
    }
    else if ([tableColumn.identifier isEqualToString:@"address"])
    {
        result.textField.stringValue = self.models[row].remoteAddress;
    }
    else if ([tableColumn.identifier isEqualToString:@"username"])
    {
        result.textField.stringValue = self.models[row].username;
    }
    else if ([tableColumn.identifier isEqualToString:@"protocol"])
    {
        result.textField.stringValue = self.models[row].protocol == MountProtocolNFS ? @"NFS" : @"CIFS";
    }
    else if ([tableColumn.identifier isEqualToString:@"status"])
    {
        NSImageView *statusview = (NSImageView *)result.subviews.firstObject;
        statusview.tag = row * 100;
    }
    else if ([tableColumn.identifier isEqualToString:@"operation"])
    {
        for (NSInteger i = 0; i < result.subviews.count; i++) {
            NSButton *button = (NSButton *)result.subviews[i];
            [button setAction:@selector(buttonAction:)];
            button.tag = row * 10 + i;
        }
    }
    return result;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 40;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {

//    CGRect panelRect = CGRectOffset(self.window.frame, CGRectGetWidth(self.window.frame), 0);
//    NSPanel *panel = [[NSPanel alloc] initWithContentRect:panelRect styleMask:NSBorderlessWindowMask | NSNonactivatingPanelMask backing:NSBackingStoreBuffered defer:YES];
//    [panel setLevel:NSScreenSaverWindowLevel];
//    [panel orderFront:nil];
    
    
}

- (IBAction)addNewModel:(NSButton *)sender {
    
    self.infoController = [[FXNewInfoController alloc] initWithWindowNibName:@"FXNewInfoController"];
    
    __weak typeof(self) weakSelf = self;
    [self.infoController setFeedbackBlock:^{
//        NSLog(@"%@", weakSelf.windowNibName);
//        __strong typeof(weakSelf) strongSelf = weakSelf;
    }];
    
    [self.window beginSheet:self.infoController.window completionHandler:^(NSModalResponse returnCode) {
        
        NSLog(@"return code = %@", @(returnCode));
    }];
}

- (void)buttonAction:(NSButton *)sender {
    NSLog(@"hijack.");
    NSInteger row = (sender.tag - 2) / 10;
    
    NSTableCellView *result = [self.tableView makeViewWithIdentifier:@"status" owner:self];
    
    NSImageView *image = (NSImageView *)result.subviews.firstObject;
    [image setImage:[NSImage imageNamed:@"icon_status-online"]];
//    image.image = [NSImage imageNamed:@"icon_status-online"];
    [self.tableView reloadData];
}

- (IBAction)editInformation:(NSButton *)sender {
    
//    sender.tag
}

- (IBAction)deleteInformation:(NSButton *)sender {
}

- (IBAction)offline:(NSButton *)sender {
    
    NSInteger row = (sender.tag - 2) / 10;
    
    NSTableCellView *result = [self.tableView makeViewWithIdentifier:@"status" owner:self];
    
    NSImageView *image = (NSImageView *)[result viewWithTag:row];
    image.image = [NSImage imageNamed:@"icon_status-online"];
}

- (IBAction)openDiretory:(NSButton *)sender {
}
@end
