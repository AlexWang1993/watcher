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
    if (appDelegate.subjectList){
        _subjectList=[NSMutableArray arrayWithArray:appDelegate.subjectList];
    } else {
        _subjectList=[[NSMutableArray alloc]init];
        [self loadSubList];
    }
    //[self performSelectorInBackground:@selector(loadSubList) withObject:nil];
    //[self loadSubList];
    self.navigationItem.rightBarButtonItem=self.addButton;
    self.navigationItem.leftBarButtonItem=self.editButtonItem;
    _setting=[Setting sharedInstance];
    self.view.backgroundColor=[UIColor clearColor];
    
    self.pageControlBeingUsed = NO;
    //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:72.0/256 green:72.0/256 blue:0.0/256 alpha:1]];
    
    
    //nav bar color clear white
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:98.0/256 green:221.0/256 blue:240.0/256 alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:customFont}];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:customFont} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:customFont} forState:UIControlStateNormal];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    

    
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

- (UIColor*)randomColor{
    CGFloat hue;
    do {
        hue=arc4random() % 256 / 256.0 ;
    } while ( !((fabsf(hue-193.0f/256.0f)<0.1f)||(fabsf(hue+1-193.0f/256.0f)<0.1f)));  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 800.0 ) + 0.25;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 800.0 ) + 0.75;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    //return color;
    return [UIColor colorWithRed:153.0/255 green:204.0/255 blue:(153.0)/255 alpha:1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setBackgroundColor:[self randomColor]];
   
    cell.textLabel.lineBreakMode = YES;
    
    cell.textLabel.numberOfLines= 0;
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@ %@    %@\n\n%@%@    %@ %@ - %@",[[_watchList objectAtIndex:indexPath.row] objectForKey:@"subject"],[[_watchList objectAtIndex:indexPath.row] objectForKey:@"catalog_number"],[[_watchList objectAtIndex:indexPath.row] objectForKey:@"section"],[[[[[_watchList objectAtIndex:indexPath.row]objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"location"] objectForKey:@"building"],[[[[[_watchList objectAtIndex:indexPath.row]objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"location"] objectForKey:@"room"],[[[[[_watchList objectAtIndex:indexPath.row]objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"date"] objectForKey:@"weekdays"],[[[[[_watchList objectAtIndex:indexPath.row] objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"date"] objectForKey:@"start_time"],[[[[[_watchList objectAtIndex:indexPath.row] objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"date"] objectForKey:@"end_time"]];
    if ([self isFullForSectionNumber:indexPath.row]){
        cell.detailTextLabel.text=@"FULL";
        cell.detailTextLabel.textColor=[UIColor redColor];
    } else {
        cell.detailTextLabel.text=@"";
    }
    cell.textLabel.font = [UIFont fontWithName:@"Quicksand" size:14.0f];


    return cell;
}



/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0, 0, 24, 24);
    spinner.hidesWhenStopped = YES;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = spinner;
    
    if (!appDelegate.didRefresh) {
        [spinner startAnimating];
    }
    
    if (appDelegate.didRefresh) {
        [spinner stopAnimating];
    }
  //  [self performSelectorOnMainThread:@selector(refreshWatchList) withObject:spinner waitUntilDone:YES];

    
 //   [self performSelector:@selector(refreshWatchList) withObject:spinner afterDelay:1.0];
   // [self performSelector:@selector(callfunction) withObject:activityindicator1 afterDelay:1.0];

}*/

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (self.pageControlBeingUsed) {
        return;
    }
}
/*
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
*/
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
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/codes/subjects.json?key=%@&term=1145", apiKey]];
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

-(NSDictionary *)loadSectionForSubject:(NSString *)subject Number:(NSString *)number Section:(NSString *)section{
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/courses/%@/%@/schedule.json?key=%@&term=1145", subject, number, apiKey]];
    //for debugging
    //NSURL *url=[NSURL fileURLWithPath:[NSString stringWithFormat:@"/Users/alexwang/Documents/ClassWatcher/testjson/%@/%@/schedule.json",subject,number]];
    //
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
            [_watchList replaceObjectAtIndex:i withObject:[self loadSectionForSubject:[section objectForKey:@"subject"] Number:[section objectForKey:@"catalog_number"] Section:[section objectForKey:@"section"]]];
         dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
             });});
        
    }
    
  
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0, 0, 24, 24);
    spinner.hidesWhenStopped = YES;
    for (UITableViewCell *cell in self.tableView.visibleCells){
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
        cell.accessoryView = spinner;
        [spinner startAnimating];
        
        [self.tableView reloadData];
        
        [spinner stopAnimating];
        [spinner hidesWhenStopped];
    }
 //   [self.tableView reloadData];
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

/*interclass API method*/
-(NSArray* )generateShortList{
    NSMutableArray *shortList=[[NSMutableArray alloc] init];
    for (NSDictionary *sec in _watchList){
        NSMutableDictionary *shortDescription=[[NSMutableDictionary alloc]init];
        [shortDescription setObject:[sec objectForKey:@"subject"] forKey:@"subject"];
        [shortDescription setObject:[sec objectForKey:@"catalog_number"] forKey:@"catalog_number"];
        [shortDescription setObject:[sec objectForKey:@"section"] forKey:@"section"];
        
        
        [shortList addObject:[NSDictionary dictionaryWithDictionary:shortDescription]];
    }
    return [NSArray arrayWithArray: shortList];
//    for (int i=0;i<_watchList.count;i++){
//        for (int j=0;j<[_watchList[i][@"classes"] count];j++){
//            [_watchList[i][@"classes"][j][@"date"] removeObjectForKey:@"end_date"];
//            [_watchList[i][@"classes"][j][@"date"] removeObjectForKey:@"start_date"];
//        }
//    }
//    return [NSArray arrayWithArray:_watchList];
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
//    if (![self hasNetwork]){
//        return [[NSMutableArray alloc]init];
//    }
//    NSMutableArray *watchList=[[NSMutableArray alloc]init];
//    for (NSDictionary *sec in shortList){
//        NSDictionary *fullDescription=[self loadSectionForSubject:[sec objectForKey:@"subject"] Number:[sec objectForKey:@"catalog_number"] Section:[sec objectForKey:@"section"]
//                                       ];
//        [watchList addObject:fullDescription];
//    }
//    return [NSMutableArray arrayWithArray:shortList];
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
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return(networkStatus != NotReachable);
}


@end




