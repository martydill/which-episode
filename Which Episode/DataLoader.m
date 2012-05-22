//
//  DataLoader.m
//  BBQ Menu
//
//  Created by marty on 12-01-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataLoader.h"
#import "Show.h"

@implementation DataLoader


-(NSMutableArray*) loadRecordsFromDatabase:(sqlite3*) database
{
    NSMutableArray* allTableData = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT id, name, description, priority, iscompleted, isnote,"
                       "createddate, duedate, completeddate, imagepath, imagethumbnailpath from todo_entries"];

   sqlite3_stmt *statement;
   if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
   {
       while (sqlite3_step(statement) == SQLITE_ROW)
       {
           char* key = (char*)sqlite3_column_text(statement, 0);
           char *nameChars = (char*) sqlite3_column_text(statement, 1);
           char *descriptionChars = (char*) sqlite3_column_text(statement, 2);
           int priority = sqlite3_column_int(statement, 3);
           int isCompleted = sqlite3_column_int(statement, 4);
           int isNote = sqlite3_column_int(statement, 5);
           
           double createdDateDouble = sqlite3_column_double(statement, 6);
           double dueDateDouble = sqlite3_column_double(statement, 7);
           double completedDateDouble = sqlite3_column_double(statement, 8);
           
           char* imagePathChars = (char*)sqlite3_column_text(statement, 9);
           char* imageThumbnailPathChars = (char*)sqlite3_column_text(statement, 10);
           
           NSString* keyString = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
           NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
           NSString *description = [[NSString alloc] initWithUTF8String:descriptionChars];
                     
           ToDoEntry* entry = [[ToDoEntry alloc] init];
           entry.name = name;
           entry.description = description;
           entry.key = keyString;
           entry.priority = priority;
           entry.isCompleted = isCompleted;
           entry.isNote = isNote;
           entry.imagePath = [NSString stringWithCString:imagePathChars encoding:NSUTF8StringEncoding];
           entry.imageThumbnailPath = [NSString stringWithCString:imageThumbnailPathChars encoding:NSUTF8StringEncoding];
           entry.createdDate = [NSDate dateWithTimeIntervalSince1970: createdDateDouble];
           entry.dueDate = [NSDate dateWithTimeIntervalSince1970:dueDateDouble];
           entry.completedDate = [NSDate dateWithTimeIntervalSince1970:completedDateDouble];
           
          if(entry.imageThumbnailPath != Nil)
          {
               DLog(@"Loading image thumbnail from %@", entry.imageThumbnailPath);
               entry.imageThumbnail = [UIImage imageWithContentsOfFile:entry.imageThumbnailPath];
          }    
               
           [allTableData addObject:entry];
       }
       sqlite3_finalize(statement);
   }
    
    return allTableData;
}



@end
