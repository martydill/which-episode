//
//  Show.m
//  Which Episode
//
//  Created by Marty Dill on 12-05-21.
//  Copyright (c) 2012 Marty Dill. All rights reserved.
//

#import "Show.h"

@implementation Show

@synthesize id;
@synthesize name;
@synthesize episode;
@synthesize imagePath;
@synthesize season;
@synthesize isNew;

-(id)init
{
    if(self = [super init])
    {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        
        // create a new CFStringRef (toll-free bridged to NSString)
        // that you own
        NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
        CFRelease(uuid);
        self.id = uuidString;
        self.season = 1;
        self.episode = 1;
        self.isNew = true;
        self.imagePath = @"";
    }
    
    return self;
}

@end
