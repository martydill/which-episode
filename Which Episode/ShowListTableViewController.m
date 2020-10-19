//
//  ShowListTableViewController.m
//  Which Episode
//
//  Created by Lion User on 12-05-19.
//  Copyright (c) 2012 Marty Dill. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>

#import "ShowListTableViewController.h"
#import "ShowDetailsViewController.h"
#import "DataLoader.h"
#import "DataSaver.h"
#import "WhichEpisodeAppDelegate.h"

static NSString* const EmailButtonTitle = @"Email Show List";
static NSString* const SortNewestFirst = @"Sort Newest First";
static NSString* const SortOldestFirst = @"Sort Oldest First";
static NSString* const SortAToZ = @"Sort A - Z";
static NSString* const SortZToA = @"Sort Z - A";

@interface ShowListTableViewController ()

-(void)addButtonPressed;

@end

@implementation ShowListTableViewController

@synthesize sortedShows;
@synthesize shows;
@synthesize database;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)addButtonPressed
{
    ShowDetailsViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowDetails"];
    controller.database = self.database;
    Show* show = [[Show alloc]  init];
    [self.shows addObject:show];
    controller.show = show;
    [self.navigationController pushViewController:controller animated:YES];
}

UIColor* alternateRowBackground;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    alternateRowBackground = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    
    WhichEpisodeAppDelegate* del = [[UIApplication sharedApplication] delegate];
    self.database = del.database;

    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];

    self.navigationItem.rightBarButtonItem = anotherButton;
    
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:@"Actions" style:UIBarButtonSystemItemAdd target:self action:@selector(onActionsTouch)];
    [self.navigationItem setLeftBarButtonItem:button];

    [self setSort:[self getSort]];
}

const int Sort_OldestFirst = 0;
const int Sort_NewestFirst = 1;
const int Sort_AtoZ = 2;
const int Sort_ZtoA = 3;

-(void)setSort:(int)sort
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:sort forKey:@"sort"];

    @synchronized(self)
    {
        DataLoader* loader = [[DataLoader alloc] init];
        self.shows = [loader loadRecordsFromDatabase:database];
    }
    
    //NSArray* shows;
    if(sort == Sort_OldestFirst)
    {
        self.sortedShows = [NSArray arrayWithArray:self.shows];
    }
    else if(sort == Sort_NewestFirst)
    {
        self.sortedShows = [[self.shows reverseObjectEnumerator] allObjects];
    }
    else if(sort == Sort_ZtoA)
    {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)];
        self.sortedShows = [self.shows sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    else if(sort == Sort_AtoZ)
    {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];

        self.sortedShows = [self.shows sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    }

    [self.tableView reloadData];
}

-(int)getSort
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int sort = [defaults integerForKey:@"sort"];
    return sort;
}

-(void) onActionsTouch
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"What Do You Want To Do?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil otherButtonTitles:SortAToZ, SortZToA, SortNewestFirst, SortOldestFirst, EmailButtonTitle, nil];
    
    [sheet showFromBarButtonItem:self.navigationItem.leftBarButtonItem animated:true];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == -1 || buttonIndex == actionSheet.cancelButtonIndex)
        return;
    
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:EmailButtonTitle])
    {
        [self email];
    }
    else if([title isEqualToString:SortAToZ])
    {
        [self setSort:Sort_AtoZ];
    }
    else if([title isEqualToString:SortZToA])
    {
        [self setSort:Sort_ZtoA];
    }
    else if([title isEqualToString:SortOldestFirst])
    {
        [self setSort:Sort_OldestFirst];
    }
    else if([title isEqualToString:SortNewestFirst])
    {
        [self setSort:Sort_NewestFirst];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setSort:[self getSort]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath* selectedPath = [self.tableView indexPathForSelectedRow];
    Show* show = [self.sortedShows objectAtIndex:selectedPath.row];
    ShowDetailsViewController* detailsVC = (ShowDetailsViewController*)[segue destinationViewController];
    
    detailsVC.show = show;
}


-(void) tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    UIColor* color = indexPath.row % 2 == 0 ? [UIColor whiteColor] : alternateRowBackground;
    cell.backgroundColor = color;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        return 44.0;
    else
        return 96.0 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sortedShows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShowCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
    
    }
    
    Show* show = [self.sortedShows objectAtIndex:indexPath.row];
    if(show.name != nil && show.name.length > 0)
        cell.textLabel.text = show.name;
    else
        cell.textLabel.text = @"[No Name]";
    NSString* whereLabel = [NSString stringWithFormat:@"Season %d Episode %d", show.season, show.episode];
    cell.detailTextLabel.text = whereLabel;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        cell.imageView.image = show.image;
    }
    
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        int row = indexPath.row;
        Show* show = [self.sortedShows objectAtIndex:row];
        
        @synchronized(self)
        {
            DataSaver* saver = [[DataSaver alloc] init];
            [saver deleteRecord:show fromDatabase:database];
        }
        
        [self.shows removeObject:show];
        [self setSort:[self getSort]];
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Show* show = [self.sortedShows objectAtIndex:indexPath.row];
    
    ShowDetailsViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowDetails"];
    controller.lock = self;
    controller.database = self.database;
    controller.show = show;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)email
{
    if ([MFMailComposeViewController canSendMail])
    {
        NSString* subject = [NSString stringWithFormat:@"Which Episode - Show List"];
        
        NSMutableString* message = [[NSMutableString alloc] init];
        
        for(Show* show in self.sortedShows)
        {
            [message appendFormat:@"%@ - Season %d Episode %d\n", show.name, show.season, show.episode ];
        }
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:subject];
        [controller setMessageBody:message isHTML:FALSE];
        if (controller) [self presentModalViewController:controller animated:YES];
    }
    else
    {
        NSLog(@"Can't send email");
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
