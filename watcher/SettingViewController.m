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
    _imageList = [[NSArray alloc] initWithObjects:@"lemon yellow",@"sky blue",@"warm pink",@"cucumber green", nil];
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
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:98.0/256 green:221.0/256 blue:240.0/256 alpha:1]];
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


//@"lemon yellow",@"sky blue",@"warm pink",@"cucumber green"
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _backgroundSelected =[_imageList objectAtIndex:row];
    if ([_backgroundSelected isEqualToString: @"lemon yellow"]) {
        
        [_setting.settings setObject:@"lemon yellow" forKey:@"theme"];
        [_setting.settings setObject:[self UIColorToArray:[UIColor colorWithRed:255.0/255 green:1.0f blue:(9*16+9.0f)/255 alpha:1]] forKey:@"color"];
        [_setting.settings setObject:[self UIColorToArray:[UIColor colorWithRed:149.0/256 green:196.0/256 blue:219.0/256 alpha:1] ]forKey:@"tabBarColor"];
        [_setting.settings setObject:[self UIColorToArray:[UIColor colorWithRed:206.0/256 green:232.0/256 blue:245.0/256 alpha:1]] forKey:@"tabBarHighLightColor"];
        self.view.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor= [UIColor colorWithRed:255.0/255 green:1.0f blue:(9*16+9.0f)/255 alpha:1];
        self.tabBarController.tabBar.barTintColor =[UIColor colorWithRed:149.0/256 green:196.0/256 blue:219.0/256 alpha:1];
        self.tabBarController.tabBar.selectedImageTintColor =[UIColor colorWithRed:206.0/256 green:232.0/256 blue:245.0/256 alpha:1];

        
    }
    
    if ([_backgroundSelected isEqualToString: @"sky blue"]) {
        [_setting.settings setObject:@"sky blue" forKey:@"theme"];
        [_setting.settings setObject:[self UIColorToArray:[UIColor colorWithRed:164.0/256 green:221.0/256 blue:237.0/256 alpha:1]] forKey:@"color"];
        
        [_setting.settings setObject:[self UIColorToArray:[UIColor colorWithRed:3.0/256 green:54.0/256 blue:73.0/256 alpha:1]] forKey:@"tabBarColor"];
        [_setting.settings setObject:[self UIColorToArray:[UIColor colorWithRed:206.0/256 green:232.0/256 blue:245.0/256 alpha:1]] forKey:@"tabBarHighLightColor"];
        self.view.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor= [UIColor colorWithRed:164.0/256 green:221.0/256 blue:237.0/256 alpha:1];
         self.tabBarController.tabBar.barTintColor =[UIColor colorWithRed:3.0/256 green:54.0/256 blue:73.0/256 alpha:1];
        self.tabBarController.tabBar.selectedImageTintColor =[UIColor colorWithRed:206.0/256 green:232.0/256 blue:245.0/256 alpha:1];
    }
    
    if ([_backgroundSelected isEqualToString: @"warm pink"]) {
        [_setting.settings setObject:@"warm pink" forKey:@"theme"];
        [_setting.settings setObject:[self UIColorToArray:[UIColor colorWithRed:252.0/256 green:157.0/256 blue:154.0/256 alpha:1]] forKey:@"color"];
        [_setting.settings setObject:[self UIColorToArray:[UIColor colorWithRed:249.0/256 green:205.0/256 blue:173.0/256 alpha:1]] forKey:@"tabBarColor"];
        [_setting.settings setObject:[self UIColorToArray:[UIColor colorWithRed:254.0/256 green:67.0/256 blue:101.0/256 alpha:1]] forKey:@"tabBarHighLightColor"];
        self.view.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor= [UIColor colorWithRed:252.0/256 green:157.0/256 blue:154.0/256 alpha:1];
        self.tabBarController.tabBar.barTintColor =[UIColor colorWithRed:249.0/256 green:205.0/256 blue:173.0/256 alpha:1];
        self.tabBarController.tabBar.selectedImageTintColor =[UIColor colorWithRed:254.0/256 green:67.0/256 blue:101.0/256 alpha:1];
    }
    
    if ([_backgroundSelected isEqualToString: @"cucumber green"]) {
        [_setting.settings setObject:@"cucumber green" forKey:@"theme"];
        [_setting.settings setObject:[self UIColorToArray:[UIColor colorWithRed:174.0/256 green:221.0/256 blue:129.0/256 alpha:1]] forKey:@"color"];
        [_setting.settings setObject:[self UIColorToArray:[UIColor colorWithRed:18.0/256 green:53.0/256 blue:85.0/256 alpha:1]] forKey:@"tabBarColor"];
        [_setting.settings setObject:[self UIColorToArray:[UIColor colorWithRed:206.0/256 green:232.0/256 blue:245.0/256 alpha:1] ] forKey:@"tabBarHighLightColor"];
        self.view.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor= [UIColor colorWithRed:174.0/256 green:221.0/256 blue:129.0/256 alpha:1];
        self.tabBarController.tabBar.barTintColor =[UIColor colorWithRed:18.0/256 green:53.0/256 blue:85.0/256 alpha:1];
        self.tabBarController.tabBar.selectedImageTintColor =[UIColor colorWithRed:206.0/256 green:232.0/256 blue:245.0/256 alpha:1];}
    
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] refreshBackground];
}

-(NSArray *)UIColorToArray:(UIColor*)color{
    float * arr=CGColorGetComponents(color.CGColor);
    return [[NSArray alloc]initWithObjects:[NSNumber numberWithFloat:arr[0]],
            [NSNumber numberWithFloat:arr[1]],
            [NSNumber numberWithFloat:arr[2]],
            [NSNumber numberWithFloat:arr[3]],nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"about"]) {
        UIViewController *about = [segue destinationViewController];
    }
}



@end
