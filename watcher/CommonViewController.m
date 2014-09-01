//
//  CommonViewController.m
//  watcher
//
//  Created by Alex Wang on 7/22/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "CommonViewController.h"
#import "staticData.h"
#import "Reachability.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*
- (UIColor*)randomColor{
    CGFloat hue;
    do {
        hue=arc4random() % 256 / 256.0 ;
    } while ( !((fabsf(hue-240.0f/256.0f)>0.1f)&&(fabsf(hue+1-240.0f/256.0f)>0.1f)));  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 800.0 ) + 0.4;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 800.0 ) + 0.75;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationController.navigationBar.translucent=NO;
    self.view.backgroundColor=[UIColor clearColor];
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:72.0/256 green:72.0/256 blue:144.0/256 alpha:1]];
    
  //  [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:20.0/256 green:68.0/256 blue:106.0/256 alpha:1]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:98.0/256 green:221.0/256 blue:240.0/256 alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:customFont} ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)hasNetwork{
    if (debug) return true;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return(networkStatus != NotReachable);
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
