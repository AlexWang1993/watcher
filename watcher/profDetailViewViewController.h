//
//  profDetailViewViewController.h
//  watcher
//
//  Created by Helen Jiang on 3/2/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "profSearchView.h"
#import "CommonViewController.h"
#import "Setting.h"
@interface profDetailViewViewController : CommonViewController


@property (strong, nonatomic) IBOutlet UILabel *NameLabel;
@property (strong, nonatomic) IBOutlet UILabel *qualityLabel;
@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;
@property (strong, nonatomic) IBOutlet UILabel *easinessLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UILabel *hotnessLabel;

@property  Setting* setting;

@property (weak,nonatomic) NSString *profName;

@end
