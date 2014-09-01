//
//  CommonViewController.h
//  watcher
//
//  Created by Alex Wang on 7/22/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface CommonViewController : UIViewController<UINavigationControllerDelegate,UIAlertViewDelegate>


-(BOOL)hasNetwork;


//About this app

@property (strong,nonatomic) IBOutlet UIImageView *alexPic;
@property (strong,nonatomic) IBOutlet UIImageView *helenPic;

@property (strong,nonatomic) IBOutlet UILabel *aboutTitle;
@property (strong,nonatomic) IBOutlet UILabel *alexEmail;
@property (strong,nonatomic) IBOutlet UILabel *helenEmail;
@property (strong,nonatomic) IBOutlet UILabel *alexName;
@property (strong,nonatomic) IBOutlet UILabel *helenName;


@end
