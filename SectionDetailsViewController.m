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



/*load api stuff


-(void)loadDetails{
    NSString *subject = [self.info objectForKey:@"subject"];
    NSString *number = [self.info objectForKey:@"catalog_number"];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/courses/%@/%@/schedule.json?key=%@",subject, number,unlimitedAPIKey]];
    NSError *error=nil;
    NSData *JSONData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    NSArray *data = [results objectForKey:@"enrollment_capacity"];
    for (NSDictionary *sec in data) {
        <#statements#>
    }
} */

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
	// Do any additional setup after loading the view.
}

/*- (void)searchRateMyProf(NSString keyword){
    NSString *waterlooProf = @"waterloo_prof.txt";
    NSFileHandle *fin;
    NSData *buffer;
    //open it for reading
    fin = [NSFileHandle fileHandleForReadingAtPath:waterlooProf];
    
}*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
















