//
//  Show.h
//  Which Episode
//
//  Created by Marty Dill on 12-05-21.
//  Copyright (c) 2012 Marty Dill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Show : NSObject

@property (retain) NSString* id;
@property (retain) NSString* name;
@property (retain) NSString* imagePath;
@property (assign) int episode;
@property (assign) int season;
@property (assign) bool isNew;

@end
