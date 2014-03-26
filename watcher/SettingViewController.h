//
//  SettingViewController.h
//  watcher
//
//  Created by Helen Jiang on 3/3/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting.h"

@interface SettingViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIPickerViewAccessibilityDelegate>



@property (strong,nonatomic) NSArray *imageList;
@property (strong,nonatomic) IBOutlet UIPickerView *backgroundPicker;
@property (strong, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (strong,nonatomic) NSString *backgroundSelected;
@property  Setting* setting;
@end
