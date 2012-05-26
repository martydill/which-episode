//
//  Downloader.h
//  Which Episode
//
//  Created by Marty Dill on 12-05-26.
//  Copyright (c) 2012 Marty Dill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Downloader : NSObject

-(id)initWithUrl:(NSString*)url timeout:(int)timeout delegate:(id)del;
-(void)start;

@end


// Definition of the callback 
@interface NSObject (DownloaderCallback)

// Callback method that returns NSData
-(void)didGetResults:(NSData*)data;

@end
