    //
//  ConditionTimeViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionTimeViewController.h"


@interface ConditionTimeViewController()
-(void) addWeekdaySelection;
-(void) updateLabelColors;
-(int) indexForDay:(NSString* ) day;
@end

@implementation ConditionTimeViewController

static bool selected[7];

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    //if ((self = [super initWithNibNameAndType:nibNameOrNil bundle:nibBundleOrNil type:@"timed"])){ 
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])){ 
       
        for (int i = 0; i < 7; i++){
            selected[i] = false;
        }
        
        [self addWeekdaySelection];
        
	}
    return self;
}


-(void) addWeekdaySelection{
    
    
    NSArray *daysselected = [[[Catalogue sharedCatalogue] conditionArguments] objectForKey:@"daysofweek"];
    
    
    
    days = [[[NSArray alloc] initWithObjects:@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun", nil] retain];
    int index =0;
    
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    
    for (NSString *day in days){
        
        int xval = 130  + (index % 3) * 50;
        int yval = 170 + (index / 3) * 30;
        index++;
        UILabel* dow = [[UILabel alloc] initWithFrame:CGRectMake(xval,yval,50,40)];
        dow.textColor = [UIColor blackColor];
        dow.textAlignment = UITextAlignmentCenter;
        dow.backgroundColor = [UIColor clearColor];
        dow.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:18.0];
        dow.text = day;
        [tmp addObject:dow];
        [self.view addSubview:dow];
    }
   
    dayLabels = [[[NSArray alloc] initWithArray:tmp] retain];
    
   
    if (daysselected != nil && [daysselected count] > 0){
        for (NSString *day in daysselected){
            selected[[self indexForDay:day]] = true;
        }
        [self updateLabelColors];
    }
}


-(int) indexForDay:(NSString* ) day{
    int index = 0;
    for (NSString *aday in days){
        if ([day isEqualToString:aday])
            return index;
        index++;
    }
    return -1;
}

-(void) updateValues:(int)index{
    
    selected[index] = !selected[index];
    
    NSMutableArray *daysofweek = [[NSMutableArray alloc] init];
    for (int i =0; i < 7; i++){
        if (selected[i])
            [daysofweek addObject:[days objectAtIndex:i]];
    }
    if ([daysofweek count] > 0){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:daysofweek forKey:@"daysofweek"];
        [[Catalogue sharedCatalogue] setConditionArguments:dict];
    }    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
	
    bool labeltouched = false;
    int index = 0;
    for (UILabel *dow in dayLabels){
        if (CGRectContainsPoint(dow.frame, touchLocation)){
            labeltouched = true;
            [self updateValues:index];
            
        }
        index++;
    }
    
    [self updateLabelColors];
    
    if (!labeltouched)
        [super touchesBegan:touches withEvent:event];
}

-(void) updateLabelColors{
    for (int i =0; i < 7; i++){
        UILabel* dow = [dayLabels objectAtIndex:i];
        dow.textColor = selected[i] ? [UIColor redColor] : [UIColor blackColor];
    }
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
        // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    [days release];
    [dayLabels release];
}


@end
