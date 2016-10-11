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

@interface MainWindowController () <FXNewInfoDelegate>

@property (nonatomic, strong) FXNewInfoController *infoController;

@property (nonatomic, strong) NSMutableArray<NSString *> *statusArray;

@end

@implementation MainWindowController

- (instancetype)initWithWindowNibName:(NSString *)windowNibName {
    self.models = [[[FXDatabaseManager defaultDatabaseManager] queryFromDatabase] mutableCopy];
    self.statusArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.models.count; i++) {
        [self.statusArray addObject:@"online"];
    }
    
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
        
        NSImage *image;
        
        if ([self.statusArray[row] isEqualToString:@"online"]) {
            image = [NSImage imageNamed:@"icon_status-online"];
        } else {
            image = [NSImage imageNamed:@"icon_status-inactive"];
        }
        statusview.image = image;
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
    
}

#pragma mark - Side menu method
- (IBAction)addNewModel:(NSButton *)sender {
    
    self.infoController = [[FXNewInfoController alloc] initWithWindowNibName:@"FXNewInfoController"];
    self.infoController.delegate = self;
    
    [self.window beginSheet:self.infoController.window completionHandler:nil];
}

- (void)feedbackModel:(FXDataSourceModel *)model {
    
    if (!model) {
        return;
    }
    [self.models addObject:model];
    [self.statusArray addObject:@"offline"];
    [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.models.count-1] withAnimation:NSTableViewAnimationSlideUp];
}

- (void)buttonAction:(NSButton *)sender {
    
    NSInteger row = (sender.tag - 2) / 10;
    
    [self.statusArray replaceObjectAtIndex:row withObject:@"offline"];
    NSIndexSet *rowSet = [NSIndexSet indexSetWithIndex:row];
    NSIndexSet *colSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 6)];
    [self.tableView reloadDataForRowIndexes:rowSet columnIndexes:colSet];
}

@end
