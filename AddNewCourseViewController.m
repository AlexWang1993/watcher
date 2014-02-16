//
//  AddNewCourseViewController.m
//  watcher
//
//  Created by Alex Wang on 2/9/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "AddNewCourseViewController.h"

#import "SectionDetailsViewController.h"

@interface AddNewCourseViewController ()

@end

@implementation AddNewCourseViewController

@synthesize subjectList=_subjectList;

@synthesize numberInput=_numberInput;

@synthesize subjectInput=_subjectInput;

@synthesize sectionPicker=_sectionPicker;

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
	// Do any additional setup after loading the view.
    // Custom initialization
    //_sectionPicker=[[UIPickerView alloc] init];
    
    _sectionPicker.delegate=self;
    _sectionPicker.dataSource=self;
    //_sectionPicker.hidden=true;
    //_subjectInput=[[UITextField alloc] init];
    _subjectInput.delegate=self;
    //_numberInput=[[UITextField alloc]init];
    _numberInput.delegate=self;
    _subjectInput.tag=1;
    _numberInput.tag=2;
    _sectionList=[[NSArray alloc] init];
    //_subjectList=[[NSMutableArray alloc]init];
    //_message=[[UILabel alloc]init];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==1){
        if ([_subjectList containsObject:[textField.text uppercaseString]]){
            _message.text=[textField.text uppercaseString];
            _numberInput.text=@"";
        } else {
            _message.text=@"Invalid subject entered";
        }
    } else {
        
    }
}*/


/*BUTTON ACTIONS BEGIN*/


- (IBAction)buttonPressed:(id)sender {
    [_numberInput resignFirstResponder];
    [_subjectInput resignFirstResponder];
    NSString *message;
    if (![_subjectList containsObject:[_subjectInput.text uppercaseString]]){
        message = @"Invalid subject entered";
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
    }
    [_parent addSection:[_sectionList objectAtIndex:[_sectionPicker selectedRowInComponent:0]]];
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
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/courses/%@/%@/schedule.json?key=%@", subject, number, apiKey]];
    NSError *error=nil;
    NSData *JSONData= [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    NSDictionary *results=[NSJSONSerialization
                           JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    _sectionList=[results objectForKey:@"data"];
    [_sectionPicker reloadAllComponents];
    
}


-(void)loadSubList{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/codes/subjects.json?key=%@", apiKey]];
    NSError *error=nil;
    NSData *JSONData = [NSData dataWithContentsOfURL:url
                                             options:NSDataReadingMappedIfSafe error:&error];
    NSDictionary *results= [NSJSONSerialization
                            JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments  error:&error];
    NSArray *data=[results objectForKey:@"data"];
    for ( NSDictionary *sec in data){
        [_subjectList addObject:[sec objectForKey:@"subject"]];
    }
}

/*loadAPI stuff END*/

/*pickerView*/

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *section=[_sectionList objectAtIndex:row];
    return [NSString stringWithFormat:@"%@ %@   %@",[section objectForKey:@"subject"],[section objectForKey:@"catalog_number"],[section objectForKey:@"section"]];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _sectionList.count;
}


@end
