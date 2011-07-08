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
-(void) rotateCogs:(NSString *) animationID finished:(NSNumber*)finished context:(void*)context;
-(void) rotateActivityMonitor:(activity) a;
-(void) resetActivity;
-(void) advancePointer;
-(void) advanceInside: (int) timeLeft;
-(void) advanceOutside:(int) timeLeft;
@end

@implementation ResultTimeViewController

//@synthesize monitorTimeView;
 

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
-(void)loadView {
}
*/

float DURATION      = 0;
float TIMEOUTSIDE   = 30;   //seconds
float TIMEINSIDE    = 10;   //seconds
float TIMEDELTA     = 3;    //seconds
BOOL inside = NO;

- (void)loadView
{
    
    
    rotateflag = YES;
    currentActivity = NOREADING;
  
    CGRect aframe = CGRectMake(0,0,897,301);
	UIView *rootView = [[UIView alloc] initWithFrame:aframe];	
	self.view = rootView;
	[rootView release];
    monitorTimeView = [[MonitorTimeView alloc] initWithFrame: CGRectMake(0,0,497,301)];
    [self.view addSubview: monitorTimeView];
    
    [self rotateCogs:nil finished:nil context:nil];
   
    monitorTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 
                                                     target:self 
                                                   selector:@selector(requestData:) //addSite:
                                                   userInfo:nil 
                                                    repeats:YES];
    

    [self resetActivity];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newActivityData:) name:@"newActivityData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectDeviceChange:) name:@"subjectDeviceChange" object:nil];
    
     //monitorTimeView.pointer.transform = CGAffineTransformMakeRotation(M_PI/4);
    monitorTimeView.pointer.transform = CGAffineTransformMakeRotation((3 * M_PI)/4);
}

-(void) subjectDeviceChange:(NSNotification *) notification{
    [self resetActivity];
}

-(void) resetActivity{
    currentActivity = NOREADING;
    monitorTimeView.smallpointer.transform = CGAffineTransformMakeRotation(0);
}

-(void) requestData:(NSTimer *) timer{
    
    [self advancePointer];
   
    //start = M_PI / 
    NSString * subject = [[Catalogue sharedCatalogue] currentSubjectDevice];
    NSString *rootURL  = [[NetworkManager sharedManager] rootURL];
    NSString *strurl = [NSString stringWithFormat:@"%@/monitor/activity/%@", rootURL, subject];
    [[MonitorDataSource sharedDatasource] requestURL: strurl callback:@"newActivityData"];
}

-(void) advancePointer{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDelegate:self];
    //float startInDegrees = ((3 * M_PI)/4) * ((float)180/M_PI);
    
    
    if (inside){
        int timeLeft = TIMEINSIDE - DURATION;       
        if (timeLeft <= 0){
            inside = FALSE;
            DURATION = 0;
            [self advanceOutside:(TIMEOUTSIDE - DURATION)];
        }else{
            [self advanceInside:timeLeft];
        }
    }else{
        
    
        int timeLeft = TIMEOUTSIDE - DURATION;
    
        if (timeLeft <= 0){
            inside = TRUE;
            DURATION = 0;
            [self advanceInside:(TIMEINSIDE - DURATION)];
        }
        else{
            [self advanceOutside:timeLeft];
        }
    }
    [UIView commitAnimations];
}

-(void) advanceInside: (int) timeLeft{
    float startInDegrees = (M_PI/4) * ((float)180/M_PI);
        
    NSLog(@"inside - time left is %d", timeLeft);
    float fraction = timeLeft/TIMEINSIDE;
    int degrees = (int) (startInDegrees + ((90) - (90 * fraction))) % 360;
    NSLog(@"inside - degrees = %d", degrees);
    monitorTimeView.pointer.transform = CGAffineTransformMakeRotation((float)degrees * (M_PI)/180);
    DURATION += 3;
}

-(void) advanceOutside: (int) timeLeft{
    float startInDegrees = ((3 * M_PI)/4) * ((float)180/M_PI);
    
    NSLog(@"outside - time left is %d", timeLeft);
    float fraction = timeLeft/TIMEOUTSIDE;
    int degrees = (int) (startInDegrees + ((270) - (270 * fraction))) % 360;
    NSLog(@"outside - degrees = %d", degrees);
    monitorTimeView.pointer.transform = CGAffineTransformMakeRotation((float)degrees * (M_PI)/180);
    DURATION += 3;
}

-(void) newActivityData:(NSNotification *) notification{
    NSDictionary *data = [notification userInfo];
    NSString *responseString = [data objectForKey:@"data"];    
    
    if ([responseString isEqualToString:@"0"]){
       
        [self rotateActivityMonitor:INACTIVE];
    }else{
        [self rotateActivityMonitor:ACTIVE];
    }
    //SBJsonParser *jsonParser = [SBJsonParser new];
}

-(void) rotateActivityMonitor:(activity) latestActivity{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDelegate:self];

    if (latestActivity == INACTIVE){
        if (currentActivity == NOREADING){
            monitorTimeView.smallpointer.transform = CGAffineTransformMakeRotation(M_PI/4);
        }else if (currentActivity == ACTIVE){
             monitorTimeView.smallpointer.transform = CGAffineTransformMakeRotation(M_PI/4);
        }
        currentActivity = INACTIVE;
    }else{
        if (currentActivity == NOREADING){
            monitorTimeView.smallpointer.transform = CGAffineTransformMakeRotation(-M_PI/4);
            
        }else if (currentActivity == INACTIVE){
             monitorTimeView.smallpointer.transform = CGAffineTransformMakeRotation(-M_PI/4);
        }
        currentActivity = ACTIVE;
    }
    [UIView commitAnimations];
}

-(void) rotateCogs:(NSString *) animationID finished:(NSNumber*)finished context:(void*)context{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:5.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(rotateCogs:finished:context:)];
    
    
    if (rotateflag){
        monitorTimeView.pinkcog.transform = CGAffineTransformMakeRotation(M_PI);
        monitorTimeView.yellowcog.transform = CGAffineTransformMakeRotation(M_PI);
        monitorTimeView.redcog.transform = CGAffineTransformMakeRotation(M_PI);
        
    }
    else{
        monitorTimeView.pinkcog.transform = CGAffineTransformMakeRotation(0);
        monitorTimeView.yellowcog.transform = CGAffineTransformMakeRotation(0);
        monitorTimeView.redcog.transform = CGAffineTransformMakeRotation(0);
    }
    
    rotateflag = !rotateflag;
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
    
    [monitorTimeView.layer removeAllAnimations];
    monitorView = nil;
    [monitorTimeView release];
    [monitorTimer invalidate], monitorTimer = nil;
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
