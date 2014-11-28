//
//  AddTableViewController.m
//  watcher
//
//  Created by Alex Wang on 1/31/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "AddTableViewController.h"
#import "SectionDetailsViewController.h"

@interface AddTableViewController ()

@end

@implementation AddTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)populateSubjectList{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/codes/subjects.json?key=%@&term=%@", apiKey,term]];
    NSError *error=nil;
    NSData *JSONData = [NSData dataWithContentsOfURL:url
                                             options:NSDataReadingMappedIfSafe error:&error];
    NSDictionary *results= [NSJSONSerialization
                            JSONObjectWithData:JSONData options: NSJSONReadingAllowFragments error:&error];
    NSArray *data=[results objectForKey:@"data"];
    for ( NSDictionary *sec in data){
        [_subjectList addObject:[sec objectForKey:@"subject"]];
        }
    }

-(void)populateCourseList{
    int i=0;
    for (NSString *sub in _subjectList){
        i++;
        if (i==10){
            break;
        }
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/courses/%@.json?key=%@&term=%@", sub, apiKey, term]];
        NSError *error=nil;
        NSData *JSONData= [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
        NSDictionary *results=[NSJSONSerialization
                              JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
        NSArray *data=[results objectForKey:@"data"];
        for (NSDictionary *cour in data){
            [_courseCatList addObject:[cour objectForKey:@"catalog_number"]];
            [_courseSubList addObject:[cour objectForKey:@"subject"]];
        }
        
    }
}

-(void)populateSectionList{
    for (int i=0;i<10;i++){
        NSString *cat=[_courseCatList objectAtIndex:i];
        NSString *sub=[_courseSubList objectAtIndex:i];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/courses/%@/%@/schedule.json?key=%@&term=%@", sub, cat, unlimitedAPIKey,term]];
        NSError *error=nil;
        NSData *JSONData= [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
        NSDictionary *results=[NSJSONSerialization
                               JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:&error];
        NSArray *data=[results objectForKey:@"data"];
        for (NSMutableDictionary *cour in data){
            [cour setObject:[NSString stringWithFormat:@"%@ %@   %@",[cour objectForKey:@"subject"],[cour objectForKey:@"catalog_number"],[cour objectForKey:@"section"],[cour objectForKey:@"term"]] forKey:@"short_name"];
            [_sectionList addObject:cour];
        }
        
    }
}

-(void)loadApi{
    _subjectList=[[NSMutableArray alloc]init];
    _courseCatList=[[NSMutableArray alloc]init];
    _sectionList=[[NSMutableArray alloc]init];
    _courseSubList=[[NSMutableArray alloc]init];
    [self populateSubjectList];
    [self populateCourseList];
    [self populateSectionList];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadApi];
    
    self.filteredList = [NSMutableArray arrayWithCapacity:_sectionList.count];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _sectionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CourseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell==nil&&tableView!=self.tableView){
        cell=[self.tableView dequeueReusableCellWithIdentifier:@"CourseCell"];
    }
    NSDictionary *section;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        section=[_filteredList objectAtIndex:indexPath.row];
    } else {
        section=[_sectionList objectAtIndex:indexPath.row];
    }
    cell.textLabel.text=[section objectForKey:@"short_name"];
    
    return cell;
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.filteredList removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.short_name contains[c] "];
    self.filteredList=[NSMutableArray arrayWithArray:[self.sectionList filteredArrayUsingPredicate:predicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
     return YES;
}

@end
