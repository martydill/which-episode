//
//  ShowDetailsViewController.m
//  Which Episode
//
//  Created by Marty Dill on 12-05-21.
//  Copyright (c) 2012 Marty Dill. All rights reserved.
//

#import "ShowDetailsViewController.h"
#import "Show.h"
#import "DataSaver.h"
#import <QuartzCore/QuartzCore.h>

@interface ShowDetailsViewController ()

@end

@implementation ShowDetailsViewController
@synthesize showImageView;

@synthesize show;
@synthesize showNameLabel;
@synthesize seasonTextField;
@synthesize loadingLabel;
@synthesize loadingSpinner;
@synthesize episodeTextField;
@synthesize database;
@synthesize shows;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)blah:(id)target
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    showNameLabel.delegate = self;
    [showImageView.layer setCornerRadius:6];
    [showImageView.layer setMasksToBounds:TRUE];
}

- (void)viewDidUnload
{
    [self setShowNameLabel:nil];
    [self setSeasonTextField:nil];
    [self setEpisodeTextField:nil];
    [self setShowImageView:nil];
    [self setLoadingLabel:nil];
    [self setLoadingSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [showNameLabel resignFirstResponder];
    
    if(showNameLabel.text.length > 0)
    {
        loadingLabel.hidden = false;
        loadingSpinner.hidden = false;
        [loadingSpinner startAnimating];
        showImageView.hidden = true;
        
    NSString* url = [NSString stringWithFormat:@"http://www.imdbapi.com/?t=%@", showNameLabel.text];
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: 
                        [NSURL URLWithString:url]];
        [self performSelectorOnMainThread:@selector(fetchedData:) 
                               withObject:data waitUntilDone:YES];
    });
    
    }
    
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateSeasonAndEpisode
{
    seasonTextField.text = [NSString stringWithFormat:@"%d", show.season];
    episodeTextField.text = [NSString stringWithFormat:@"%d", show.episode];
}

-(void)viewWillAppear:(BOOL)animated
{
    showNameLabel.text = show.name;
    [self updateSeasonAndEpisode];
    
    if(show.imagePath.length > 0)
    {
        NSData* data = [NSData dataWithContentsOfFile:show.imagePath];
        UIImage* image = [UIImage imageWithData:data];
        showImageView.image = image;
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    show.name = showNameLabel.text;
    show.season = [seasonTextField.text intValue];
    show.episode = [episodeTextField.text intValue];
    
    DataSaver* saver = [[DataSaver alloc] init];
    
    [saver saveRecord:show toDatabase:database];
}

- (IBAction)seasonMinusTouch:(id)sender
{
    if(show.season > 1)
    {
        show.season = show.season - 1;
        [self updateSeasonAndEpisode];
    }
}
- (IBAction)episodeMinusTouch:(id)sender
{
    if(show.episode > 1)
    {
        show.episode = show.episode - 1;
        [self updateSeasonAndEpisode];
    }
}
- (IBAction)episodePlusTouch:(id)sender
{
    show.episode = show.episode + 1;
    [self updateSeasonAndEpisode];
}

- (IBAction)seasonPlusTouch:(id)sender
{
    show.season = show.season + 1;
    [self updateSeasonAndEpisode];
}

NSMutableData* allData;

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);  
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name]; 
}

-(void)fetchedData:(NSData *)responseData {
//parse out the json data
NSError* error;
NSDictionary* json = [NSJSONSerialization 
                      JSONObjectWithData:responseData //1
                      
                      options:kNilOptions 
                      error:&error];

NSString* poster  = [json objectForKey:@"Poster"]; //2

NSLog(@"loans: %@", poster); //3
    
    
    NSString* httpGetUrl = poster;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:httpGetUrl]];
    allData = [[NSMutableData alloc] init];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest: request delegate: self startImmediately:YES];
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    // Don't really care...
}


// When we receive data, add it to our collection of data
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [allData appendData:data];
}


// If the connection fails, cancel the timer and fire the delegate
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
  //  [self.timer invalidate];

}


// If the connection has completed, cancel the timer and fire the delegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage* image = [[UIImage alloc] initWithData:allData];
    self.showImageView.image = image;
    
    NSData *pngData = UIImagePNGRepresentation(image);
    NSString* filename = [NSString stringWithFormat:@"%@.png", show.id];
    NSString* path = [self documentsPathForFileName:filename];
    show.imagePath = path;
    DLog(@"Saved image path: %@", path);
    [pngData writeToFile:path atomically:YES];
    
    loadingLabel.hidden = true;
    loadingSpinner.hidden = true;
    showImageView.hidden = false;
}

@end
