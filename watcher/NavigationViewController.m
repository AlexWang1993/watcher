//
//  NavigationViewController.m
//  watcher
//
//  Created by Alex Wang on 7/22/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "NavigationViewController.h"
#import "UINavigationController+CustomTransition.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

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
    [self setDelegate:self];
    self.navigationController.navigationBar.translucent=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
      //transition.delegate = super;
    [super.view.layer addAnimation:transition forKey:nil];
    [super pushViewController:viewController animated:NO];
    //[super pushViewController:viewController withCustomTransition:CustomViewAnimationTransitionFadeIn subtype:kCATransitionFromLeft];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];
    
}


-(UIViewController*)popViewControllerAnimated:(BOOL)animated{
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    UIViewController* popped=[super popViewControllerAnimated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    return popped;
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent=NO;
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
