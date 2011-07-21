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
-(void) rotateCogs;//:(NSString *) animationID finished:(NSNumber*)finished context:(void*)context;
-(void) rotateActivityMonitor:(activity) a;
-(void) resetActivity;
-(void) advancePointer:(int) timeLeft timeInside:(int) timeInside isInside:(BOOL) inside;
-(void) advanceInside: (int) timeLeft timeInside:(int) timeInside;
-(void) advanceOutside:(int) timeLeft timeOutside:(int) timeOutside;
-(int) secondsUntil:(long) ts clockTime:(NSString*) clocktime;
-(int) secondsFromMidnight:(long)ts;
-(BOOL) isInsideRange:(long) ts from: (NSString*) f to: (NSString*) t;
-(long) secondsFromMidnightForString:(NSString *) ts;
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
    [monitorTimeView release];
    
    //[self rotateCogs:nil finished:nil context:nil];
   
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
    
    //[self advancePointer];
    [self rotateCogs];
    //start = M_PI / 
    NSString * subject = [[Catalogue sharedCatalogue] currentSubjectDevice];
    NSString *rootURL  = [[NetworkManager sharedManager] rootURL];
    NSString *strurl = [NSString stringWithFormat:@"%@/monitor/activity/%@", rootURL, subject];
    [[MonitorDataSource sharedDatasource] requestURL: strurl callback:@"newActivityData"];
}

-(void) advancePointer:(int) timeLeft timeInside:(int) timeInside isInside:(BOOL) inside{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDelegate:self];
    //float startInDegrees = ((3 * M_PI)/4) * ((float)180/M_PI);
    
    
    if (inside){
        [self advanceInside:timeLeft timeInside: timeInside];
    }else{
        [self advanceOutside:timeLeft timeOutside: timeInside];
    }
    [UIView commitAnimations];
}

/*
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
}*/

-(void) advanceInside: (int) timeLeft timeInside:(int)timeInside{
    float startInDegrees = (M_PI/4) * ((float)180/M_PI);
        
   
    float fraction = (float)timeLeft/(float)timeInside;   //TIMEINSIDE;
    NSLog(@"fraction is %f / %f = %f", (float)timeLeft, (float)timeInside, fraction);
    int degrees = (int) (startInDegrees + ((90) - ((float)90 * fraction))) % 360;
    NSLog(@"inside => degrees is now %d", degrees);
    monitorTimeView.pointer.transform = CGAffineTransformMakeRotation((float)degrees * (M_PI)/180);
   // DURATION += 3;
}

-(void) advanceOutside: (int) timeLeft timeOutside:(int)timeOutside{
    
    NSLog(@"ADVANCING OUTSIDE!!!");
    
    float startInDegrees = ((3 * M_PI)/4) * ((float)180/M_PI);
    
    float fraction = (float)timeLeft/(float)timeOutside;///TIMEOUTSIDE;
    NSLog(@"fraction is %f", fraction);
    int degrees = (int) (startInDegrees + ((270) - (270 * fraction))) % 360;
    
    NSLog(@"degrees is %d", degrees);
    
    monitorTimeView.pointer.transform = CGAffineTransformMakeRotation((float)degrees * (M_PI)/180);
    DURATION += 3;
}

