//
//  profSearchView.m
//  watcher
//
//  Created by Helen Jiang on 3/2/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "profSearchView.h"
#import "profDetailViewViewController.h"
#import "NSString+Levenshtein.h"
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

- (BOOL)containsLastName:(NSString *)lName FirstName:(NSString *)fName{
    return [_profNameList containsObject:[NSString stringWithFormat:@"%@,%@",lName,fName]];
}

- (void)setLabelTags:(NSArray*)myLabels{
    int i=0;
    for (UILabel* label in myLabels){
        label.tag=i;
        i++;
    }
}
- (void)changeLabelState:(BOOL)state Labels:(NSArray *)myLabels{
    for (UILabel* label in myLabels){
        label.hidden=state;
    }
    self.info.hidden=state;
}
    
-(void)addGestureRecognizer:(NSArray*)myLabels{
    for (UILabel* label in myLabels){
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [label addGestureRecognizer:singleTap];
        [label setUserInteractionEnabled:YES];
    }
}
-(void)handleSingleTap:(UITapGestureRecognizer*) singleTap{
    [self performSegueWithIdentifier:@"goToProf" sender:singleTap.view];
}
- (void)giveRecommendation{
    NSString *profName=[NSString stringWithFormat:@"%@,%@",self.profLastName.text,self.profFirstName.text];
    _sortedArray=[_profNameList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger dis1=[(NSString*)obj1 compareWithWord:profName matchGain:3 missingCost:1];
        NSInteger dis2=[(NSString*)obj2 compareWithWord:profName matchGain:3 missingCost:1];
        return (dis1<dis2)?NSOrderedAscending:NSOrderedDescending;
    }];
    _recommend1.text=[_sortedArray objectAtIndex:0];
    _recommend2.text=[_sortedArray objectAtIndex:1];
    _recommend3.text=[_sortedArray objectAtIndex:2];
    _recommend4.text=[_sortedArray objectAtIndex:3];
    _recommend5.text=[_sortedArray objectAtIndex:4];
    [self changeLabelState:NO Labels:_myLabels];
    
    
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"searchProf"]){
        if ([self containsLastName:self.profLastName.text FirstName:self.profFirstName.text]){
            [self changeLabelState:YES Labels:_myLabels];
            return YES;
        } else {
            [self giveRecommendation];
            return NO;
        }
        
    } else if ([identifier isEqualToString:@"goToProf"]){
        if (self.recommend1.hidden){
            return NO;
        }
        return YES;
    }
    return NO;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"searchProf"]){
        profDetailViewViewController *detail=[segue destinationViewController];
        [profDetailViewViewController class];
        NSString *name = [NSString stringWithFormat:@"%@,%@",_profLastName.text,_profFirstName.text];
        detail.profName = name;
    } else if ([segue.identifier isEqualToString:@"goToProf"]){
        profDetailViewViewController *dest=[segue destinationViewController];
        NSString *name=[_sortedArray objectAtIndex:[sender tag]];
        dest.profName=name;
    }
}

- (IBAction)goButton:(id)sender {
    [_profLastName resignFirstResponder];
    [_profFirstName resignFirstResponder];
}
- (void)loadProfNameList{
    NSString* nameFile=[[NSBundle mainBundle] pathForResource:@"prof_name" ofType:@"txt"];
    NSString* fileContents=[NSString stringWithContentsOfFile:nameFile encoding:NSUTF8StringEncoding error:nil];
    _profNameList=[fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _myLabels=[NSArray arrayWithObjects:self.recommend1,self.recommend2,self.recommend3,self.recommend4,self.recommend5, nil];
    [self loadProfNameList];
    [self changeLabelState:YES Labels:_myLabels];
    [self setLabelTags:_myLabels];
    [self addGestureRecognizer:_myLabels];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
