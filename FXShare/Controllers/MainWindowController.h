//
//  MainWindowController.h
//  FXShare
//
//  Created by Zeacone on 16/9/18.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FXDatabaseManager.h"

@interface MainWindowController : NSWindowController <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSScrollView *scrollview;

@property (nonatomic, strong) NSArray<FXDataSourceModel *> *models;
- (IBAction)addNewModel:(NSButton *)sender;


- (IBAction)editInformation:(NSButton *)sender;

- (IBAction)deleteInformation:(NSButton *)sender;

- (IBAction)offline:(NSButton *)sender;

- (IBAction)openDiretory:(NSButton *)sender;


@end
