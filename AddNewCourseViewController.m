//
//  AddNewCourseViewController.m
//  watcher
//
//  Created by Alex Wang on 2/9/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "AddNewCourseViewController.h"

#import "SectionDetailsViewController.h"

#import "UILabel+CustomFont.h"

#import "DBManager.h"


@interface AddNewCourseViewController ()

@end

@implementation AddNewCourseViewController

@synthesize subjectList=_subjectList;

@synthesize numberInput=_numberInput;

@synthesize subjectInput=_subjectInput;

@synthesize sectionPicker=_sectionPicker;
@synthesize subjectInputLabel = _subjectInputLabel;
@synthesize numberInputLabel = _numberInputLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (IBAction)editingDidEnd:(id)sender {
    [_numberInput resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_subjectInputLabel setCustomFont];
    [_numberInputLabel setCustomFont];
    _searchButton.titleLabel.font = [UIFont fontWithName:@"Quicksand" size:16.0f];
    _seeDetails.titleLabel.font = [UIFont fontWithName:@"Quicksand" size:16.0f];
    _addButton.titleLabel.font = [UIFont fontWithName:@"Quicksand" size:16.0f];
    _sectionPicker.delegate=self;
    _sectionPicker.dataSource=self;
    _subjectInput.delegate=self;
    _numberInput.delegate=self;
    _subjectInput.tag=1;
    _numberInput.tag=2;
    _sectionList=[[NSArray alloc] init];
    _setting=[Setting sharedInstance];
    
#pragma get term name&number, populate seg ctrl
    NSError *getTermError = nil;
    NSURL *getTermUrl =[NSURL URLWithString:@"http://watcher-waterlooapp.rhcloud.com/get_terms"];
    NSData *JSONData= [NSData dataWithContentsOfURL:getTermUrl options:NSDataReadingMappedIfSafe error:&getTermError];
    NSDictionary *terms=[NSJSONSerialization
                           JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&getTermError];
    NSString *currName = [[terms objectForKey:@"current"] objectForKey:@"name"];
    NSString *nextName = [[terms objectForKey:@"next"] objectForKey:@"name"];
    _currCode = [[terms objectForKey:@"current"] objectForKey:@"code"];
    _nextCode = [[terms objectForKey:@"next"] objectForKey:@"code"];
    [_chooseTerm setTitle:currName forSegmentAtIndex:0];
    [_chooseTerm setTitle:nextName forSegmentAtIndex:1];

}

-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor= [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)segmentbutton:(id)sender {
    
    if (_chooseTerm.selectedSegmentIndex == 0) {
    } else {
    }
}


- (IBAction)changeCap:(id)sender {
    NSString *tmp = [_subjectInput.text uppercaseString];
     [_subjectInput setText:tmp];
}


- (IBAction)buttonPressed:(id)sender {
    if (![self hasNetwork]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network" message:@"Please check your network connection and retry." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [_numberInput resignFirstResponder];
    [_subjectInput resignFirstResponder];
    NSString *message;
    if (_subjectList.count==0){
        _subjectList=[_parent getSubList];
    }
    if (![_subjectList containsObject:[_subjectInput.text uppercaseString]]){
        message = @"Invalid subject entered";
    }
    if (([_subjectInput.text isEqualToString:@""])||([_subjectInput.text isEqualToString:@" "])){
        message = @"Empty subject entered";
    }
    if (([_numberInput.text isEqualToString:@""])||([_numberInput.text isEqualToString:@" "])){
        message = @"Empty course number entered";
    }
    NSCharacterSet *ch=[NSCharacterSet alphanumericCharacterSet];
    if (![[_numberInput.text stringByTrimmingCharactersInSet:ch] isEqualToString:@""]){
        message = @"Invalid course number entered";
    }
    if (message){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Back" otherButtonTitles:nil];
    [alert show];
    }
    [self loadSectionsSubject:[_subjectInput.text uppercaseString] Number:_numberInput.text];
    return;
}

- (IBAction)addToWatch:(id)sender {
    NSString *message;
    if ([_sectionList count]==0){
        message=@"Please search your course first";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Back" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [_parent addSection:[_sectionList objectAtIndex:[_sectionPicker selectedRowInComponent:0]]];
    [self performSelectorInBackground:@selector(postNewWatch:) withObject:[_sectionList objectAtIndex:[_sectionPicker selectedRowInComponent:0]]];
    message = @"Done";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Back" otherButtonTitles:nil];
    [alert show];
    return;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"seeDetails"]){
        if ([_sectionList count]==0){
            _message.text=@"Please search your course first";
            _message.textColor=[UIColor redColor];
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"seeDetails"]){
        SectionDetailsViewController *controller=[segue destinationViewController];
        controller.info=[_sectionList objectAtIndex:[_sectionPicker selectedRowInComponent:0]];
    }
}

/*BUTTON ACTIONS END*/

/* loadAPI stuff*/
-(void)loadSectionsSubject:(NSString *)subject Number:(NSString *)number{
    if (![self hasNetwork]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network" message:@"Please check your network connection and retry." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSURL *url;
    if ([_chooseTerm selectedSegmentIndex]) { // 1
        _choseTerm = _nextCode;
    } else {
        _choseTerm = _currCode;
    }

    if (!debug){
        url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/courses/%@/%@/schedule.json?key=%@&term=%@", subject, number, unlimitedAPIKey,_choseTerm]];
    } else {
        //url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"schedule",subject,number] ofType:@"json" inDirectory:[NSString stringWithFormat:@"testjson/%@/%@",subject,number]] ];
        url=[NSURL URLWithString:[NSString stringWithFormat:@"file://localhost/Users/alex/watcher/test_json/%@/%@/%@/schedule.json",_choseTerm,subject,number]];

    }
    NSError *error=nil;
    NSData *JSONData= [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    NSDictionary *results=[NSJSONSerialization
                           JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    JSONData = 
    _sectionList=[results objectForKey:@"data"];
    [_sectionPicker reloadAllComponents];
    
}

-(void)postNewWatch:(NSDictionary*)section{
    NSString* subject = [section objectForKey:@"subject"];
    NSString* number = [section objectForKey:@"catalog_number"];
    NSArray* arr = [[section objectForKey:@"section"] componentsSeparatedByString:@" "];
    NSString* type = arr[0];
    NSString* section_num = arr[1];
    NSInteger termNumber = 0;
    if (_chooseTerm.selectedSegmentIndex!=0) {
        termNumber = 4;
    }
    [DBManager submitWatchForSubject:subject Number:number Type:type Section:section_num Term:_choseTerm];
    
    
    
}



/*loadAPI stuff END*/

/*pickerView*/

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel * label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.minimumFontSize = 8;
        label.adjustsFontSizeToFitWidth = YES;
    }
    [label setTextColor:[UIColor blackColor]];
    label.font =[UIFont fontWithName:@"Quicksand" size:16];
    NSDictionary *section=[_sectionList objectAtIndex:row];
    [label setText:[NSString stringWithFormat:@"%@ %@   %@",[section objectForKey:@"subject"],[section objectForKey:@"catalog_number"],[section objectForKey:@"section"]]];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}





-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _sectionList.count;
}


@end
