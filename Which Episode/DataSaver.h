//
//  DataSaver.h
//  BBQ Menu
//
//  Created by marty on 12-01-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Show.h"

@interface DataSaver : NSObject

-(void) saveRecord:(Show*)record toDatabase:(sqlite3*)database;

-(void) deleteRecord:(Show*)record fromDatabase:(sqlite3*)database;

@end
