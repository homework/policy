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
-(void) updateFramePositions;
@end

@implementation ComicPolicyViewController

@synthesize buttons;
@synthesize policyids;
@synthesize tickPlayer;
@synthesize tockPlayer;
@synthesize addNew;
@synthesize statusLabel;

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

-(void) addStatusLabel{
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 680, 500, 55)];
    self.statusLabel.textColor = [UIColor blackColor];
    self.statusLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:20.0];
    self.statusLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:statusLabel];
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
    
    /*UIImageView *tmpReset = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reset.png"]];
	tmpReset.frame = CGRectMake(660, 680, 55, 57);
	resetButton = tmpReset;
    resetButton.alpha = 0.0;
	[self.view addSubview:tmpReset];
	[tmpReset release];*/
    
    UIImageView *tmpActivate = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activate.png"]];
	tmpActivate.frame = CGRectMake(660, 680, 55, 57);
	activateButton = tmpActivate;
    activateButton.alpha = 0.0;
	[self.view addSubview:tmpActivate];
	[tmpActivate release];

    
}



-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
     if (!inprogress){
    UITouch *touch = [touches anyObject]; 
	CGPoint touchLocation = [touch locationInView:self.view];
	
	if (CGRectContainsPoint( deleteButton.frame , touchLocation)){
        NSLog(@"delete pressed");
        [[PolicyManager sharedPolicyManager] deleteCurrentPolicy];
		//[self updateFramePositions];
        //[[PolicyManager sharedPolicyManager] policyFired:@"1"];
        
        ///[[PolicyManager sharedPolicyManager] deleteAll];
    }
    else if (CGRectContainsPoint( refreshButton.frame , touchLocation)){
       [[PolicyManager sharedPolicyManager] refresh];
     //   [self updateFramePositions];

    }
    else if (CGRectContainsPoint( activateButton.frame , touchLocation)){
        [[PolicyManager sharedPolicyManager] enablePolicy];
     //   [[PolicyManager sharedPolicyManager] reset];
    }
	else if (CGRectContainsPoint( saveButton.frame , touchLocation)){
       // [[PolicyManager sharedPolicyManager] createPonderTalk];
        [[PolicyManager sharedPolicyManager] savePolicyToHWDB];
        /*
        [[PolicyManager sharedPolicyManager] savePolicy];
        
        CGRect frame = CGRectMake(0,0, [[UIScreen mainScreen] applicationFrame].size.height, [[UIScreen mainScreen] applicationFrame].size.width);
        
        progressView = [[UIView alloc] initWithFrame:frame];
        progressView.backgroundColor = [UIColor blackColor];
        progressView.alpha = 0.5;
        [self.view addSubview:progressView];
        inprogress = YES;*/
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
       //  resetButton.alpha = 1.0;
        [self.view setBackgroundColor:[UIColor redColor]];
        return;
    }
    
    //resetButton.alpha = 0.0;
   
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
   
    Policy *p = [[PolicyManager sharedPolicyManager] currentPolicy];
                 
    self.statusLabel.text = [NSString stringWithFormat:@"This comic is currently %@", [p statusAsString]];
  
    
    if (p.status == disabled){
       
        activateButton.alpha = 1.0;
    }else{
       
        activateButton.alpha = 0.0;
    }
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
	
	[self updateFramePositions];
    
}


