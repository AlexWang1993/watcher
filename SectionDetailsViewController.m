//
//  SectionDetailsViewController.m
//  watcher
//
//  Created by Alex Wang on 2/10/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "SectionDetailsViewController.h"
//#include "staticData.h"
#import "search.h"
#import "UILabel+CustomFont.h"
#import "DBManager.h"

@interface SectionDetailsViewController ()

@end


@implementation SectionDetailsViewController

@synthesize allTextLabel;

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
    [self performSelectorInBackground:@selector(loadHotness) withObject:nil];
    [self.locationLabel setFont:[UIFont fontWithName:@"Quicksand" size:14.0f]];
    _setting=[Setting sharedInstance];
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"light blue wallpaper hd.jpg"]];
    self.subjectLabel.text=[NSString stringWithFormat:@"%@ %@",[self.info objectForKey:@"subject"],[self.info objectForKey:@"catalog_number"]];
    [self.subjectLabel setCustomFont];
    self.sectionLabel.text=[self.info objectForKey:@"section"];
    [self.sectionLabel setCustomFont];
    
    self.termLabel.text = [NSString stringWithFormat:@"Term %@",[_info objectForKey:@"term"]];
    [self.termLabel setCustomFont];
    self.professorLabel.text= ([[[[self.info objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"instructors"] count]>0)?[[[[self.info objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"instructors"] objectAtIndex:0]:NULL;
    
    self.locationLabel.text=[NSString stringWithFormat:@"%@%@",
                             [[[[self.info objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"location"]   objectForKey:@"building"],
                             [[[[self.info objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"location"]   objectForKey:@"room"]
                             ];
    _parent.location = self.locationLabel.text;
    self.titleLabel.text=[self.info objectForKey:@"title"];
    self.capacityLabel.text=[NSString stringWithFormat:@"%@", [self.info objectForKey:@"enrollment_capacity"]];
    self.totalEnrolledLabel.text=[NSString stringWithFormat:@"%@", [self.info objectForKey:@"enrollment_total"]];
    self.timeLabel.text=[NSString stringWithFormat:@"%@ %@ - %@",
                         [[[[self.info objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"date"] objectForKey:@"weekdays"],
                         [[[[self.info objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"date"] objectForKey:@"start_time"],
                         [[[[self.info objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"date"] objectForKey:@"end_time"]];
    
    [self.subjectLabel setCustomFont];
    [self.sectionLabel setCustomFont];
    [self.professorLabel setCustomFont];
    self.locationLabel.font=[UIFont fontWithName:@"Quicksand" size:17.0];
    
    [self.titleLabel setCustomFont];
    [self.capacityLabel setCustomFont];
    [self.totalEnrolledLabel setCustomFont];
    [self.timeLabel setCustomFont];
    [self.descriptionLabel setCustomFont];
    [self.avgRateLabel setCustomFont];
    [self.easinessLabel setCustomFont];

    //rate my prof starts
    if (!self.professorLabel.text) {
        self.descriptionLabel.hidden=true;
        self.avgRateLabel.hidden=true;
        self.easinessLabel.hidden=true;
        return ;
    }
    NSString *profName= [[[[self.info objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"instructors"] objectAtIndex:0];
    
    NSString *waterlooProf = [[NSBundle mainBundle] pathForResource:@"waterloo_prof" ofType:@"txt"]
    ;
    NSString *fileContentsString = [NSString stringWithContentsOfFile:waterlooProf encoding:NSUTF8StringEncoding error:nil];
    if (fileContentsString==nil) {
        self.descriptionLabel.text=@"Error reading file";
    }
    NSRange result = [fileContentsString rangeOfString:profName options:NSLiteralSearch];
    [(UIScrollView*)self.view setContentSize:CGSizeMake(320, 500)];
//    [(UIScrollView*)self.view setContentSize:self.view.bounds.size];
//    contentSize = self.view.bounds.size;
    if (result.location == NSNotFound) {
        self.descriptionLabel.text = @"Not on rate my prof";
    }
    else  {
        NSRange lineRange = [fileContentsString lineRangeForRange:result];
        NSString *line = [fileContentsString substringWithRange:lineRange];
        
        //get substring for avg rate and easiness
        
        NSRange avgRateRange = [line rangeOfString:@"Avg" options:NSLiteralSearch];
        NSRange easinessRange = [line rangeOfString:@"Easy" options:NSLiteralSearch];
        avgRateRange.location = avgRateRange.location+4;
        easinessRange.location = easinessRange.location+5;
        easinessRange.length = 3;
        NSString *avgRate = [line substringWithRange:avgRateRange];
        NSString *easiness = [line substringWithRange:easinessRange];
        if ([avgRate isEqualToString:@"&nb"]) {
            avgRate = @"N/A";
        }
        if ([easiness isEqualToString:@"&nb"]){
            easiness =@"N/A";
        }
        self.descriptionLabel.text =[NSString stringWithFormat:@"Information from RateMyProf:"];
        self.avgRateLabel.text = [NSString stringWithFormat:@"Prof Average Rating: %@",avgRate];
        self.easinessLabel.text=[NSString stringWithFormat:@"Prof Easiness: %@",easiness];
        self.descriptionLabel.hidden=false;
        self.avgRateLabel.hidden=false;
        self.easinessLabel.hidden=false;
        self.descriptionLabel.hidden = true;

       /*
        self.subjectLabel.hidden = true;
        self.sectionLabel.hidden = true;
        self.professorLabel.hidden = true;
        self.timeLabel.hidden = true;
        self.locationLabel.hidden = true;
        self.totalEnrolledLabel.hidden = true;
        self.descriptionLabel.hidden = true;
        self.avgRateLabel.hidden = true;
        self.easinessLabel.hidden = true;*/
    }
  /*  allTextLabel.lineBreakMode = YES;
    
    allTextLabel.numberOfLines= 0;

    allTextLabel.text = [NSString stringWithFormat:@"%@",_subjectLabel.text];
   // allTextLabel.text = [NSString stringWithFormat:@"%@\n%@       %@\n%@\n%@\n%@\n%@\n%@\n%@\n%@",_subjectLabel.text,_sectionLabel.text,_professorLabel.text,_timeLabel.text,_locationLabel.text,_capacityLabel.text,_totalEnrolledLabel.text,_descriptionLabel,_avgRateLabel.text,_easinessLabel.text];
    [allTextLabel setCustomFont];
    
   */
    allTextLabel.hidden = true;
}

-(void)viewWillAppear:(BOOL)animated{
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[_setting.settings objectForKey:@"backgroundImage"]]];
//        self.view.alpha = 0.8f;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadHotness{
    NSArray* arr = [[_info objectForKey:@"section"] componentsSeparatedByString:@" "];
    NSString* type = arr[0];
    NSString* section = arr[1];
    NSNumber* hotness = [DBManager getHotnessForSubject:[_info objectForKey:@"subject"] Number:[_info objectForKey:@"catalog_number"] Type:type Section:section Term:[_info objectForKey:@"term"]];
    NSString* rating;
    switch ([hotness integerValue]) {
        case 2:
        case 3:
        rating = @"popular";
        break;
        case 4:
        case 5:
        rating = @"very popular";
        break;
        case 6:
        case 7:
        case 8:
        rating = @"extremely hot";
        break;
        default:
        rating = @"Not popular";
    }
    self.hotnessLabel.text = rating;
    UIColor *glowing = [UIColor colorWithRed:176.0/256.0 green:23.0/256.0 blue:31.0/256.0 alpha:1.0f];
    self.hotnessLabel.layer.shadowColor = [glowing CGColor];
    self.hotnessLabel.layer.shadowRadius = 8.0f;
    self.hotnessLabel.layer.shadowOpacity = 0.9;
    self.hotnessLabel.shadowOffset = CGSizeZero;
    self.hotnessLabel.layer.masksToBounds = NO;
    [self.hotnessLabel setCustomFont];
}

@end
