-(void) newActivityData:(NSNotification *) notification{
    NSDictionary *data = [notification userInfo];
    NSString *responseString = [data objectForKey:@"data"];    
    
    NSLog(@"response string %@", responseString);
    SBJsonParser *jsonParser = [SBJsonParser new];
    
    NSArray* results = (NSArray *) [jsonParser objectWithString:responseString error:nil];
    
    NSNumber *activity = (NSNumber*) [results objectAtIndex:1];
    
    NSNumber *ts = (NSNumber*) [results objectAtIndex:0];
    
    if ([activity longValue] == 0){
        [self rotateActivityMonitor:INACTIVE];
    }else{
        [self rotateActivityMonitor:ACTIVE];
    }
    
    NSMutableDictionary *args =  [(NSMutableDictionary *) [[Catalogue sharedCatalogue] currentConditionArguments] objectForKey:@"timed"];
    
    NSString *from = [args objectForKey:@"from"];
    NSString *to   = [args objectForKey:@"to"];
    
    int routersecondsfrommidnight = [self secondsFromMidnight:[ts longLongValue]/1000];
    
    BOOL isInside = [self isInsideRange:routersecondsfrommidnight from:from to:to];
    
    int secondstoto   = [self secondsUntil:[ts longLongValue]/1000 clockTime:to];
    int secondstofrom = [self secondsUntil:[ts longLongValue]/1000 clockTime:from];

    int timeinside = (secondstofrom < secondstoto) ? (secondstoto-secondstofrom) : (24* 3600) - (secondstofrom-secondstoto);
    
    int timeoutside = (24*3600) - timeinside;

    if (isInside){
        [self advancePointer:secondstoto timeInside:timeinside isInside: isInside];
    }else{
        [self advancePointer:secondstofrom timeInside:timeoutside isInside: isInside];
    }
}

-(BOOL) isInsideRange:(long) ts from: (NSString*) f to: (NSString*) t{
    
    long from = [self secondsFromMidnightForString:f];
    
    long to   = [self secondsFromMidnightForString:t];
    
    if (to > from){
        return (ts >= from && ts <= to);
    }else{
        return !(ts > to && ts <= from);
    }
        
}

                     
-(int) secondsUntil:(long) ts clockTime:(NSString*) clocktime{

    NSArray *timearray = [clocktime componentsSeparatedByString:@":"];
    
    int hrs     = [(NSString*) [timearray objectAtIndex:0] intValue];
    
    int minutes = [(NSString*) [timearray objectAtIndex:1] intValue];
    
    int fromseconds = [self secondsFromMidnight:ts];
    
    int toseconds   = ((hrs * 3600) + (minutes * 60));
    
    
    if (toseconds > fromseconds)
        return (toseconds - fromseconds);
    else
        return (24 * 3600) - (fromseconds - toseconds);
                     
}

-(long) secondsFromMidnightForString:(NSString *) ts{
    NSArray *timearray = [ts componentsSeparatedByString:@":"];
    int hrs     = [(NSString*) [timearray objectAtIndex:0] intValue];
    int minutes = [(NSString*) [timearray objectAtIndex:1] intValue];
    return (hrs * 3600) + (minutes * 60);
}


-(int) secondsFromMidnight:(long) ts{
    
    
    NSDate* routerDate = [NSDate dateWithTimeIntervalSince1970:ts];
    
    NSDateComponents *hourcomponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:routerDate];
    
    NSDateComponents *minutecomponents = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:routerDate];
    
    NSDateComponents *secondcomponents = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:routerDate];
    
    int routerhour = [hourcomponents hour];
    int routerminutes = [minutecomponents minute];
    int routerseconds = [secondcomponents second];
    
    monitorTimeView.routercaption.text = [NSString stringWithFormat:@"%d:%d", routerhour, routerminutes];
    NSLog(@"router time is %d:%d", routerhour, routerminutes);
    return ((routerhour * 3600) + (routerminutes * 60) + (routerseconds));
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

-(void) rotateCogs{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.9];
    [UIView setAnimationDelegate:self];
    // [UIView setAnimationDidStopSelector:@selector(rotateCogs:finished:context:)];
    
    
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
-(void) rotateCogs:(NSString *) animationID finished:(NSNumber*)finished context:(void*)context{
    NSLog(@"performing animations...");
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:5.0];
    [UIView setAnimationDelegate:self];
   // [UIView setAnimationDidStopSelector:@selector(rotateCogs:finished:context:)];
    
    
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
    NSLog(@"TIME VIEW DID UNLOAD>>>>");
    [monitorTimeView.layer removeAllAnimations];
    monitorView = nil;
    [monitorTimer invalidate], monitorTimer = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


@end
