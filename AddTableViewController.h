//
//  AddTableViewController.h
//  watcher
//
//  Created by Alex Wang on 1/31/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//


//static NSString *apiKey=@"e2b51117475b5dd304155b436fe6787b";
#import "staticData.h"
#import <UIKit/UIKit.h>

@interface AddTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property IBOutlet UISearchBar *sectionSearchBar;

@property (nonatomic,strong) NSMutableArray * sectionList;

@property (nonatomic,strong) NSMutableArray * courseCatList;

@property (nonatomic,strong) NSMutableArray * courseSubList;

@property (nonatomic,strong) NSMutableArray * subjectList;

@property (nonatomic,strong) NSMutableArray * filteredList;

@end
