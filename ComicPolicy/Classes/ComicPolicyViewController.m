//
//  ComicPolicyViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ComicPolicyViewController.h"

@implementation ComicPolicyViewController

@synthesize managedObjectContext;

/* The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    }
    return self;
}*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
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
	
	ComicNavigationController *cnvc = [[ComicNavigationController alloc] init];
	[self.view addSubview:cnvc.view];
	
	UIImageView *tmpCancel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel.png"]];
	tmpCancel.frame = CGRectMake(900, 680, 55, 57);
	[self.view addSubview:tmpCancel];
	[tmpCancel release];
	
	UIImageView *tmpSave = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok.png"]];
	tmpSave.frame = CGRectMake(820, 680, 55, 57);
	[self.view addSubview:tmpSave];
	[tmpSave release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionTypeChange:) name:@"actionTypeChange" object:nil];	

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	NSLog(@"got here..");
}

-(void) actionTypeChange:(NSNotification *) n{
	
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
    return YES;
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
}

@end
