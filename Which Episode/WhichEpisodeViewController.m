//
//  WhichEpisodeViewController.m
//  Which Episode
//
//  Created by Lion User on 12-05-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WhichEpisodeViewController.h"

@interface WhichEpisodeViewController ()

@end

@implementation WhichEpisodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
