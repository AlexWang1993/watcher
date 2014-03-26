//
//  SettingViewController.m
//  watcher
//
//  Created by Helen Jiang on 3/3/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "SettingViewController.h"



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
    _imageList = [[NSArray alloc] initWithObjects:@"default theme",@"dark blue",@"light green",@"happy orange", nil];
    _backgroundPicker.delegate = self;
    _backgroundPicker.dataSource  = self;
    _setting=[Setting sharedInstance];
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


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_imageList objectAtIndex:row];
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
    if ([_backgroundSelected isEqualToString: @"happy orange"]) {
        [[UIView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background4.jpg"]]];
    }
}*/


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _backgroundSelected =[_imageList objectAtIndex:row];
    if ([_backgroundSelected isEqualToString: @"default theme"]) {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"light blue wallpaper hd.jpg"]];}
    if ([_backgroundSelected isEqualToString: @"dark blue"]) {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background2.jpg"]];}
    if ([_backgroundSelected isEqualToString: @"light green"]) {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background3.jpg"]];}
    if ([_backgroundSelected isEqualToString: @"happy orange"]) {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background4.jpg"]];}
}

@end
