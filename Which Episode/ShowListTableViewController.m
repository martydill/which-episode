//
//  ShowListTableViewController.m
//  Which Episode
//
//  Created by Lion User on 12-05-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowListTableViewController.h"
#import "ShowDetailsViewController.h"
#import "DataLoader.h"
#import "DataSaver.h"
#import "WhichEpisodeAppDelegate.h"

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
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
    cell.textLabel.text = show.name;
    NSString* whereLabel = [NSString stringWithFormat:@"Season %d Episode %d", show.season, show.episode];
    cell.detailTextLabel.text = whereLabel;
        
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


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

@end
