//
//  ResultViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootResultViewController.h"
#import "Catalogue.h"
#import "PolicyManager.h"
#import "PositionManager.h"

@interface RootResultViewController() 
-(void) updateActionResultScene;
-(void) updateConditionResult;
@end

@implementation RootResultViewController
@synthesize resultController;
@synthesize currentMonitorViewController;
//@synthesize rootMonitorView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */



-(void) conditionChange:(NSNotification *) n{
    [self updateConditionResult];
    [self updateActionResultScene];
}

-(void) policyFired:(NSNotification *) n{
    BOOL hasFired = [[PolicyManager sharedPolicyManager] hasFiredForSubject:[[Catalogue sharedCatalogue] currentActionSubject]];
    
    NSString *newscene =  [[Catalogue sharedCatalogue] getActionResultImage:hasFired];
    
    CGRect frame = resultController.resultView.resultMainImage.frame;
    
    resultController.resultView.resultMainImage.image = [UIImage imageNamed:newscene];
    resultController.resultView.resultMainImage.frame = frame;
}

-(void) policyChanged:(NSNotification *) n{
    [self updateConditionResult];
    [self updateActionResultScene];
}

-(void) updateConditionResult{
    
    NSString *newcontroller = [[Catalogue sharedCatalogue] getConditionMonitorController];
    
    MonitorViewController *newController = [[NSClassFromString(newcontroller) alloc] initWithNibName:nil bundle:nil];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [currentMonitorViewController.view removeFromSuperview];
    [currentMonitorViewController viewDidUnload];
    [self.view addSubview:newController.view];
    self.currentMonitorViewController = newController;
    [UIView commitAnimations];
    [newController release];
    
    [resultController.view removeFromSuperview];
    [self.view addSubview:resultController.view];
    
}

-(void) updateActionResultScene{
    BOOL hasFired = [[PolicyManager sharedPolicyManager] hasFiredForSubject:[[Catalogue sharedCatalogue] currentActionSubject]];
    
    
	NSString *newscene =  [[Catalogue sharedCatalogue] getActionResultImage:hasFired];
    
	if (newscene != NULL){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:resultController.resultView.resultMainImage cache:YES];
        resultController.resultView.resultMainImage.image = [UIImage imageNamed:newscene];
        [UIView commitAnimations];
        resultController.currentActionScene = newscene;
	}
    
}

-(void) actionSubjectChange:(NSNotification *) n{
    [self updateActionResultScene];
}

- (void)stopped:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	NSLog(@"stopped....");
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
   
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conditionChange:) name:@"conditionChange" object:nil];	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(policyChanged:) name:@"policyLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(policyChanged:) name:@"saveRequestComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionSubjectChange:) name:@"actionSubjectChange" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(policyFired:) name:@"policyFired" object:nil];	
    
    
	CGRect aframe = CGRectMake(64,367,897,301);
	UIView *rootView = [[UIView alloc] initWithFrame:aframe];	
	self.view = rootView;
    [rootView release];
    
	ResultViewController *tmpResultController = [[[NSClassFromString(@"ResultViewController") alloc] initWithNibName:nil bundle:nil] retain];
    MonitorViewController *tmpMonitorController = [[[NSClassFromString(@"MonitorViewController") alloc] initWithNibName:nil bundle:nil] retain];

    [[self view] addSubview: [tmpMonitorController view ]];
	
	[[self view] addSubview:[tmpResultController view]];
   
    resultController = tmpResultController;
	
    
    currentMonitorViewController = tmpMonitorController;
    
    [tmpMonitorController release];
}

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
}


@end
