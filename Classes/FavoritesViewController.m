//
//  FavoritesViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 01/26/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavTimeViewCell.h"
#import "StopTime.h"
#import "StopTimeViewController.h"
#import "Favorite.h"
#import "Line.h"
#import "Stop.h"

@implementation FavoritesViewController

@synthesize fetchedResultsController = fetchedResultsController_;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = NSLocalizedString( @"Favoris", @"" );
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellFav";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [FavTimeViewCell cellFromNibNamed:@"FavTimeViewCell"];
    }
    
    // Configure the cell...
    Favorite* fav = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [(FavTimeViewCell*)cell displayFavorite:fav withTimes:[StopTime findComingAt:fav]];
    
    return cell;
}


- (NSFetchedResultsController*) fetchedResultsController {
    if (nil != fetchedResultsController_) {
        return fetchedResultsController_;
    }
    fetchedResultsController_ = [Favorite findAll];
    [fetchedResultsController_ retain];
    return fetchedResultsController_;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Favorite* fav = [self.fetchedResultsController objectAtIndexPath:indexPath];
    StopTimeViewController* stoptimeView = [[StopTimeViewController alloc] initWithNibName:@"StopTimeViewController" bundle:nil];
    stoptimeView.line = [Line findFirstBySrcId:fav.line_id];
    stoptimeView.stop = [Stop findFirstBySrcId:fav.stop_id];
    [self.navigationController pushViewController:stoptimeView animated:YES];
    [stoptimeView release];         
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

