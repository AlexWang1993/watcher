//
//  TabBarViewController.m
//  watcher
//
//  Created by Alex Wang on 7/22/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

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
    [self setDelegate:self];
    // Do any additional setup after loading the view.
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:72.0/256 green:72.0/256 blue:0.0/256 alpha:1]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if (!viewController.isViewLoaded){
//        [self presentViewController:viewController animated:NO completion:nil];
//    }
    [viewController.navigationController.navigationBar setHidden:NO];
    NSArray *tabViewControllers = tabBarController.viewControllers;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = viewController.view;
    if (fromView == toView)
        return NO;
    NSUInteger fromIndex = [tabViewControllers indexOfObject:tabBarController.selectedViewController];
    NSUInteger toIndex = [tabViewControllers indexOfObject:viewController];
    //tabBarController.selectedIndex = toIndex;
    tabBarController.selectedIndex = fromIndex;
    
    //fromView.viewForBaselineLayout
    viewController.view.alpha=0;
    //viewController.navigationController.navigationBar.translucent=YES;
    [UIView transitionWithView:toView duration:0.5 options: toIndex > fromIndex ? UIViewAnimationOptionTransitionCrossDissolve : UIViewAnimationOptionTransitionCrossDissolve animations:^{
        viewController.view.alpha=1;
    }completion:nil];
//    //[UIView transitionFromView:fromView
//                        toView:toView
//                      duration:0.5
//                       options: toIndex > fromIndex ? UIViewAnimationOptionTransitionCrossDissolve : UIViewAnimationOptionTransitionCrossDissolve
//                    completion:^(BOOL finished) {
//                        if (finished) {
//                            
//                        }
//                    }];
    NSLog(@"ajsdiofsjdiof");
    return true;
}

//-(void)tab

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
