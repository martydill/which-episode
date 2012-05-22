//
//  ShowDetailsViewController.h
//  Which Episode
//
//  Created by Marty Dill on 12-05-21.
//  Copyright (c) 2012 Marty Dill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Show.h"
#import <sqlite3.h>

@interface ShowDetailsViewController : UIViewController

@property (strong) Show* show;
@property (weak, nonatomic) IBOutlet UITextField *showNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *seasonTextField;
@property (weak, nonatomic) IBOutlet UITextField *episodeTextField;
@property (assign) sqlite3* database;
@property (nonatomic, retain) NSMutableArray* shows;

@end
