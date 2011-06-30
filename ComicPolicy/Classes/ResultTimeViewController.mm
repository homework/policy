    //
//  ResultTimeViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 05/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultTimeViewController.h"
#import "MonitorTimeView.h"
#import "NetworkManager.h"
#import "MonitorDataSource.h"

@interface ResultTimeViewController()
-(void) rotatePinkCog:(NSString *) animationID finished:(NSNumber*)finished context:(void*)context;
-(void) rotateYellowCog:(NSString *) animationID finished:(NSNumber*)finished context:(void*)context;
-(void) rotateRedCog:(NSString *) animationID finished:(NSNumber*)finished context:(void*)context;
-(void) rotateActivityMonitor:(activity) a;
-(void) resetActivity;
@end

@implementation ResultTimeViewController

//@synthesize monitorTimeView;
static BOOL pinkflag = YES;
static BOOL yellowflag = NO;
static BOOL redflag = YES;


float angle = 0.1;
static activity currentActivity = NOREADING;

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
    
    
    NSLog(@"LOADING VIEW>>>>>>>>>>>>");
    //self.testImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok.png"]];
    //[self.view addSubview:testImage];
    //currentMonitorScene = @"resulttime.png";
    CGRect aframe = CGRectMake(0,0,897,301);
	UIView *rootView = [[UIView alloc] initWithFrame:aframe];	
	self.view = rootView;
	[rootView release];
    //MonitorTimeView *mview = [[MonitorTimeView alloc] initWithFrame: CGRectMake(0,0,497,301)];
	//self.monitorTimeView = mview;
    //[mview release];
    monitorTimeView = [[MonitorTimeView alloc] initWithFrame: CGRectMake(0,0,497,301)];
    [self.view addSubview: monitorTimeView];
    //[monitorTimeView release];
    //[self rotatePinkCog:nil finished:nil context:nil];
    //[self rotateYellowCog:nil finished:nil context:nil];
    //[self rotateRedCog:nil finished:nil context:nil];
    
    monitorTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 
                                                     target:self 
                                                   selector:@selector(requestData:) //addSite:
                                                   userInfo:nil 
                                                    repeats:YES];
    

    [self resetActivity];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newActivityData:) name:@"newActivityData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectDeviceChange:) name:@"subjectDeviceChange" object:nil];
}

-(void) subjectDeviceChange:(NSNotification *) notification{
    NSLog(@"subject device CHANGED!!");
    [self resetActivity];
}

-(void) resetActivity{
    NSLog(@"RESETTING ACTIVITY...");
    currentActivity = NOREADING;
    monitorTimeView.smallpointer.transform = CGAffineTransformMakeRotation(0);
}

-(void) requestData:(NSTimer *) timer{
    NSString * subject = [[Catalogue sharedCatalogue] currentSubjectDevice];
   // NSLog(@"requesting data for %@", subject);
    NSString *rootURL  = [[NetworkManager sharedManager] rootURL];
    NSString *strurl = [NSString stringWithFormat:@"%@/monitor/activity/%@", rootURL, subject];
    [[MonitorDataSource sharedDatasource] requestURL: strurl callback:@"newActivityData"];
}

-(void) newActivityData:(NSNotification *) notification{
    NSDictionary *data = [notification userInfo];
    NSString *responseString = [data objectForKey:@"data"];    
       NSLog(@"got response %@", responseString);
    
   // [UIView beginAnimations:nil context:nil];
   // [UIView setAnimationDuration:2.0];
    //[UIView setAnimationDelegate:self];
    //monitorTimeView.smallpointer.transform = CGAffineTransformMakeRotation(angle);
    //[UIView commitAnimations];
    //angle += 0.1;
    if ([responseString isEqualToString:@"0"]){
        NSLog(@"setting to inactive...");
        [self rotateActivityMonitor:INACTIVE];
    }else{
          NSLog(@"setting to active...");
        [self rotateActivityMonitor:ACTIVE];
    }
    //SBJsonParser *jsonParser = [SBJsonParser new];
}

-(void) rotateActivityMonitor:(activity) latestActivity{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDelegate:self];

    if (latestActivity == INACTIVE){
        NSLog(@"latest activity is inactive..");
        if (currentActivity == NOREADING){
            monitorTimeView.smallpointer.transform = CGAffineTransformMakeRotation(M_PI/4);
        }else if (currentActivity == ACTIVE){
            NSLog(@"rotation to PI/4");
             monitorTimeView.smallpointer.transform = CGAffineTransformMakeRotation(M_PI/4);
        }
        currentActivity = INACTIVE;
    }else{
        if (currentActivity == NOREADING){
            monitorTimeView.smallpointer.transform = CGAffineTransformMakeRotation(-M_PI/4);
            
        }else if (currentActivity == INACTIVE){
            NSLog(@"last activity was inactive so ROTATTING TO -M_PI/4");
             monitorTimeView.smallpointer.transform = CGAffineTransformMakeRotation(-M_PI/4);
        }
        currentActivity = ACTIVE;
    }
    [UIView commitAnimations];
}

-(void) rotatePinkCog:(NSString *) animationID finished:(NSNumber*)finished context:(void*)context{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:5.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(rotatePinkCog:finished:context:)];
    if (pinkflag){
        monitorTimeView.pinkcog.transform = CGAffineTransformMakeRotation(M_PI);
        pinkflag = NO;
    }
    else{
        monitorTimeView.pinkcog.transform = CGAffineTransformMakeRotation(0);
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
        monitorTimeView.yellowcog.transform = CGAffineTransformMakeRotation(M_PI);
        yellowflag = NO;
    }
    else{
        monitorTimeView.yellowcog.transform = CGAffineTransformMakeRotation(0);
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
        monitorTimeView.redcog.transform = CGAffineTransformMakeRotation(M_PI);
        redflag = NO;
    }
    else{
        monitorTimeView.redcog.transform = CGAffineTransformMakeRotation(0);
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
    
    NSLog(@"view unloaded..........................");
    [super viewDidUnload];
    monitorView = nil;
    [monitorTimeView release];
    [monitorTimer invalidate], monitorTimer = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