-(void) updateFramePositions{

    
	AVAudioPlayer *currentPlayer = tickPlayer;
	[currentPlayer play];
	
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    
    if ([[[Catalogue sharedCatalogue] currentActionType] isEqualToString:@"block"]){
		
        
       // [self.view addSubview:actionTimeViewController.view];
		actionViewController.view.frame = [[PositionManager sharedPositionManager] getPosition:@"action"];
        
        actionTimeViewController.view.frame = [[PositionManager sharedPositionManager] getPosition:@"actiontime"];
        [actionTimeViewController update];
        
        conditionVisitingTimeViewController.view.frame = [[PositionManager sharedPositionManager] getPosition:@"conditionvisitingtime"];
        [conditionVisitingTimeViewController initialiseClocks];
        
	
        resultViewController.resultController.resultView.frame = [[PositionManager sharedPositionManager] getPosition:@"result"];        
        resultViewController.resultController.resultView.resultMainImage.alpha = 1.0;
				
        CGRect newframe = [[PositionManager sharedPositionManager] getPosition:@"resultmonitor"];

		resultViewController.currentMonitorViewController.monitorView.superview.frame = newframe;
        
        resultViewController.currentMonitorViewController.monitorView.frame = CGRectMake(0,0, newframe.size.width, newframe.size.height);      
	}else{
		
		
		[UIView setAnimationDidStopSelector:@selector(actionOffScreen:finished:context:)];
		actionViewController.view.frame = [[PositionManager sharedPositionManager] getPosition:@"action"];
		actionTimeViewController.view.frame = [[PositionManager sharedPositionManager] getPosition:@"actiontime"];
        resultViewController.resultController.resultView.frame = [[PositionManager sharedPositionManager] getPosition:@"result"];
		resultViewController.resultController.resultView.resultMainImage.alpha = 1.0;
        
        conditionVisitingTimeViewController.view.frame = [[PositionManager sharedPositionManager] getPosition:@"conditionvisitingtime"];
        [conditionVisitingTimeViewController initialiseClocks];
        
        CGRect newframe = [[PositionManager sharedPositionManager] getPosition:@"resultmonitor"];
        
		resultViewController.currentMonitorViewController.monitorView.superview.frame = newframe;
        
        resultViewController.currentMonitorViewController.monitorView.frame = CGRectMake(0,0, newframe.size.width, newframe.size.height); 
        
       
    }
    [UIView commitAnimations];

}


-(void) actionOffScreen:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	//[actionTimeViewController.view removeFromSuperview];	
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
    
    [self catalogueRequestFailed:nil];
    
    if(timer != nil){
        [timer invalidate];
        timer = nil;
    }
        
   /*
    NSString *rootURL  = [[NetworkManager sharedManager] rootURL];
    NSString *strurl = [NSString stringWithFormat:@"%@/public/policies/catalogue.json", rootURL];
   
    NSURL *url = [NSURL URLWithString:strurl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(catalogueRequestComplete:)];
    [request setDidFailSelector:@selector(catalogueRequestFailed:)];
    [[NetworkManager sharedManager] addRequest:request];*/
}

- (void)catalogueRequestComplete:(ASIHTTPRequest *)request
{
    
    
    
     NSLog(@"catalogue request success!!");
    NSString *responseString = [request responseString];
 
    [[Catalogue sharedCatalogue] parseCatalogue:responseString];
    [self createControllers];
    
    [self addNotificationHandlers];
    //[[PolicyManager sharedPolicyManager] loadFirstPolicy];
   //[self addNavigationView];
    

}


- (void)catalogueRequestFailed:(ASIHTTPRequest *)request
{
    //[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(readInCatalogue:) userInfo:nil repeats:NO]; 
     
    NSLog(@"catalogue request failed!!");
    
    [[Catalogue sharedCatalogue] parseCatalogue:nil];
    
    
    
    [self addNotificationHandlers];
    
    [self createControllers];
    
    [[PolicyManager sharedPolicyManager] loadFirstPolicy];
    
    [self updateFramePositions];
    
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conditionChange:) name:@"totalPoliciesChanged" object:nil];
    
}

-(void) createControllers{
   
    [routerConnectionViewController.view removeFromSuperview];
    
	subjectViewController = [[SubjectViewController alloc] init];
	[self.view addSubview:subjectViewController.view];
	
	eventViewController = [[RootConditionViewController alloc] init];
	[self.view addSubview:eventViewController.view];
	
    conditionVisitingTimeViewController = [[ConditionVisitingTimeViewController alloc] init];
    [self.view addSubview:conditionVisitingTimeViewController.view];
	
	resultViewController = [[RootResultViewController alloc] init];
	[self.view addSubview:resultViewController.view];
	
    actionViewController = [[RootActionViewController alloc] init];
	[self.view addSubview:actionViewController.view];
    
	actionTimeViewController = [[ActionTimeViewController alloc] init];
    [self.view addSubview:actionTimeViewController.view];
    
    actionTimeViewController.view.frame = [[PositionManager sharedPositionManager] getPosition:@"actiontime"];
    
   
	[self addNavigationView];
    [self addStatusLabel];

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
