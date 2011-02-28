    //
//  ActionViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootActionViewController.h"
#import "ActionNotifyViewController.h"

@implementation RootActionViewController

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
	CGRect aframe = CGRectMake(666,46,294,301);
	self.view = [[UIView alloc] initWithFrame: aframe];
	
	/*
	 * set up the view condition controllers
	 */
	ActionNotifyViewController* actionNotifyViewController = [[[ActionNotifyViewController alloc] initWithNibName:nil bundle:nil] retain];
	
	
	controllerList = [[NSArray arrayWithObjects:@"ActionNotifyViewController", 
					   @"ActionBlockViewController", nil] retain];
	
	
		
	/*
	 * Add one of the controller's views as a sub view...
	 */ 
	[self.view addSubview:[actionNotifyViewController view]];
	currentViewController = actionNotifyViewController;
	controllerIndex = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
		
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self.view];
	
	FlipFrameView *currentView = (FlipFrameView *) currentViewController.view;
	
	if (CGRectContainsPoint(currentView.upImage.frame, touchLocation)){
		NSString *controller = [controllerList objectAtIndex: ++controllerIndex % [controllerList count]];
		UIViewController *newController = [[[NSClassFromString(controller) alloc] initWithNibName:nil bundle:nil] retain];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
		[currentViewController.view removeFromSuperview];
		[currentViewController release];
		[[self view] addSubview:[newController view]];
		[UIView commitAnimations];
		currentViewController = newController;
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
