//
//  SettingViewController.m
//  watcher
//
//  Created by Helen Jiang on 3/3/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "UILabel+CustomFont.h"
#import "UITextField+CustomFont.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _imageList = [[NSArray alloc] initWithObjects:@"default theme",@"dark blue",@"light green",@"warm pink", nil];
    _backgroundPicker.delegate = self;
    _backgroundPicker.dataSource  = self;
    _setting=[Setting sharedInstance];
    if (([[_setting.settings objectForKey:@"notificationEnabled"] isEqualToValue:@YES])||(![[_setting.settings allKeys]containsObject:@"notificationEnabled"])){
        [_setting.settings setObject:@YES forKey:@"notificationEnabled"];
        [_notificationSwitch setOn:YES];
    } else {
        [_notificationSwitch setOn:NO];
    }
    [_notificationSwitch addTarget:self action:@selector(notificationStateChanged:) forControlEvents:UIControlEventValueChanged];
    self.view.backgroundColor=[UIColor clearColor];
    [self.theme setCustomFont];
    [self.enable setCustomFont];
}


-(void)viewWillAppear:(BOOL)animated{
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[_setting.settings objectForKey:@"backgroundImage"]]];
       // self.view.alpha = 0.8f;
    self.navigationController.navigationBar.translucent=NO;
    
}


- (void)notificationStateChanged:(id)sender
{
    if([_notificationSwitch isOn]){
        [_setting.settings setObject:@YES forKey:@"notificationEnabled"];
    } else {
        [_setting.settings setObject:@NO forKey:@"notificationEnabled"];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _imageList.count;
}


//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    return [_imageList objectAtIndex:row];
//}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* view1=(UILabel*)view;
    if (!view1){
        view1=[[UILabel alloc]init];
        view1.minimumFontSize = 8.;
        view1.adjustsFontSizeToFitWidth = YES;

    }
    [view1 setTextColor:[UIColor blackColor]];
    view1.font = [UIFont fontWithName:@"Quicksand" size:16];
    [view1 setText:[_imageList objectAtIndex:row]];
    view1.textAlignment=NSTextAlignmentCenter;
    return view1;
}

/*-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _backgroundSelected =[_imageList objectAtIndex:row];
    if ([_backgroundSelected isEqualToString: @"default theme"]) {
        [[UIView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed: @"light blue wallpaper hd.jpg" ]]];}
    if ([_backgroundSelected isEqualToString: @"dark blue"]) {
        [[UIView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed: @"background2.jpg" ]]];}
    if ([_backgroundSelected isEqualToString: @"light green"]) {
        [[UIView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background3.jpg"]]];
    }
    if ([_backgroundSelected isEqualToString: @"warm pink"]) {
        [[UIView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background4.jpg"]]];
    }
}*/
//if([_notificationSwitch isOn]){
  //  [_setting.settings setObject:@YES forKey:@"notificationEnabled"];
//}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _backgroundSelected =[_imageList objectAtIndex:row];
    if ([_backgroundSelected isEqualToString: @"default theme"]) {
        [_setting.settings setObject:@"light blue wallpaper hd.jpg" forKey:@"backgroundImage"];
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"light blue wallpaper hd.jpg"]];}
    if ([_backgroundSelected isEqualToString: @"dark blue"]) {
        [_setting.settings setObject:@"background2.jpg" forKey:@"backgroundImage"];
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background2.jpg"]];}
    if ([_backgroundSelected isEqualToString: @"light green"]) {
        [_setting.settings setObject:@"background3.jpg" forKey:@"backgroundImage"];
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background3.jpg"]];}
    if ([_backgroundSelected isEqualToString: @"warm pink"]) {
        [_setting.settings setObject:@"background4.jpg" forKey:@"backgroundImage"];
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background4.jpg"]];}
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] refreshBackground];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"about"]) {
        UIViewController *about = [segue destinationViewController];
    }
}



@end
