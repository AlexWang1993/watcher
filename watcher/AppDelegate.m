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


@synthesize didRefresh;


-(Setting *)getSetting{
    return [Setting sharedInstance];
}
-(TableViewController *)getRootViewController{
    return [((UINavigationController *) [((UITabBarController *)self.window.rootViewController).viewControllers objectAtIndex:0]).viewControllers objectAtIndex:0];
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:NULL forKey:@"a"];
    if ([userDefaults objectForKey:@"watcher_watchlist"]){
        _shortList=[userDefaults objectForKey:@"watcher_watchlist"];
    }
    [Appirater appLaunched];
    if ([userDefaults objectForKey:@"watcher_subjectlist"]){
        _subjectList=[userDefaults objectForKey:@"watcher_subjectlist"];
    }
    [Setting sharedInstance].settings=[[NSMutableDictionary alloc] initWithDictionary:[userDefaults objectForKey:@"watcherSettings"]];
    if ([Setting sharedInstance].settings==nil){
        [Setting sharedInstance].settings=[[NSMutableDictionary alloc]init];
    }
    UIColor* uicolor = [UIColor colorWithRed:255.0/255 green:1.0f blue:(9*16+9.0f)/255 alpha:1];
    if ([[Setting sharedInstance].settings objectForKey:@"color"]==nil){
        [[Setting sharedInstance].settings setObject:[self UIColorToArray:[UIColor colorWithRed:255.0/255 green:1.0f blue:(9*16+9.0f)/255 alpha:1]] forKey:@"color"];
    }
    if ([[Setting sharedInstance].settings objectForKey:@"tabBarColor"]==nil) {
        [[Setting sharedInstance].settings setObject:[self UIColorToArray:[UIColor colorWithRed:149.0/256 green:196.0/256 blue:219.0/256 alpha:1]] forKey:@"tabBarColor"];
    }
    if ([[Setting sharedInstance].settings objectForKey:@"tabBarHighLightColor"]==nil) {
        [[Setting sharedInstance].settings setObject:[self UIColorToArray:[UIColor colorWithRed:206.0/256 green:232.0/256 blue:245.0/256 alpha:1]] forKey:@"tabBarHighLightColor"];
    }
    
    
    [self refreshBackground];
    
   // [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:20.0/256 green:68.0/256 blue:106.0/256 alpha:1]];
    
    //tab bar color yellow mode
   //  [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:149.0/256 green:196.0/256 blue:219.0/256 alpha:1]];

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
    
    didRefresh=NO;
    [[NSUserDefaults standardUserDefaults]setObject:[mainController generateJSONs] forKey:@"watcher_watchlist"];
    [[NSUserDefaults standardUserDefaults]setObject:[mainController subjectList] forKey:@"watcher_subjectlist"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    didRefresh=YES;
    
    Setting *setting1=[Setting sharedInstance];
    NSMutableDictionary* setting=setting1.settings;
    [[NSUserDefaults standardUserDefaults]setObject:setting forKey:@"watcherSettings"];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    TableViewController *mainController=[self getRootViewController];
    [mainController refreshWatchListAsync];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [Setting sharedInstance].settings=[[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"watcherSettings"]];
    NSLog(@"asdf");
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


-(void)refreshBackground{
//        self.window.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[[Setting sharedInstance].settings objectForKey:@"backgroundImage"]]];
  
    //green
   // self.window.backgroundColor=[UIColor colorWithRed:174.0/256 green:221.0/256 blue:129.0/256 alpha:1];
    
    //pink
  //  self.window.backgroundColor=[UIColor colorWithRed:252.0/256 green:157.0/256 blue:154.0/256 alpha:1];

    
    //light blue theme2
   // self.window.backgroundColor=[UIColor colorWithRed:164.0/256 green:221.0/256 blue:237.0/256 alpha:1];
    //self.window.backgroundColor=[UIColor whiteColor];
    
    //original yellow
    UIColor *myColor = [self arrayToUIColor:[[Setting sharedInstance].settings objectForKey:@"color"]];

    self.window.backgroundColor = myColor;
    
    UIColor *tabBarColor =[self arrayToUIColor:[[Setting sharedInstance].settings objectForKey:@"tabBarColor"]];
    
    [[UITabBar appearance] setBarTintColor:tabBarColor];
    
    UIColor *tabBarHighLightColor =[self arrayToUIColor:[[Setting sharedInstance].settings objectForKey:@"tabBarHighLightColor"]];
    
    [[UITabBar appearance] setSelectedImageTintColor:tabBarHighLightColor];
//    self.window.backgroundColor=[UIColor colorWithRed:255.0/255 green:1.0f blue:(9*16+9.0f)/255 alpha:1];
}

-(UIColor*)arrayToUIColor:(NSArray*)arr{
    return [[UIColor alloc]initWithRed:[arr[0] floatValue] green:[arr[1] floatValue] blue:[arr[2] floatValue] alpha:[arr[3] floatValue]];
}

-(NSArray *)UIColorToArray:(UIColor*)color{
    CGFloat * arr=CGColorGetComponents(color.CGColor);
    return [[NSArray alloc]initWithObjects:[NSNumber numberWithFloat:arr[0]],
            [NSNumber numberWithFloat:arr[1]],
            [NSNumber numberWithFloat:arr[2]],
            [NSNumber numberWithFloat:arr[3]],nil];
}


@end
