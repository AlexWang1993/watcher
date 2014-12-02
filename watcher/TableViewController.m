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
#import "UITextField+CustomFont.h"
#import "staticData.h"
#import "Reachability.h"
#import "DBManager.h"


@interface TableViewController ()
@end

@implementation TableViewController

@synthesize fullLabel=_fullLabel;
@synthesize scrollView;
@synthesize pageControl;
@synthesize view1;
@synthesize view2;
@synthesize pageControlBeingUsed = _pageControlBeingUsed;
@synthesize infoDetail;
@synthesize location;
@synthesize appDelegate;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
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
    if (appDelegate.subjectList){
        _subjectList=[NSMutableArray arrayWithArray:appDelegate.subjectList];
    } else {
        _subjectList=[[NSMutableArray alloc]init];
        [self loadSubList];
    }
    self.navigationItem.rightBarButtonItem=self.addButton;
    self.navigationItem.leftBarButtonItem=self.editButtonItem;
    _setting=[Setting sharedInstance];
    self.view.backgroundColor=[UIColor clearColor];
    
    self.pageControlBeingUsed = NO;
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:98.0/256 green:221.0/256 blue:240.0/256 alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:customFont}];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:customFont} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:customFont} forState:UIControlStateNormal];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self refreshWatchListAsync];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
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


