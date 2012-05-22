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

@interface ShowDetailsViewController ()

@end

@implementation ShowDetailsViewController

@synthesize show;
@synthesize showNameLabel;
@synthesize seasonTextField;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    showNameLabel.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setShowNameLabel:nil];
    [self setSeasonTextField:nil];
    [self setEpisodeTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [showNameLabel resignFirstResponder];
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

@end
