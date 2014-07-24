//
//  TableViewController.m
//  watcher
//
//  Created by Alex Wang on 1/31/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "TableViewController.h"
#import "AddNewCourseViewController.h"
#import "SectionDetailsViewController.h"
#import "AppDelegate.h"

@interface TableViewController ()
@end

@implementation TableViewController

@synthesize fullLabel=_fullLabel;
@synthesize scrollView;
@synthesize pageControl;
@synthesize view1;
@synthesize view2;
@synthesize pageControlBeingUsed = _pageControlBeingUsed;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate=((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    if (appDelegate.shortList){
        _watchList=[self generateWatchList:appDelegate.shortList];
    } else {
        _watchList=[[NSMutableArray alloc]init];
    }
    _subjectList=[[NSMutableArray alloc]init];
    [self loadSubList];
    self.navigationItem.rightBarButtonItem=self.addButton;
    self.navigationItem.leftBarButtonItem=self.editButtonItem;
    _setting=[Setting sharedInstance];
    self.view.backgroundColor=[UIColor clearColor];
    self.navigationController.navigationBar.translucent=NO;
    
    self.pageControlBeingUsed = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[_setting.settings objectForKey:@"backgroundImage"]]];
    //self.view.backgroundColor= [UIColor clearColor];
    //self.view.alpha = 0.2f;
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
    return _watchList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    
    //add scroll view and page control on each cell
    scrollView = [[UIScrollView alloc] initWithFrame:cell.bounds];
    [scrollView setPagingEnabled:YES];
    [scrollView setBackgroundColor:NO];
    [scrollView setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
    [scrollView setShowsHorizontalScrollIndicator:YES];
    [scrollView setBounces:YES];
    [scrollView setScrollEnabled:YES];
    [scrollView setDelegate:self];
    [cell.contentView addSubview:scrollView];
    pageControl = [[UIPageControl alloc] initWithFrame:cell.bounds];
    [pageControl setNumberOfPages:4];
    [pageControl setBackgroundColor:NO];
    [cell.contentView addSubview:pageControl];

    view1 = [[UIView alloc] init];
    view2 = [[UIView alloc] init];
    
    
    
    UILabel *label1 = [[UILabel alloc] init];
    [label1 setTextColor:[UIColor blackColor]];
    [label1 setBackgroundColor:[UIColor blackColor]];
    [label1 setFont:[UIFont fontWithName:@"Helen" size:30.0f]];
    [view1 addSubview:label1];
    
    [scrollView addSubview:view1];
    [scrollView addSubview:view2];
    
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@ %@    %@",[[_watchList objectAtIndex:indexPath.row] objectForKey:@"subject"],[[_watchList objectAtIndex:indexPath.row] objectForKey:@"catalog_number"],[[_watchList objectAtIndex:indexPath.row] objectForKey:@"section"]];
    if ([self isFullForSectionNumber:indexPath.row]){
        cell.detailTextLabel.text=@"FULL";
        cell.detailTextLabel.textColor=[UIColor redColor];
    } else {
        cell.detailTextLabel.text=@"";
    }
    return cell;
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    self.pageControlBeingUsed = YES;
}

//fix flashing
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pageControlBeingUsed = NO;
}
//fix flashing
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControlBeingUsed = NO;
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    pageControl.currentPage=page;
}

-(IBAction)clickPageControl:(id)sender
{
    int page=pageControl.currentPage;
    CGRect frame=scrollView.frame;
    frame.origin.x=frame.size.width=page;
    frame.origin.y=0;
    [scrollView scrollRectToVisible:frame animated:YES];
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_watchList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (editing==NO){
        _addButton.enabled=YES;
    } else {
        _addButton.enabled=NO;
    }
}



-(void)loadSubList{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/codes/subjects.json?key=%@&term=1145", apiKey]];
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

-(NSDictionary *)loadSectionForSubject:(NSString *)subject Number:(NSString *)number Section:(NSString *)section{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/courses/%@/%@/schedule.json?key=%@&term=1145", subject, number, apiKey]];
    //for debugging
    //NSURL *url=[NSURL fileURLWithPath:[NSString stringWithFormat:@"/Users/alexwang/Documents/ClassWatcher/testjson/%@/%@/schedule.json",subject,number]];
    //
    NSError *error=nil;
    NSData *JSONData= [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    NSDictionary *results=[NSJSONSerialization
                           JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:&error];
    NSArray *sectionList=[results objectForKey:@"data"];
    int i;
    for (i=0;i<sectionList.count;i++){
        if ([[[sectionList objectAtIndex:i] objectForKey:@"section"] isEqualToString:section]){
            break;
        }
    }
    return [sectionList objectAtIndex:i];
    
}

-(BOOL)refreshWatchList{
    BOOL flag=NO;
    _changedList=[[NSMutableArray alloc] init];
    for (int i=0;i<_watchList.count;i++){
        BOOL fullBefore=[self isFullForSectionNumber:i];
        NSDictionary *section=[_watchList objectAtIndex:i];
        [_watchList replaceObjectAtIndex:i withObject:[self loadSectionForSubject:[section objectForKey:@"subject"] Number:[section objectForKey:@"catalog_number"] Section:[section objectForKey:@"section"]]];
        if ((fullBefore)&&(![self isFullForSectionNumber:i])){
            [_changedList addObject:[NSString stringWithFormat:@"%@ %@  %@",[section objectForKey:@"subject"],[section objectForKey:@"catalog_number"],[section objectForKey:@"section"]]];
            flag=YES;
        }
    }
    [self.tableView reloadData];
    return flag;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"addCourse"]){
        AddNewCourseViewController *dest=[segue destinationViewController];
        dest.subjectList=_subjectList;
        dest.parent=self;
    } else if ([segue.identifier isEqualToString:@"watchDetail"]){
        SectionDetailsViewController *dest=[segue destinationViewController];
        NSIndexPath *path=[self.tableView indexPathForSelectedRow];
        dest.info=[_watchList objectAtIndex:path.row];
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

-(void)addSection:(NSDictionary *)section{
    [_watchList insertObject:section atIndex:0];
    [self.tableView reloadData];
}

-(BOOL)isFullForSectionNumber:(NSInteger)number{
    NSDictionary *section=[_watchList objectAtIndex:number];
    if ([[section objectForKey:@"enrollment_capacity"] intValue] <=[[section objectForKey:@"enrollment_total"] intValue]){
        return YES;
    }
    return NO;
}

/*interclass API method*/
-(NSMutableArray* )generateShortList{
    NSMutableArray *shortList=[[NSMutableArray alloc] init];
    for (NSDictionary *sec in _watchList){
        NSMutableDictionary *shortDescription=[[NSMutableDictionary alloc]init];
        [shortDescription setObject:[sec objectForKey:@"subject"] forKey:@"subject"];
        [shortDescription setObject:[sec objectForKey:@"catalog_number"] forKey:@"catalog_number"];
        [shortDescription setObject:[sec objectForKey:@"section"] forKey:@"section"];
        [shortList addObject:[NSDictionary dictionaryWithDictionary:shortDescription]];
    }
    return shortList;
}
-(NSMutableArray* )generateWatchList:(NSArray *)shortList{
    NSMutableArray *watchList=[[NSMutableArray alloc]init];
    for (NSDictionary *sec in shortList){
        NSDictionary *fullDescription=[self loadSectionForSubject:[sec objectForKey:@"subject"] Number:[sec objectForKey:@"catalog_number"] Section:[sec objectForKey:@"section"]];
        [watchList addObject:fullDescription];
    }
    return watchList;
}
/*interclass API method ENDS*/

@end




