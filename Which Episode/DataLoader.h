//
//  DataLoader.h
//  BBQ Menu
//
//  Created by marty on 12-01-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataLoader : NSObject

-(NSMutableArray*) loadRecordsFromDatabase:(sqlite3*) database;

@end
