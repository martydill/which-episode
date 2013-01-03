//
//  ShowListTableViewController.m
//  Which Episode
//
//  Created by Lion User on 12-05-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>

#import "ShowListTableViewController.h"
#import "ShowDetailsViewController.h"
#import "DataLoader.h"
#import "DataSaver.h"
#import "WhichEpisodeAppDelegate.h"

static NSString* const EmailButtonTitle = @"Email Show List";

@interface ShowListTableViewController ()

-(void)addButtonPressed;

@end

@implementation ShowListTableViewController

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    WhichEpisodeAppDelegate* del = [[UIApplication sharedApplication] delegate];
    self.database = del.database;
    
    DataLoader* loader = [[DataLoader alloc] init];
    self.shows = [loader loadRecordsFromDatabase:database];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];

    self.navigationItem.rightBarButtonItem = anotherButton;
    
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:@"Actions" style:UIBarButtonSystemItemAdd target:self action:@selector(onActionsTouch)];
    [self.navigationItem setLeftBarButtonItem:button];
}


-(void) onActionsTouch
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"What Do You Want To Do?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil otherButtonTitles:EmailButtonTitle, nil];
    
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath* selectedPath = [self.tableView indexPathForSelectedRow];
    Show* show = [self.shows objectAtIndex:selectedPath.row];
    ShowDetailsViewController* detailsVC = (ShowDetailsViewController*)[segue destinationViewController];
    
    detailsVC.show = show;
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

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    Show* show = [self.shows objectAtIndex:indexPath.row];
    
    ShowDetailsViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowDetails"];
    controller.database = self.database;
    controller.show = show;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShowCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
    
    }
    
    Show* show = [self.shows objectAtIndex:indexPath.row];
    if(show.name != nil && show.name.length > 0)
        cell.textLabel.text = show.name;
    else
        cell.textLabel.text = @"[No Name]";
    NSString* whereLabel = [NSString stringWithFormat:@"Season %d Episode %d", show.season, show.episode];
    cell.detailTextLabel.text = whereLabel;
        
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        int row = indexPath.row;
        Show* show = [self.shows objectAtIndex:row];
        DataSaver* saver = [[DataSaver alloc] init];
        [saver deleteRecord:show fromDatabase:database];
        [self.shows removeObjectAtIndex:row];
        [self.tableView reloadData];
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
   
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)email
{
    if ([MFMailComposeViewController canSendMail])
    {
        NSString* subject = [NSString stringWithFormat:@"Which Episode - Show List"];
        
        NSMutableString* message = [[NSMutableString alloc] init];
        
        for(Show* show in self.shows)
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
