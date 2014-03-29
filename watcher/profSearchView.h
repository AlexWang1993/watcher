//
//  profSearchView.h
//  watcher
//
//  Created by Helen Jiang on 3/2/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Setting.h"

@interface profSearchView : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *profLastName;
@property (strong, nonatomic) IBOutlet UITextField *profFirstName;
@property (strong, nonatomic) IBOutlet UIButton *searchProfButton;

@property (strong, nonatomic) NSArray* profNameList;

@property (strong, nonatomic) IBOutlet UILabel *recommend1;
@property (strong, nonatomic) IBOutlet UILabel *recommend2;
@property (strong, nonatomic) IBOutlet UILabel *recommend3;
@property (strong, nonatomic) IBOutlet UILabel *recommend4;
@property (strong, nonatomic) IBOutlet UILabel *recommend5;
@property (strong, nonatomic) NSArray *myLabels;
@property (strong, nonatomic) IBOutlet UILabel *info;


@property  Setting* setting;


extern NSString *backgroundSelected;
@property (strong, nonatomic) NSArray *sortedArray;

@end
