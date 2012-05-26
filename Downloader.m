//
//  Downloader.m
//  Which Episode
//
//  Created by Marty Dill on 12-05-26.
//  Copyright (c) 2012 Marty Dill. All rights reserved.
//

#import "Downloader.h"

@interface Downloader()

@property (strong) NSTimer* timer;
@property (strong) NSURLConnection* connection;
@property (strong) NSMutableData* _data;
@property (nonatomic, weak) id delegate;
@property (assign) int _timeout;
@end

@implementation Downloader

@synthesize timer;
@synthesize connection;
@synthesize _data;
@synthesize _timeout;
@synthesize delegate;

-(id)initWithUrl:(NSString *)url timeout:(int)timeout delegate:(id)del
{
    self = [super init];
    if(self)
    {
        self.delegate = del;
        _data = [[NSMutableData alloc] init];
        _timeout = timeout;
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

        connection = [[NSURLConnection alloc] initWithRequest: request delegate:self startImmediately:NO];
        

    }

        
    return self;
}

-(void)start
{    
    timer = [NSTimer scheduledTimerWithTimeInterval:_timeout
                                             target:self
                                           selector:@selector(onTimeExpired)
                                           userInfo:nil
                                            repeats:NO];
    [connection start];
}

// When time expires, cancel the connection
-(void)onTimeExpired
{
    [self.connection cancel];
    [self.delegate didGetResults:nil];
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    // Don't really care...
}


// When we receive data, add it to our collection of data
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [self._data appendData:data];
}


// If the connection fails, cancel the timer and fire the delegate
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    [self.timer invalidate];
    [self.delegate didGetResults: nil];
}


// If the connection has completed, cancel the timer and fire the delegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.timer invalidate];
    [self.delegate didGetResults: _data];
}


@end
