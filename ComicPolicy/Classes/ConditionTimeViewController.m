    //
//  ConditionTimeViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionTimeViewController.h"
#import "DayOfWeekView.h"

@interface ConditionTimeViewController()
-(void) addWeekdaySelection;
@end

@implementation ConditionTimeViewController

static bool selected[7];

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    //if ((self = [super initWithNibNameAndType:nibNameOrNil bundle:nibBundleOrNil] type:@"timed"])){ 
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])){ 
       
        for (int i = 0; i < 7; i++){
            selected[i] = false;
        }
        
        [self addWeekdaySelection];
        
	}
    return self;
}


-(void) addWeekdaySelection{
    
    
    days = [[[NSArray alloc] initWithObjects:@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun", nil] retain];
    int index =0;
    
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    
    for (NSString *day in days){
        
        int xval = 130  + (index % 3) * 50;
        int yval = 170 + (index / 3) * 30;
        index++;
        //UILabel* dow = [[UILabel alloc] initWithFrameAndText:CGRectMake(xval,yval,50,40) text:day selected:YES];
        UILabel* dow = [[UILabel alloc] initWithFrame:CGRectMake(xval,yval,50,40)];
        dow.textColor = [UIColor blackColor];
        dow.textAlignment = UITextAlignmentCenter;
        dow.backgroundColor = [UIColor clearColor];
        dow.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:18.0];
        dow.text = day;
        [tmp addObject:dow];
        [self.view addSubview:dow];
    }
   
    dayLabels = [[NSArray alloc] initWithArray:tmp];
    
}


-(void) updateValues:(int)index{
    NSLog(@"tocuhed label %@", [days objectAtIndex:index]);
    selected[index] = !selected[index];
   
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
    
    if (!labeltouched)
        [super touchesBegan:touches withEvent:event];
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
}


@end
