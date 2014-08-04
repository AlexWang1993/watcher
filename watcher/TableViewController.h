//
//  TableViewController.h
//  watcher
//
//  Created by Alex Wang on 1/31/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "staticData.h"
#import "Setting.h"
#import "CommonViewController.h"
//#import "SectionDetailsViewController.h"

@interface TableViewController : UITableViewController;

@property (strong,nonatomic) NSMutableArray *subjectList;

@property (strong,nonatomic) NSMutableArray *watchList;

@property (strong,nonatomic) IBOutlet UILabel *fullLabel;

@property (strong,nonatomic) NSMutableArray *changedList;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property  Setting* setting;

@property (strong,nonatomic) UIActivityIndicatorView *spinner;

@property (strong,nonatomic) UIPageControl * pageControl;

@property (strong,nonatomic)UIScrollView * scrollView;

@property (strong,nonatomic) UIView *view1;

@property (strong,nonatomic) UIView *view2;

@property (strong,nonatomic) NSDictionary *infoDetail;

@property (strong,nonatomic) NSString *location;


//@property (weak,nonatomic) SectionDetailsViewController *detailView;


- (IBAction) changePage;

@property  BOOL pageControlBeingUsed;

-(BOOL)refreshWatchList;

-(void)addSection:(NSDictionary *)section;

-(NSArray*)generateJSONs;

-(void)refreshWatchListAsync;

-(NSArray*)getSubList;

@end
