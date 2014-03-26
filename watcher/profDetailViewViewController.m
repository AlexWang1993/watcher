//
//  profDetailViewViewController.m
//  watcher
//
//  Created by Helen Jiang on 3/2/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "profDetailViewViewController.h"

@interface profDetailViewViewController ()

@end

@implementation profDetailViewViewController

@synthesize profName=_profName;

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
    self.NameLabel.text = _profName;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"light blue wallpaper hd.jpg"]];
    
    NSString *waterlooProf = [[NSBundle mainBundle] pathForResource:@"waterloo_prof" ofType:@"txt"];
    NSLog(waterlooProf);
    NSString *fileContentsString = [NSString stringWithContentsOfFile:waterlooProf encoding:NSUTF8StringEncoding error:nil];
    if (fileContentsString==nil) {
        self.departmentLabel.text=@"Error reading file";
    }
    NSRange result = [fileContentsString rangeOfString:_profName options:NSLiteralSearch];
    if (result.location == NSNotFound) {
        self.departmentLabel.text = @"Not on rate my prof";
    }
    else  {
        NSRange lineRange = [fileContentsString lineRangeForRange:result];
        NSString *line = [fileContentsString substringWithRange:lineRange];
        

        NSRange avgRateRange = [line rangeOfString:@"Avg" options:NSLiteralSearch];
        avgRateRange.location = avgRateRange.location+4;
        NSString *avgRate = [line substringWithRange:avgRateRange];


        NSRange easinessRange = [line rangeOfString:@"Easy" options:NSLiteralSearch];
        easinessRange.location = easinessRange.location+5;
        easinessRange.length = 3;
        NSString *easiness = [line substringWithRange:easinessRange];

        
        NSRange hotnessRange = [line rangeOfString:@"Hot" options:NSLiteralSearch];
        hotnessRange.location = hotnessRange.location+4;
        NSString *hotness = [line substringWithRange:hotnessRange];
        if ([hotness isEqualToString:@"not"]){
            self.hotnessLabel.text = @"not hot :(";
        }
        else {
            self.hotnessLabel.text= @"HOT!";
        }
    
        NSRange departmentRange = [line rangeOfString:@"Dept" options:NSLiteralSearch];
        departmentRange.location = departmentRange.location+5;
        NSRange qualityRange = [line rangeOfString:@"Aver" options:NSLiteralSearch];
        departmentRange.length = qualityRange.location - departmentRange.location - 2;
        NSString *department = [line substringWithRange:departmentRange];
        self.departmentLabel.text = department;
        
        NSRange RatorRange = [line rangeOfString:@"Rate" options:NSLiteralSearch];
        qualityRange.location = qualityRange.location+5;
        qualityRange.length = RatorRange.location - qualityRange.location -2;
        NSString *quality = [line substringWithRange:qualityRange];
        if ([quality isEqualToString:@""]) {
            self.qualityLabel.text=@"no rating yet";
        }
        else{
            self.qualityLabel.text = quality;
        }
        
        if ([avgRate isEqualToString:@"&nb"]) {
            avgRate = @"N/A";
        }
        if ([easiness isEqualToString:@"&nb"]){
            easiness =@"N/A";
        }
        self.ratingLabel.text = [NSString stringWithFormat:@"Average Rating:%@",avgRate];
        self.easinessLabel.text=[NSString stringWithFormat:@"Easiness:%@",easiness];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
