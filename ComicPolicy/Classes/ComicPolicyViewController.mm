//
//  ComicPolicyViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ComicPolicyViewController.h"
#import "PolicyManager.h"
#import "Catalogue.h"
#import "NetworkManager.h"
#import "ASIHTTPRequest.h"
#import "PositionManager.h"

@interface ComicPolicyViewController()

-(void) addNavigationView;
-(void) addSaveAndCancel;
-(void) checkInSync;
-(void) catalogueRequestComplete:(ASIHTTPRequest *)request;
-(void) catalogueRequestFailed:(ASIHTTPRequest *)request;
-(void) createControllers;
-(void) readInCatalogue:(NSTimer *) timer;
-(void) addNotificationHandlers;

@end

@implementation ComicPolicyViewController

@synthesize buttons;
@synthesize policyids;
@synthesize tickPlayer;
@synthesize tockPlayer;
@synthesize addNew;
/* The designated initializer. Override to perform setup that is required before the view is loaded.*/

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        NSLog(@"in here..");
    }
    return self;
}*/




// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    NSLog(@"in load view...");
    UIView *newView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    newView.backgroundColor = [UIColor whiteColor];
    self.view = newView;
    [newView release];
    
    
    routerConnectionViewController = [[RouterConnectionViewController alloc] init];
    [self.view addSubview:[routerConnectionViewController view]];
    
    [self readInCatalogue:nil];
    
    
	inprogress = NO;
	NSBundle *mainBundle = [NSBundle mainBundle];
	NSError *error;
	
	NSURL *tickURL = [NSURL fileURLWithPath:[mainBundle pathForResource:@"tick" ofType:@"caf"]];
	
	
	tickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:tickURL error:&error];
	if (!tickPlayer) {
		NSLog(@"no tickPlayer: %@", [error localizedDescription]);	
	}
	[tickPlayer prepareToPlay];
	
	NSURL *tockURL = [NSURL fileURLWithPath:[mainBundle pathForResource:@"tock" ofType:@"caf"]];
	tockPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:tockURL error:&error];
	if (!tockPlayer) {
		NSLog(@"no tockPlayer: %@", [error localizedDescription]);	
	}
	[tockPlayer prepareToPlay];
    
}

-(void) addNavigationView{
	navigationViewController = [[NavigationViewController alloc] init];
	[self.view addSubview: navigationViewController.view];
    [self addSaveAndCancel];
	
}

-(void) addSaveAndCancel{
	UIImageView *tmpCancel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel.png"]];
	tmpCancel.frame = CGRectMake(900, 680, 55, 57);
	deleteButton = tmpCancel;
	[self.view addSubview:tmpCancel];
	[tmpCancel release];
	
	UIImageView *tmpSave = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok.png"]];
	tmpSave.frame = CGRectMake(820, 680, 55, 57);
	saveButton = tmpSave;
	[self.view addSubview:tmpSave];
	[tmpSave release];
	
    UIImageView *tmpRefresh = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh.png"]];
	tmpRefresh.frame = CGRectMake(740, 680, 55, 57);
	refreshButton = tmpRefresh;
	[self.view addSubview:tmpRefresh];
	[tmpRefresh release];
    
    UIImageView *tmpReset = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reset.png"]];
	tmpReset.frame = CGRectMake(660, 680, 55, 57);
	resetButton = tmpReset;
    resetButton.alpha = 0.0;
	[self.view addSubview:tmpReset];
	[tmpReset release];
    
}



-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
     if (!inprogress){
    UITouch *touch = [touches anyObject]; 
	CGPoint touchLocation = [touch locationInView:self.view];
	
	if (CGRectContainsPoint( deleteButton.frame , touchLocation)){
		
        //[[PolicyManager sharedPolicyManager] policyFired:@"1"];
        [[PolicyManager sharedPolicyManager] deleteAll];
    }
    else if (CGRectContainsPoint( refreshButton.frame , touchLocation)){
        [[PolicyManager sharedPolicyManager] refresh];
    }
    else if (CGRectContainsPoint( resetButton.frame , touchLocation)){
        [[PolicyManager sharedPolicyManager] reset];
    }
	else if (CGRectContainsPoint( saveButton.frame , touchLocation)){
        [[PolicyManager sharedPolicyManager] savePolicy];
        
        CGRect frame = CGRectMake(0,0, [[UIScreen mainScreen] applicationFrame].size.height, [[UIScreen mainScreen] applicationFrame].size.width);
        
        progressView = [[UIView alloc] initWithFrame:frame];
        progressView.backgroundColor = [UIColor blackColor];
        progressView.alpha = 0.5;
        [self.view addSubview:progressView];
        inprogress = YES;
    }
     }
}

-(void) requestComplete:(NSNotification *) notification{
    if (inprogress){
        inprogress = NO;
        [progressView removeFromSuperview];
    }
    [self checkInSync];
}


-(void) catalogueChange:(NSNotification *) notification{
    [self checkInSync];
   
   
}

