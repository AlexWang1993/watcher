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
    
	// Do any additional setup after loading the view.
    // Custom initialization
    //_sectionPicker=[[UIPickerView alloc] init];
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"light blue wallpaper hd.jpg"]];
  
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
    _setting=[Setting sharedInstance];

    
}
-(void)viewWillAppear:(BOOL)animated{
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[_setting.settings objectForKey:@"backgroundImage"]]];
    self.view.backgroundColor= [UIColor clearColor];
    //self.view.alpha = 0.2f;
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
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/courses/%@/%@/schedule.json?key=%@&term=1145", subject, number, unlimitedAPIKey]];
    NSError *error=nil;
    NSData *JSONData= [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    NSDictionary *results=[NSJSONSerialization
                           JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    _sectionList=[results objectForKey:@"data"];
    [_sectionPicker reloadAllComponents];
    
}


-(void)loadSubList{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/codes/subjects.json?key=%@&term=1145", unlimitedAPIKey]];
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

/*-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.font = [UIFont fontWithName:@"Quicksand" size:14.0f];
    label.textColor = [UIColor blackColor];
    
    return label;
}
*/
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    UILabel *label = [[UILabel alloc]initWithFrame:pickerView.bounds];
    label.font =[UIFont fontWithName:@"Quicksand" size:14.0f];
    NSDictionary *section=[_sectionList objectAtIndex:row];
    
    UIFont *font = [UIFont fontWithName:@"Quicksand" size:14.0f];
 //   NSFont *font = [NSFont fontWithName:@"Palatino-Roman" size:14.0];

 /*   NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:@"CustomFont"];
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@   %@",[section objectForKey:@"subject"],[section objectForKey:@"catalog_number"],[section objectForKey:@"section"]] attributes:attrsDictionary];
    
    return attrString;*/
    return [NSString stringWithFormat:@"%@ %@   %@",[section objectForKey:@"subject"],[section objectForKey:@"catalog_number"],[section objectForKey:@"section"]];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _sectionList.count;
}


@end
