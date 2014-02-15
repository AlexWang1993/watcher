//
//  SectionDetailsViewController.h
//  watcher
//
//  Created by Alex Wang on 2/10/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *subjectLabel;
@property (strong, nonatomic) IBOutlet UILabel *sectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *professorLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong,nonatomic) NSDictionary *info;

@end
