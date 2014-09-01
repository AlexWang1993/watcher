//
//  SettingViewController.h
//  watcher
//
//  Created by Helen Jiang on 3/3/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting.h"
#import "CommonViewController.h"

@interface SettingViewController : CommonViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIPickerViewAccessibilityDelegate>

@property (strong, nonatomic) IBOutlet UIButton *about;

@property (strong,nonatomic) NSArray *imageList;
@property (strong,nonatomic) IBOutlet UIPickerView *backgroundPicker;
@property (strong, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (strong,nonatomic) NSString *backgroundSelected;
@property (strong, nonatomic) IBOutlet UILabel *enable;
@property (strong, nonatomic) IBOutlet UIButton *aboutThisApp;
@property (strong, nonatomic) IBOutlet UILabel *theme;


@property  Setting* setting;
@end
