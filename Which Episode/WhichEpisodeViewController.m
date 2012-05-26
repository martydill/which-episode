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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
