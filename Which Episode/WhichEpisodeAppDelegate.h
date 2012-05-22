//
//  WhichEpisodeAppDelegate.h
//  Which Episode
//
//  Created by Lion User on 12-05-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface WhichEpisodeAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) sqlite3* database;

@end
