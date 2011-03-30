    //
//  NavigationViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 30/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NavigationViewController.h"


@implementation NavigationViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	CGFloat ylen = [[UIScreen mainScreen] bounds].size.height;
	navigationView = [[NavigationView alloc] initWithFrame:CGRectMake(0,0, ylen,50)];
	self.view = navigationView;
}

-(void) updatePolicyIds:(NSMutableArray *) policyids{
	[navigationView updateNavigation:policyids];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [touches anyObject];
	selectedPolicy = [touch view].tag;
	
	CGPoint touchLocation = [touch locationInView:self.view];
	
	
	for(UIView *view in self.view.subviews){
		if (CGRectContainsPoint(view.frame, touchLocation)){
			if (view.tag > 0){
				if (selectedView != nil){
					selectedView.transform = CGAffineTransformMakeScale(0.8, 0.8);	
				}				
				selectedPolicy = view.tag;
				selectedView = view;
				view.transform = CGAffineTransformMakeScale(1.0, 1.0);
				
				break;
			}
		}
	}
	
	
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
