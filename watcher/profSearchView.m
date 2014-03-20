//
//  profSearchView.m
//  watcher
//
//  Created by Helen Jiang on 3/2/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "profSearchView.h"
#import "profDetailViewViewController.h"

@interface profSearchView ()

@end

@implementation profSearchView

@synthesize profLastName=_profLastName;
@synthesize profFirstName=_profFirstName;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)editingDidEnd:(id)sender {
    [_profFirstName resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"searchProf"]){
        profDetailViewViewController *detail=[segue destinationViewController];
        [profDetailViewViewController class];
        NSString *name = [NSString stringWithFormat:@"%@,%@",_profLastName.text,_profFirstName.text];
        detail.profName = name;
    }
}

- (IBAction)goButton:(id)sender {
    [_profLastName resignFirstResponder];
    [_profFirstName resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
