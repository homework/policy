    //
//  ResultTimeViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 05/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultTimeViewController.h"
#import "MonitorTimeView.h"

@interface ResultTimeViewController()
-(void) rotatePinkCog:(NSString *) animationID finished:(NSNumber*)finished context:(void*)context;
-(void) rotateYellowCog:(NSString *) animationID finished:(NSNumber*)finished context:(void*)context;
-(void) rotateRedCog:(NSString *) animationID finished:(NSNumber*)finished context:(void*)context;
@end

@implementation ResultTimeViewController

@synthesize monitorTimeView;
static BOOL pinkflag = YES;
static BOOL yellowflag = NO;
static BOOL redflag = YES;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)loadView
{
    //self.testImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok.png"]];
    //[self.view addSubview:testImage];
    //currentMonitorScene = @"resulttime.png";
    CGRect aframe = CGRectMake(0,0,897,301);
	UIView *rootView = [[UIView alloc] initWithFrame:aframe];	
	self.view = rootView;
	[rootView release];
    MonitorTimeView *mview = [[MonitorTimeView alloc] initWithFrame: CGRectMake(0,0,497,301)];
	self.monitorTimeView = mview;
    [mview release];
    [self.view addSubview: monitorTimeView];
    [self rotatePinkCog:nil finished:nil context:nil];
    [self rotateYellowCog:nil finished:nil context:nil];
    [self rotateRedCog:nil finished:nil context:nil];
}

-(void) rotatePinkCog:(NSString *) animationID finished:(NSNumber*)finished context:(void*)context{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:5.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(rotatePinkCog:finished:context:)];
    if (pinkflag){
        self.monitorTimeView.pinkcog.transform = CGAffineTransformMakeRotation(M_PI);
        pinkflag = NO;
    }
    else{
        self.monitorTimeView.pinkcog.transform = CGAffineTransformMakeRotation(0);
        pinkflag = YES;
    }
    [UIView commitAnimations];
}

-(void) rotateYellowCog:(NSString *) animationID finished:(NSNumber*)finished context:(void*)context{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:5.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(rotateYellowCog:finished:context:)];
    if (yellowflag){
        self.monitorTimeView.yellowcog.transform = CGAffineTransformMakeRotation(M_PI);
        yellowflag = NO;
    }
    else{
        self.monitorTimeView.yellowcog.transform = CGAffineTransformMakeRotation(0);
        yellowflag = YES;
    }
    [UIView commitAnimations];
}

-(void) rotateRedCog:(NSString *) animationID finished:(NSNumber*)finished context:(void*)context{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:5.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(rotateRedCog:finished:context:)];
    if (redflag){
        self.monitorTimeView.redcog.transform = CGAffineTransformMakeRotation(M_PI);
        redflag = NO;
    }
    else{
        self.monitorTimeView.redcog.transform = CGAffineTransformMakeRotation(0);
        redflag = YES;
    }
    [UIView commitAnimations];
}
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
    [monitorView release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