-(void) checkInSync{
    
    if ([[PolicyManager sharedPolicyManager] hasFired]){
         resetButton.alpha = 1.0;
        [self.view setBackgroundColor:[UIColor redColor]];
        return;
    }
    
    resetButton.alpha = 0.0;
   
    if (![[PolicyManager sharedPolicyManager] isInSync])
        [self.view setBackgroundColor:[UIColor lightGrayColor]];
     
    else
        [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

-(void) policyFired:(NSNotification *) notification{
    [self checkInSync];
}

-(void) policyLoaded:(NSNotification *) notification{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pageLoaded:finished:context:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:NO];
    [UIView commitAnimations];
    [self checkInSync];
}

-(void) pageLoaded:(NSString*)animationID finished:(BOOL)finished context:(void*)context{
   
}

- (void)playTick{
	AVAudioPlayer *currentPlayer = tockPlayer;
	[currentPlayer play];
}

- (void)playTock:(NSTimer*)timer{
	AVAudioPlayer *currentPlayer = tockPlayer;
	[currentPlayer play];
}

-(void) subjectOwnerChange:(NSNotification *) n{
	[self playTick];
    // [self.view setBackgroundColor:[UIColor redColor]];
	[NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(playTock:) userInfo:nil repeats:NO]; 
}

-(void) actionSubjectChange:(NSNotification *) n{
	[self playTick];
	[NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(playTock:) userInfo:nil repeats:NO]; 
}

-(void) conditionChange:(NSNotification *) n{
	[NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(playTock:) userInfo:nil repeats:NO]; 
	
}

-(void) actionTypeChange:(NSNotification *) n{
	
	
	AVAudioPlayer *currentPlayer = tickPlayer;
	[currentPlayer play];
	
	
	CGRect deadFrame = CGRectMake(64, 800, 294, 301);
	CGRect liveFrame = CGRectMake(64, 367, 294, 301);
	
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    
    if ([[[Catalogue sharedCatalogue] currentActionType] isEqualToString:@"block"]){
		actionTimeViewController.view.frame = deadFrame;
		[self.view addSubview:actionTimeViewController.view];
		actionTimeViewController.view.frame = liveFrame;
        
        //CGRect aframe = resultViewController.resultController.resultView.frame;
		//aframe.origin.x = 300;
		//aframe.size.width = 600;
		
        resultViewController.resultController.resultView.frame = [[PositionManager sharedPositionManager] getPosition:@"result"];
		
        
        
        resultViewController.resultController.resultView.resultMainImage.alpha = 1.0;
		//aframe = resultViewController.rootMonitorView.frame;		
        //aframe.origin.x = 300;
		
		resultViewController.currentMonitorViewController.monitorView.superview.frame = [[PositionManager sharedPositionManager] getPosition:@"resultmonitor"];
       
	}else{
		
		
		[UIView setAnimationDidStopSelector:@selector(actionOffScreen:finished:context:)];
		
		actionTimeViewController.view.frame = deadFrame;
        resultViewController.resultController.resultView.frame = [[PositionManager sharedPositionManager] getPosition:@"result"];
		resultViewController.resultController.resultView.resultMainImage.alpha = 1.0;
		
        
        resultViewController.currentMonitorViewController.monitorView.superview.frame = [[PositionManager sharedPositionManager] getPosition:@"resultmonitor"];
        
       
    }
    [UIView commitAnimations];

}


-(void) actionOffScreen:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	[actionTimeViewController.view removeFromSuperview];	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}




-(void) readInCatalogue:(NSTimer*) timer{
    
    if(timer != nil){
        [timer invalidate];
        timer = nil;
    }
        
   
    NSString *rootURL  = [[NetworkManager sharedManager] rootURL];
    NSString *strurl = [NSString stringWithFormat:@"%@/public/policies/catalogue.json", rootURL];
   
    NSURL *url = [NSURL URLWithString:strurl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(catalogueRequestComplete:)];
    [request setDidFailSelector:@selector(catalogueRequestFailed:)];
    [[NetworkManager sharedManager] addRequest:request];
}

- (void)catalogueRequestComplete:(ASIHTTPRequest *)request
{
     NSLog(@"catalogue request success!!");
    NSString *responseString = [request responseString];
 
    [[Catalogue sharedCatalogue] parseCatalogue:responseString];
    [self createControllers];
    
    [self addNotificationHandlers];
    [[PolicyManager sharedPolicyManager] loadFirstPolicy];
   //[self addNavigationView];
    

}


- (void)catalogueRequestFailed:(ASIHTTPRequest *)request
{
    //[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(readInCatalogue:) userInfo:nil repeats:NO]; 
     
    NSLog(@"catalogue request failed!!");
    [[Catalogue sharedCatalogue] parseCatalogue:nil];
    [self createControllers];
    [self addNotificationHandlers];
    [[PolicyManager sharedPolicyManager] loadFirstPolicy];
   // [self addNavigationView];
    
}

-(void) addNotificationHandlers{
    
	// add some policy test data...
	
	
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionTypeChange:) name:@"actionTypeChange" object:nil];	
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conditionChange:) name:@"conditionChange" object:nil];	
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionSubjectChange:) name:@"actionSubjectChange" object:nil];	
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectOwnerChange:) name:@"subjectOwnerChange" object:nil];
     
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(catalogueChange:) name:@"catalogueChange" object:nil];
     
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(policyLoaded:) name:@"policyLoaded" object:nil];	
     
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(policyFired:) name:@"policyFired" object:nil];
     
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestComplete:) name:@"saveRequestComplete" object:nil];
}

-(void) createControllers{
   
    [routerConnectionViewController.view removeFromSuperview];
    
	subjectViewController = [[SubjectViewController alloc] init];
	[self.view addSubview:subjectViewController.view];
	
	
	
	eventViewController = [[RootConditionViewController alloc] init];
	[self.view addSubview:eventViewController.view];
	
	resultViewController = [[RootResultViewController alloc] init];
	[self.view addSubview:resultViewController.view];
	
    actionViewController = [[RootActionViewController alloc] init];
	[self.view addSubview:actionViewController.view];
    
	actionTimeViewController = [[ActionTimeViewController alloc] init];
	
	[self addNavigationView];

}




- (void)dealloc {
    [super dealloc];
	[subjectViewController release];
	[eventViewController release];
	[actionViewController release];
	[resultViewController release];
    [navigationViewController release];
}

@end
