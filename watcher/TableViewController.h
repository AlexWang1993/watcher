//
//  TableViewController.h
//  watcher
//
//  Created by Alex Wang on 1/31/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "staticData.h"


@interface TableViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray *subjectList;

@property (strong,nonatomic) NSMutableArray *watchList;

@property (strong,nonatomic) IBOutlet UILabel *fullLabel;

@property (strong,nonatomic) NSMutableArray *changedList;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

-(void)addSection:(NSDictionary *)section;

-(NSMutableArray* )generateShortList;

@end
