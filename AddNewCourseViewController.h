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
#import "CommonViewController.h"
@interface AddNewCourseViewController : CommonViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *subjectInput;
@property (strong, nonatomic) IBOutlet UITextField *numberInput;
@property (strong, nonatomic) IBOutlet UIPickerView *sectionPicker;
@property (strong, nonatomic) IBOutlet UILabel *message;

@property (strong,nonatomic) NSMutableArray * subjectList;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *seeDetails;
@property (strong, nonatomic) IBOutlet UIButton *addButton;

@property (strong,nonatomic) NSArray *sectionList;
@property  Setting* setting;
@property (strong,nonatomic) IBOutlet UILabel *subjectInputLabel;

@property (strong,nonatomic) IBOutlet UILabel *numberInputLabel;
@property (weak,nonatomic) TableViewController *parent;

@property (strong,nonatomic) NSString * test;
@property(strong,nonatomic)IBOutlet UISegmentedControl *chooseTerm;
-(IBAction)segmentbutton:(id)sender;
@property (strong,atomic)NSString *currCode;
@property (strong,atomic)NSString *nextCode;
@property (strong,atomic)NSString *choseTerm;
@end
