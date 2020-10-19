//
//  ShowListTableViewController.h
//  Which Episode
//
//  Created by Lion User on 12-05-19.
//  Copyright (c) 2012 Marty Dill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ShowListTableViewController : UITableViewController

@property (retain) NSMutableArray* shows;
@property (retain) NSArray* sortedShows;
@property (assign) sqlite3* database;

@end
