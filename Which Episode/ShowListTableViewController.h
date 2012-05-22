//
//  ShowListTableViewController.h
//  Which Episode
//
//  Created by Lion User on 12-05-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ShowListTableViewController : UITableViewController

@property (retain) NSMutableArray* shows;
@property (assign) sqlite3* database;

@end
