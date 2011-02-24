    //
//  ResultViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultViewController.h"


@implementation ResultViewController

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
	NSDictionary *userInfo = [n userInfo];
	NSString* newscene = [Lookup lookupmonitor:[userInfo objectForKey:@"condition"]];
	
	if (! [currentMonitorScene isEqualToString:newscene]){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:resultView.monitorImage cache:YES];
		resultView.monitorImage.image = [UIImage imageNamed:newscene];//@"resulttype.png"];
		[UIView commitAnimations];
		currentMonitorScene = newscene;
	}
}

-(void) actionSubjectChange:(NSNotification *) n{
	
		
	NSDictionary *userInfo = [n userInfo];
	NSLog(@"lookuing ip %@", [userInfo objectForKey:@"action"]);
	NSString* newscene = [Lookup lookupresult:[userInfo objectForKey:@"action"]];
	if (! [currentActionScene isEqualToString:newscene]){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:resultView.resultMainImage cache:YES];
		resultView.resultMainImage.image = [UIImage imageNamed:newscene];
		[UIView commitAnimations];
		currentActionScene = newscene;

	}
}
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

 currentMonitorScene = @"resultbandwidth.png";
 currentActionScene = @"dadwaiting.png";
	
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conditionChange:) name:@"conditionChange" object:nil];	
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionSubjectChange:) name:@"actionSubjectChange" object:nil];	
	
 CGRect aframe = CGRectMake(64,367,897,301);
 ResultView *aview = [[ResultView alloc] initWithFrame: aframe];//
 resultView = aview;
 self.view = resultView;
 [aview release];
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
