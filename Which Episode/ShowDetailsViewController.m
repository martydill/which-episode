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
#import "Downloader.h"

//#define BASE_SEARCH_URL @"http://www.imdbapi.com/?t=%@"
#define BASE_SEARCH_URL @"http://api.trakt.tv/search/shows.json/6ad61602068d0193f1b2d46cd40109c5/"

@interface ShowDetailsViewController ()
@property (strong) Downloader* downloader;
@end

@implementation ShowDetailsViewController
@synthesize downloader;
@synthesize showImageView;
@synthesize timer;
@synthesize connection;
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
    
    [showImageView.layer setMasksToBounds:true];
    [showImageView.layer setCornerRadius:30.0f];
    [showImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [showImageView.layer setBorderWidth:1.5f];
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

bool isDownloadingShowInfo = false;

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [showNameLabel resignFirstResponder];
    
    if(![theTextField.text isEqualToString:show.name])
    {
        if(show.name != nil && show.name.length > 0)
        {
            showImageView.image = nil;
            show.image = nil;
            NSFileManager* manager = [[NSFileManager alloc] init];
            if([manager fileExistsAtPath:show.imagePath])
            {
                [manager removeItemAtPath:show.imagePath error:nil];
            }
            
            show.imagePath = @"";
        }
    
        show.name = showNameLabel.text;
        
        if(showNameLabel.text.length > 0)
        {
            loadingLabel.text = @"Loading Image";
            loadingLabel.hidden = false;
            loadingSpinner.hidden = false;
            [loadingSpinner startAnimating];
        
            NSString* url = [NSString stringWithFormat:@"%@%@", BASE_SEARCH_URL, showNameLabel.text];
            url = [url stringByReplacingOccurrencesOfString:@" " withString:@"+"];

            isDownloadingShowInfo = true;
            downloader = [[Downloader alloc] initWithUrl:url timeout:10 delegate:self];
            [downloader start];
        }
    }
    return YES;
}

-(void)didGetResults:(NSData *)data
{
    self.downloader = nil;
    
    if(data == nil)
    {
        [self showImageDownloadError];
    }
    else if(isDownloadingShowInfo)
    {
        [self handleShowInfoDownloaded:data];
    }
    else 
    {
        [self handleImageInfoDownloaded:data];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidAppear:(BOOL)animated
{
        
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
    
    if(show.image != nil)
    {
        showImageView.image = show.image;
    }
    else
    {
        loadingLabel.hidden = false;
        loadingLabel.text = @"No Image";
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

-(void)showImageDownloadError
{
    loadingLabel.hidden = false;
    loadingLabel.text = @"Download Failed";
    loadingSpinner.hidden = true;
}


- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);  
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"] stringByAppendingPathComponent:name];
}

-(NSString*)getPosterUrlFromJson:(id)json
{
    if([json isKindOfClass:[NSArray class]])
    {
        for(NSDictionary* dict in json)
        {
            NSDictionary* images = [dict valueForKey:@"images"];
            NSString* poster = [images valueForKey:@"poster"];
            return poster;
        }
    }
    
    return nil;
}

-(void)handleShowInfoDownloaded:(NSData *)data
{
    NSError* error;
    id json = [NSJSONSerialization JSONObjectWithData:data                    
                                                        options:kNilOptions 
                                                    error:&error];
    
    NSString* poster  = [self getPosterUrlFromJson:json];//[json objectForKey:@"Poster"];

    if(poster != nil)
    {    
        isDownloadingShowInfo = false;
        downloader = [[Downloader alloc] initWithUrl:poster timeout:10 delegate:self];
        [downloader start];
    }
    else 
    {
        [self showImageDownloadError];
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

// Image scaling code from http://stackoverflow.com/a/9575252/184630
- (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height
{
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor;
    
    if (oldWidth > oldHeight) {
        scaleFactor = width / oldWidth;
    } else {
        scaleFactor = height / oldHeight;
    }
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self imageWithImage:image scaledToSize:newSize];
}


- (void)handleImageInfoDownloaded:(NSData*)data
{
    UIImage* bigImage = [[UIImage alloc] initWithData:data];
    UIImage* image;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        image = [self imageWithImage:bigImage scaledToMaxWidth:190 * 2 maxHeight:180 * 2];
    else
        image = [self imageWithImage:bigImage scaledToMaxWidth:190 * 4 maxHeight:180 * 4];
    
    self.showImageView.image = image;
    self.show.image = image;
    
    NSData *pngData = UIImagePNGRepresentation(image);
    NSString* filename = [NSString stringWithFormat:@"%@.png", show.id];
    NSString* path = [self documentsPathForFileName:filename];
    show.imagePath = path;
    
    [pngData writeToFile:path atomically:YES];
    
    loadingLabel.hidden = true;
    loadingSpinner.hidden = true;
}


@end
