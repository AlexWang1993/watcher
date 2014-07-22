//
//  AppDelegate.m
//  watcher
//
//  Created by Alex Wang on 1/31/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "AppDelegate.h"

#import "TableViewController.h"

#import "Appirater.h"

#import "profSearchView.h"

@implementation AppDelegate

-(Setting *)getSetting{
    return [Setting sharedInstance];
}
-(TableViewController *)getRootViewController{
    return [((UINavigationController *) [((UITabBarController *)self.window.rootViewController).viewControllers objectAtIndex:0]).viewControllers objectAtIndex:0];
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   // UIImage *image =
 //   UIColor *background = [[UIColor alloc] initWithPatternImage:imageNamed:@"<#string#>"];
//    self.window.backgroundColor = background;
    // Override point for customization after application launch.
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"watcher_watchlist"]){
        _shortList=[userDefaults objectForKey:@"watcher_watchlist"];
    
        [Appirater appLaunched];
    
    }
    [Setting sharedInstance].settings=[[NSMutableDictionary alloc] initWithDictionary:[userDefaults objectForKey:@"watcherSettings"]];
    if ([Setting sharedInstance].settings==nil){
        [Setting sharedInstance].settings=[[NSMutableDictionary alloc]init];
    }
    if ([[Setting sharedInstance].settings objectForKey:@"backgroundImage"]==nil){
        [[Setting sharedInstance].settings setObject:@"light blue wallpaper hd.jpg" forKey:@"backgroundImage"];
    }
    //self.window.backgroundColor= [UIColor whiteColor];
    self.window.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[[Setting sharedInstance].settings objectForKey:@"backgroundImage"]]];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //UIViewController* rootview=self.window.rootViewController;
    TableViewController *mainController=[self getRootViewController];
    /*for (id obj in [mainController.watchList objectAtIndex:0]){
        NSLog(@"%@",NSStringFromClass([obj  class]));
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:mainController.watchList] forKey:@"watcher_watchlist"];*/
    [[NSUserDefaults standardUserDefaults]setObject:[mainController generateShortList] forKey:@"watcher_watchlist"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    Setting *setting1=[Setting sharedInstance];
    NSMutableDictionary* setting=setting1.settings;
    [[NSUserDefaults standardUserDefaults]setObject:setting forKey:@"watcherSettings"];

}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    TableViewController *mainController=[self getRootViewController];
    [mainController refreshWatchList];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [Setting sharedInstance].settings=[[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"watcherSettings"]];
    if ([[[Setting sharedInstance].settings objectForKey:@"notificationEnabled"] isEqualToValue:@NO]){
        return;
    }
    TableViewController *mainController=[self getRootViewController];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSDate *now=[NSDate date];
    localNotification.fireDate = now;
    
    if ([mainController refreshWatchList]){
        NSString *message;
        if (mainController.changedList.count>1){
            message=@"The following sections are now open:\n";
        } else {
            message=@"The following section is now open:\n";
        }
        for (NSString *shortDesciption in mainController.changedList){
            message=[message stringByAppendingString:shortDesciption];
            message=[message stringByAppendingString:@"\n"];
        }
        localNotification.alertBody=message;
        localNotification.soundName=UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    } else {
        //localNotification.alertBody=@"Nothing has changed";
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if ([self iOS_7]){
       [[UIApplication sharedApplication]setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    }
    return YES;
}

-(BOOL)iOS_7 {
    NSString *osVersion = @"7.0";
    NSString *currOsVersion = [[UIDevice currentDevice] systemVersion];
    return [currOsVersion compare:osVersion options:NSNumericSearch] == NSOrderedDescending;
}

@end
