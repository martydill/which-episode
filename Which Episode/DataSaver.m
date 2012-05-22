//
//  DataSaver.m
//  BBQ Menu
//
//  Created by marty on 12-01-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataSaver.h"
#import "Show.h"

@implementation DataSaver


-(void) saveRecord:(Show*)record toDatabase:(sqlite3*)database
{
    sqlite3_stmt    *statement;
       
    NSString* sql;
    if(record.isNew)
    {
        sql = [NSString stringWithFormat:
               @"INSERT INTO shows "
               "(id, name, imagePath, season, episode) "
               "VALUES (?,?,?,?,?)"];
        
        if(sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK)
        {
            DLog(@"Failed to prepare statement %@", sql);
        }
        
        if(sqlite3_bind_text(statement, 1, [record.id UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            DLog(@"Failed to bind parameter id");
        }
        if(sqlite3_bind_text(statement, 2, [record.name UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            DLog(@"Failed to bind parameter name");
        }
        if(sqlite3_bind_text(statement, 3, [record.imagePath UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            DLog(@"Failed to bind parameter imagePath");
        }
        if(sqlite3_bind_int(statement, 4, record.season) != SQLITE_OK)
        {
            DLog(@"Failed to bind parameter season");
        }
        if(sqlite3_bind_int(statement, 5, record.episode) != SQLITE_OK)
        {
            DLog(@"Failed to bind parameter episode");
        }
     
        record.isNew = false;
    }
    else
    {
        sql = [NSString stringWithFormat:
               @"UPDATE shows "
               "set name = ?, imagePath = ?, season = ?, episode = ? "
               "WHERE id = ?"];
        
        if(sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK)
        {
            DLog(@"Failed to prepare statement %@", sql);
        }
        
        if(sqlite3_bind_text(statement, 1, [record.name UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            DLog(@"Failed to bind parameter name");
        }
        if(sqlite3_bind_text(statement, 2, [record.imagePath UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            DLog(@"Failed to bind parameter imagePath");
        }
        if(sqlite3_bind_int(statement, 3, record.season) != SQLITE_OK)
        {
            DLog(@"Failed to bind parameter season");
        }
        if(sqlite3_bind_int(statement, 4, record.episode) != SQLITE_OK)
        {
            DLog(@"Failed to bind parameter episode");
        }
    }
    
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        DLog(@"Inserted");
    }
    else
    {
        const char* errorMessage = sqlite3_errmsg(database);
        NSString* str = [[NSString alloc] initWithCString:errorMessage encoding:NSASCIIStringEncoding];
        
        DLog(@"Insert failed: %@", str);
    }
    
    sqlite3_finalize(statement);
}



-(void) deleteRecord:(Show*)record fromDatabase:(sqlite3 *)database
{
    if(record.imagePath != nil)
    {
//        NSFileManager* manager = [[NSFileManager alloc] init];
//        if([manager fileExistsAtPath:record.imagePath])
//        {
//            DLog(@"Deleting image file %@", record.imagePath);
//            [manager removeItemAtPath:record.imagePath error:nil];
//        }
//        if([manager fileExistsAtPath:record.imageThumbnailPath])
//        {
//            DLog(@"Deleting image thumbnail file %@", record.imageThumbnailPath);
//            [manager removeItemAtPath:record.imageThumbnailPath error:nil];
//        }
    }
    
    if(!record.isNew)
    {
        NSString* sql = @"DELETE FROM shows WHERE id = ?";
        sqlite3_stmt* statement = nil;
        if(sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK)
        {
            DLog(@"Failed to prepare statement %@", sql);
        }
        const char* c = [record.id UTF8String];
        if(sqlite3_bind_text(statement, 1, c, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            DLog(@"Failed to bind parameter");
        }
        
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            DLog(@"Delete successful");
        }
        else
        {
            DLog(@"Delete failed");
        }
    }
}

@end
