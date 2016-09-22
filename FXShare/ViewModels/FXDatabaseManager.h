//
//  FXDatabaseManager.h
//  FXShare
//
//  Created by Zeacone on 16/9/20.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXDataSourceModel.h"
#import <FMDB.h>
#import <FMDatabase.h>
#import <FMResultSet.h>

@interface FXDatabaseManager : NSObject

+ (FXDatabaseManager *)defaultDatabaseManager;

- (void)insertModel:(FXDataSourceModel *)model;
- (void)deleteModel:(FXDataSourceModel *)model;
- (void)updateModel:(FXDataSourceModel *)model;
- (NSArray<FXDataSourceModel *> *)queryFromDatabase;

@end
