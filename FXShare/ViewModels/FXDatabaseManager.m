//
//  FXDatabaseManager.m
//  FXShare
//
//  Created by Zeacone on 16/9/20.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import "FXDatabaseManager.h"

@interface FXDatabaseManager ()

@property (nonatomic, strong) FMDatabase *db;

@end


@implementation FXDatabaseManager

+ (FXDatabaseManager *)defaultDatabaseManager {
    
    static FXDatabaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [FXDatabaseManager new];
        [manager createTable];
    });
    return manager;
}

- (void)createTable {
    
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"db.sqlite"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
//        return;
    }
    self.db = [FMDatabase databaseWithPath:dbPath];
    
    [self.db open];
    
    NSString *createStatement = @"CREATE TABLE IF NOT EXISTS source(indexed integer AUTO_INCREMENT PRIMARY KEY, remote varchar(255), local varchar(255), protocol integer, username varchar(255), password varchar(255));";
    
    BOOL result = [self.db executeUpdate:createStatement];
    
    if (!result) {
        NSLog(@"表创建失败。");
    } else {
        NSLog(@"表创建成功。");
    }
    
    [self.db close];
}

- (void)insertModel:(FXDataSourceModel *)model {
    
    [self.db open];
    
    NSString *statement = @"INSERT INTO source(remote, local, protocol, username, password) VALUES(%@, %@, %ld, %@, %@);";
    
    BOOL result = [self.db executeUpdateWithFormat:statement, model.remoteAddress, model.localAddress, model.protocol, model.username, model.password];
    
    if (!result) {
        NSLog(@"插入数据失败。");
    } else {
        NSLog(@"插入数据成功。");
    }
    
    [self.db close];
}

- (void)deleteModel:(FXDataSourceModel *)model {
    
    [self.db open];
    NSString *statement = @"DELETE FROM source WHERE indexed=%@";
    BOOL result = [self.db executeUpdateWithFormat:statement, model.index];
    
    if (!result) {
        NSLog(@"删除失败。");
    } else {
        NSLog(@"删除成功。");
    }
    
    [self.db close];
}

- (void)updateModel:(FXDataSourceModel *)model {
    
    [self.db open];
    NSString *statement = @"UPDATE source SET remote = %@, local = %@, protocol = %ld, username = %@, password = %@ WHERE indexed = %ld";
    BOOL result = [self.db executeUpdateWithFormat:statement, model.remoteAddress, model.localAddress, model.protocol, model.username, model.password, model.index];
    
    if (!result) {
        NSLog(@"更新失败。");
    } else {
        NSLog(@"更新成功。");
    }
    
    [self.db close];
}

- (NSArray<FXDataSourceModel *> *)queryFromDatabase {
    
    [self.db open];
    NSMutableArray<FXDataSourceModel *> *queryResults = [NSMutableArray array];
    
    NSString *statement = @"SELECT * FROM source;";
    
    FMResultSet *resultSet = [self.db executeQuery:statement];
    
    while (resultSet.next) {
        
        FXDataSourceModel *model = [FXDataSourceModel new];
        model.index = [resultSet intForColumn:@"indexed"];
        model.remoteAddress = [resultSet stringForColumn:@"remote"];
        model.localAddress = [resultSet stringForColumn:@"local"];
        model.protocol = [resultSet intForColumn:@"protocol"];
        model.username = [resultSet stringForColumn:@"username"];
        model.password = [resultSet stringForColumn:@"password"];
        
        [queryResults addObject:model];
    }
    
    [self.db close];
    return [queryResults copy];
}

@end
