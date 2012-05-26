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

- (IBAction)seasonMinusTouch:(id)sender;

- (IBAction)episodeMinusTouch:(id)sender;

@property (strong) Show* show;
@property (weak, nonatomic) IBOutlet UITextField *showNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *seasonTextField;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;
@property (weak, nonatomic) IBOutlet UITextField *episodeTextField;
@property (assign) sqlite3* database;
@property (nonatomic, retain) NSMutableArray* shows;

- (IBAction)episodePlusTouch:(id)sender;
- (IBAction)seasonPlusTouch:(id)sender;
@property (strong) NSURLConnection* connection;
@property (strong) NSTimer* timer;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@end
