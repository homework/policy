//
//  ComicPolicyViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ComicPolicyViewController.h"
#import "PolicyManager.h"


@interface ComicPolicyViewController()

-(void) addNavigationView;
-(void) addSaveAndCancel;
@end

@implementation ComicPolicyViewController

@synthesize buttons;
@synthesize saveButton;
@synthesize deleteButton;
@synthesize policyids;
@synthesize tickPlayer;
@synthesize tockPlayer;
@synthesize addNew;
/* The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    }
    return self;
}*/




// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
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
	
	
	
	// add some policy test data...
	
	self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
	
	subjectViewController = [[SubjectViewController alloc] init];
	[self.view addSubview:subjectViewController.view];
	
	actionViewController = [[RootActionViewController alloc] init];
	[self.view addSubview:actionViewController.view];
	
	eventViewController = [[RootConditionViewController alloc] init];
	[self.view addSubview:eventViewController.view];
	
	resultViewController = [[RootResultViewController alloc] init];
	[self.view addSubview:resultViewController.view];
	
	actionTimeViewController = [[ActionTimeViewController alloc] init];
	
	[self addNavigationView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionTypeChange:) name:@"actionTypeChange" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conditionChange:) name:@"conditionChange" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionSubjectChange:) name:@"actionSubjectChange" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectOwnerChange:) name:@"subjectOwnerChange" object:nil];	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(policyLoaded:) name:@"policyLoaded" object:nil];	
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestComplete:) name:@"requestComplete" object:nil];
	[[PolicyManager sharedPolicyManager] loadFirstPolicy];
	
}

-(void) addNavigationView{
	navigationViewController = [[NavigationViewController alloc] init];
	[self.view addSubview: navigationViewController.view];
    [self addSaveAndCancel];
	
}

-(void) addSaveAndCancel{
	UIImageView *tmpCancel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel.png"]];
	tmpCancel.frame = CGRectMake(900, 680, 55, 57);
	self.deleteButton = tmpCancel;
	[self.view addSubview:tmpCancel];
	[tmpCancel release];
	
	UIImageView *tmpSave = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok.png"]];
	tmpSave.frame = CGRectMake(820, 680, 55, 57);
	self.saveButton = tmpSave;
	[self.view addSubview:tmpSave];
	[tmpSave release];
	
}



-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
     if (!inprogress){
    UITouch *touch = [touches anyObject]; 
	CGPoint touchLocation = [touch locationInView:self.view];
	
	if (CGRectContainsPoint( deleteButton.frame , touchLocation)){
		NSLog(@"would delete this");
	}
	
	else if (CGRectContainsPoint( saveButton.frame , touchLocation)){
        NSString *policysent =  [[PolicyManager sharedPolicyManager] savePolicy];
        NSLog(@"Policy to sent is %@", policysent);
        
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
}

-(void) policyLoaded:(NSNotification *) notification{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pageLoaded:finished:context:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:NO];
    [UIView commitAnimations];
    [self.view setBackgroundColor:[UIColor whiteColor]];
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
     [self.view setBackgroundColor:[UIColor redColor]];
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
	
	NSDictionary *userInfo = [n userInfo];
	NSString* controller = [userInfo objectForKey:@"controller"];
	CGRect deadFrame = CGRectMake(64, 800, 294, 301);
	CGRect liveFrame = CGRectMake(64, 367, 294, 301);
	
	if ([controller isEqualToString:@"ActionBlockViewController"]){
		actionTimeViewController.view.frame = deadFrame;
		[self.view addSubview:actionTimeViewController.view];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		actionTimeViewController.view.frame = liveFrame;
		[UIView commitAnimations];
	}else{
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(actionOffScreen:finished:context:)];
		
		actionTimeViewController.view.frame = deadFrame;
		[UIView commitAnimations];
	}
}

-(void) actionOffScreen:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	[actionTimeViewController.view removeFromSuperview];	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}



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


- (void)dealloc {
    [super dealloc];
	[subjectViewController release];
	[eventViewController release];
	[actionViewController release];
	[resultViewController release];
    [navigationViewController release];
}

@end
