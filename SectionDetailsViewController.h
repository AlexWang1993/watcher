//
//  SectionDetailsViewController.h
//  watcher
//
//  Created by Alex Wang on 2/10/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "CommonViewController.h"
//#import "staticData.h"
#import "Setting.h"
@interface SectionDetailsViewController : CommonViewController

@property (strong, nonatomic) IBOutlet UILabel *subjectLabel;
@property (strong, nonatomic) IBOutlet UILabel *sectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *professorLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *capacityLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalEnrolledLabel;
@property (strong, nonatomic) IBOutlet UILabel *avgRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *easinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotnessLabel;

@property  Setting* setting;

@property (strong,nonatomic)IBOutlet UILabel *allTextLabel;

@property (strong,nonatomic) NSDictionary *info;
@property (weak,nonatomic) TableViewController *parent;
@end
