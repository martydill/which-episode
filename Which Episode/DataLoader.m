//
//  DataLoader.m
//  BBQ Menu
//
//  Created by marty on 12-01-29.
//  Copyright (c) 2012 Marty Dill. All rights reserved.
//

#import "DataLoader.h"
#import "Show.h"

@implementation DataLoader


-(NSMutableArray*) loadRecordsFromDatabase:(sqlite3*) database
{
    NSMutableArray* allTableData = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT id, name, imagePath, season, episode from shows"];

    sqlite3_stmt *statement = nil;
   if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
   {
       while (sqlite3_step(statement) == SQLITE_ROW)
       {
           char* key = (char*)sqlite3_column_text(statement, 0);
           char *nameChars = (char*) sqlite3_column_text(statement, 1);
           char *imagePathChars = (char*) sqlite3_column_text(statement, 2);
           int season = sqlite3_column_int(statement, 3);
           int episode = sqlite3_column_int(statement, 4);
                   
           NSString* keyString = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
           NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
           NSString *imagePath = [[NSString alloc] initWithUTF8String:imagePathChars];
              	       
           Show* show = [[Show alloc] init];
           show.name = name;
           show.id = keyString;
           show.season = season;    
           show.episode = episode;
           show.imagePath = imagePath;
           show.isNew = false;
           if([show.imagePath hasSuffix:@".png"])
           {
               NSFileManager* manager = [[NSFileManager alloc] init];
               if([manager fileExistsAtPath:show.imagePath])
               {
                   NSData* data = [NSData dataWithContentsOfFile:show.imagePath];
                   UIImage* image = [UIImage imageWithData:data];
                   show.image = image;
               }
               else
               {
                   NSString* fileName = [show.imagePath lastPathComponent];
                   NSString* fixedPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"]stringByAppendingPathComponent:fileName];
                   
                   if([manager fileExistsAtPath:fixedPath])
                   {
                       show.imagePath = fixedPath;
                       
                       NSData* data = [NSData dataWithContentsOfFile:show.imagePath];
                       UIImage* image = [UIImage imageWithData:data];
                       show.image = image;
                   }
               }
           }
           
           [allTableData addObject:show];
       }
       sqlite3_finalize(statement);
   }
    
    return allTableData;
}



@end
