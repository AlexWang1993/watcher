//
//  AddNewCourseViewController.h
//  watcher
//
//  Created by Alex Wang on 2/9/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "staticData.h"

#import "TableViewController.h"

@interface AddNewCourseViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *subjectInput;
@property (strong, nonatomic) IBOutlet UITextField *numberInput;
@property (strong, nonatomic) IBOutlet UIPickerView *sectionPicker;
@property (strong, nonatomic) IBOutlet UILabel *message;

@property (strong,nonatomic) NSMutableArray * subjectList;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *seeDetails;
@property (strong, nonatomic) IBOutlet UIButton *addButton;

@property (strong,nonatomic) NSArray *sectionList;


@property (weak,nonatomic) TableViewController *parent;
@end