-(void)refreshCellColor:(UITableViewCell *)cell{
    if ([_setting.settings objectForKey:@"theme"]==nil) {
        [cell setBackgroundColor:[UIColor colorWithRed:153.0/255 green:204.0/255 blue:(153.0)/255 alpha:1]];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    else if ([[_setting.settings objectForKey:@"theme"] isEqualToString:@"lemon yellow"]){
        [cell setBackgroundColor:[UIColor colorWithRed:153.0/255 green:204.0/255 blue:(153.0)/255 alpha:1]];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    else if ([[_setting.settings objectForKey:@"theme"] isEqualToString:@"sky blue"]){
        [cell setBackgroundColor:[UIColor colorWithRed:3.0/256 green:54.0/256 blue:73.0/256 alpha:1]];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else if ([[_setting.settings objectForKey:@"theme"] isEqualToString:@"warm pink"]){
        [cell setBackgroundColor:[UIColor colorWithRed:153.0/256 green:77.0/256 blue:82.0/256 alpha:1]];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else if ([[_setting.settings objectForKey:@"theme"] isEqualToString:@"cucumber green"]){
        [cell setBackgroundColor:[UIColor colorWithRed:64.0/256 green:116.0/256 blue:52.0/256 alpha:1]];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self refreshCellColor:cell];
   
    cell.textLabel.lineBreakMode = YES;
    
    cell.textLabel.numberOfLines= 0;
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"Quicksand-bold" size:20.0];
    if ([[[_watchList objectAtIndex:indexPath.row]objectForKey:@"campus"] containsString:@"ONLINE"]) {
        cell.textLabel.text =[NSString stringWithFormat:@"%@ %@    %@\n\nOnline Course",[[_watchList objectAtIndex:indexPath.row] objectForKey:@"subject"],[[_watchList objectAtIndex:indexPath.row] objectForKey:@"catalog_number"],[[_watchList objectAtIndex:indexPath.row] objectForKey:@"section"]];
    }
    else{
            cell.textLabel.text=[NSString stringWithFormat:@"%@ %@    %@\n\n%@%@    %@ %@ - %@",[[_watchList objectAtIndex:indexPath.row] objectForKey:@"subject"],[[_watchList objectAtIndex:indexPath.row] objectForKey:@"catalog_number"],[[_watchList objectAtIndex:indexPath.row] objectForKey:@"section"],[[[[[_watchList objectAtIndex:indexPath.row]objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"location"] objectForKey:@"building"],[[[[[_watchList objectAtIndex:indexPath.row]objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"location"] objectForKey:@"room"],[[[[[_watchList objectAtIndex:indexPath.row]objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"date"] objectForKey:@"weekdays"],[[[[[_watchList objectAtIndex:indexPath.row] objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"date"] objectForKey:@"start_time"],[[[[[_watchList objectAtIndex:indexPath.row] objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"date"] objectForKey:@"end_time"]];
    }
    cell.detailTextLabel.font = [UIFont fontWithName:@"Quicksand" size:14.0f];
    if ([self isFullForSectionNumber:indexPath.row]){
      //  int overflow = [self getOverflowForSectionNumber:indexPath.row];
      //  if (overflow > 0){
      //      cell.detailTextLabel.text=[NSString stringWithFormat:@"FULL +%d",overflow];
      //  } else {
           cell.detailTextLabel.text=@"FULL";
      //  }
        cell.detailTextLabel.textColor=[UIColor redColor];
        
    } else {
        cell.detailTextLabel.text=@"";
    }
    cell.textLabel.font = [UIFont fontWithName:@"Quicksand" size:14.0f];


    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self refreshCellColor:cell];
}


- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (self.pageControlBeingUsed) {
        return;
    }
}

-(IBAction)clickPageControl:(id)sender
{
    int page=pageControl.currentPage;
    CGRect frame=scrollView.frame;
    frame.origin.x=frame.size.width=page;
    frame.origin.y=0;
    [scrollView scrollRectToVisible:frame animated:YES];
}

//disable swipe to delete
/*-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
}
 */


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

-(NSArray*)getSubList{
    if (_subjectList.count==0){
        [self loadSubList];
    }
    return [NSArray arrayWithArray:_subjectList];
}

-(void)loadSubList{
    
    if (![self hasNetwork]){return;}
    NSURL *url;
    if (!debug) {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"http://api.uwaterloo.ca/v2/codes/subjects.json?key=%@", unlimitedAPIKey]];
    } else {
        //url=[NSURL fileURLWithPath:[NSString stringWithFormat:@"/Users/alexwang/Documents/ClassWatcher/testjson/subjects.json"]];
       // url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"subjects" ofType:@"json" inDirectory:@"testjson"] ];
                url=[NSURL URLWithString:@"file://localhost/Users/alex/watcher/testjson/subjects.json"];

    }
    NSError *error=nil;
    NSData *JSONData = [NSData dataWithContentsOfURL:url
                                             options:NSDataReadingMappedIfSafe error:&error];
    NSLog(@"%@",error);
    NSDictionary *results= [NSJSONSerialization
                            JSONObjectWithData:JSONData options: NSJSONReadingAllowFragments error:&error];
    NSArray *data=[results objectForKey:@"data"];
    for ( NSDictionary *sec in data){
        [_subjectList addObject:[sec objectForKey:@"subject"]];
    }
}

-(NSDictionary *)loadSectionForSubject:(NSString *)subject Number:(NSString *)number Section:(NSString *)section Term:(NSString *)myTerm{
    
    NSURL *url;
    if (!debug){
        url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/courses/%@/%@/schedule.json?key=%@&term=%@", subject, number, apiKey,myTerm]];
    } else {
        //url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"schedule",subject,number] ofType:@"json" inDirectory:[NSString stringWithFormat:@"testjson/%@/%@",subject,number]] ];
        url=[NSURL URLWithString:[NSString stringWithFormat:@"file://localhost/Users/alex/watcher/test_json/%@/%@/%@/schedule.json",myTerm,subject,number]];
    }
    NSError *error=nil;
    NSData *JSONData= [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    NSDictionary *results=[NSJSONSerialization
                           JSONObjectWithData:JSONData options:0 error:&error];
    NSArray *sectionList=[results objectForKey:@"data"];
    int i;
    for (i=0;i<sectionList.count;i++){
        if ([[[sectionList objectAtIndex:i] objectForKey:@"section"] isEqualToString:section]){
            break;
        }
    }
    return [sectionList objectAtIndex:i];
    
}

-(void)refreshWatchListAsync{
    if (![self hasNetwork]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network" message:@"Please check your network connection and retry." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    for (int i=0;i<_watchList.count;i++){
        
        BOOL fullBefore=[self isFullForSectionNumber:i];
        NSDictionary *section=[_watchList objectAtIndex:i];
        dispatch_queue_t subQueue = dispatch_queue_create([[NSString stringWithFormat:@"subject%d",i] cStringUsingEncoding:NSASCIIStringEncoding], NULL);
        dispatch_async(subQueue, ^{
            [_watchList replaceObjectAtIndex:i withObject:[self loadSectionForSubject:[section objectForKey:@"subject"] Number:[section objectForKey:@"catalog_number"] Section:[section objectForKey:@"section"] Term:[section objectForKey:@"term"]]];
         dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
             });});
        
    }
    

 //   [self.tableView reloadData];
}

-(BOOL)refreshWatchList{
    
    BOOL flag=NO;
    _changedList=[[NSMutableArray alloc] init];
    for (int i=0;i<_watchList.count;i++){
        BOOL fullBefore=[self isFullForSectionNumber:i];
        NSDictionary *section=[_watchList objectAtIndex:i];
        [_watchList replaceObjectAtIndex:i withObject:[self loadSectionForSubject:[section objectForKey:@"subject"] Number:[section objectForKey:@"catalog_number"] Section:[section objectForKey:@"section"] Term:[section objectForKey:@"term"]]];
        if ((fullBefore)&&(![self isFullForSectionNumber:i])){
            [_changedList addObject:[NSString stringWithFormat:@"%@ %@  %@",[section objectForKey:@"subject"],[section objectForKey:@"catalog_number"],[section objectForKey:@"section"],[section objectForKey:@"term"]]];
            flag=YES;
            [self performSelectorInBackground:@selector(postNewNotification:) withObject:([_watchList objectAtIndex:i])];
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
        dest.parent = self;
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

-(int)getOverflowForSectionNumber:(NSInteger)number{
    NSDictionary *section=[_watchList objectAtIndex:number];
    return [[section objectForKey:@"enrollment_total"] intValue] - [[section objectForKey:@"enrollment_capacity"] intValue];
}

-(NSArray*)generateJSONs{
    NSError *error;
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    for (int i=0;i<_watchList.count;i++){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_watchList[i]
                                                            options:0
                                                         error:&error];
    
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        } else {
            NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [ret addObject:jsonString];
        }
    }
    return [NSArray arrayWithArray:ret];
}


-(NSMutableArray* )generateWatchList:(NSArray *)jsonList{
    NSMutableArray *ret=[[NSMutableArray alloc]init];
    for (int i=0;i<jsonList.count;i++){
        NSData *data = [jsonList[i] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [ret addObject:dictionary];
    }
    return ret;
        
}
/*interclass API method ENDS*/


-(BOOL)hasNetwork{
    if (debug) return true;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return(networkStatus != NotReachable);
}

-(void)postNewNotification:(NSDictionary*)section{
    NSString* subject = [section objectForKey:@"subject"];
    NSString* number = [section objectForKey:@"catalog_number"];
    NSArray* arr = [[section objectForKey:@"section"] componentsSeparatedByString:@" "];
    NSString* type = arr[0];
    NSString* section_num = arr[1];

    [DBManager submitNotificationForSubject:subject Number:number Type:type Section:section_num];
    
    
    
}


@end




