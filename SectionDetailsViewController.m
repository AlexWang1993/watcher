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

@interface SectionDetailsViewController ()

@end


@implementation SectionDetailsViewController


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
    self.subjectLabel.text=[NSString stringWithFormat:@"%@ %@",[self.info objectForKey:@"subject"],[self.info objectForKey:@"catalog_number"]];
    self.sectionLabel.text=[self.info objectForKey:@"section"];

   self.professorLabel.text= [[[[self.info objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"instructors"] objectAtIndex:0];
    
    self.locationLabel.text=[NSString stringWithFormat:@"Location:%@%@",
                             [[[[self.info objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"location"]   objectForKey:@"building"],
                             [[[[self.info objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"location"]   objectForKey:@"room"]
                             ];
    
    
    self.titleLabel.text=[self.info objectForKey:@"title"];
    self.capacityLabel.text=[NSString stringWithFormat:@"Enrollment Capacity: %@", [self.info objectForKey:@"enrollment_capacity"]];
    self.totalEnrolledLabel.text=[NSString stringWithFormat:@"Total Enrolled: %@", [self.info objectForKey:@"enrollment_total"]];
    self.timeLabel.text=[NSString stringWithFormat:@"%@ %@ - %@",
                         [[[[self.info objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"date"] objectForKey:@"weekdays"],
                         [[[[self.info objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"date"] objectForKey:@"start_time"],
                         [[[[self.info objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"date"] objectForKey:@"end_time"]];
    
    
    
    //rate my prof starts
    
    NSString *profName= [[[[self.info objectForKey:@"classes"] objectAtIndex:0] objectForKey:@"instructors"] objectAtIndex:0];
    
    NSString *waterlooProf = @"Users/alexwang/Documents/tests/watcherhelen/watcher/ratemyprof/waterloo_prof.txt";
    NSString *fileContentsString = [NSString stringWithContentsOfFile:waterlooProf encoding:NSUTF8StringEncoding error:nil];
    if (fileContentsString==nil) {
        self.descriptionLabel.text=@"Error reading file";
    }
    NSRange result = [fileContentsString rangeOfString:profName options:NSLiteralSearch];
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
<<<<<<< HEAD
        self.descriptionLabel.text =[NSString stringWithFormat:@"%@ %@",avgRate,easiness];
        self.descriptionText.text=[NSString stringWithFormat:@"the information from ratemyprof is %@ %@",avgRate,easiness];
=======
        self.descriptionLabel.text =[NSString stringWithFormat:@"Information from RateMyProf:"];
        self.avgRateLabel.text = [NSString stringWithFormat:@"Average Rating:%@",avgRate];
        self.easinessLabel.text=[NSString stringWithFormat:@"Easiness:%@",easiness];
>>>>>>> 483db513a0923673de01506eb0d623db24b61ac7
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
















