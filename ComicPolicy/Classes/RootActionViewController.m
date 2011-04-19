    //
//  ActionViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootActionViewController.h"
#import "ActionBlockViewController.h"
#import "Catalogue.h"

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
	//CGRect aframe = CGRectMake(666,46,294,301);
	
	CGRect aframe = CGRectMake(666,26,294,334);
	self.view = [[UIView alloc] initWithFrame: aframe];
	
	NSString *controller = [[Catalogue sharedCatalogue] nextActionViewController];
	
	UIViewController *newController = [[[NSClassFromString(controller) alloc] initWithNibName:nil bundle:nil] retain];
	[[self view] addSubview:[newController view]];
	currentViewController = newController;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
		
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self.view];
	
	//FlipFrameView *currentView = (FlipFrameView *) currentViewController.view;
	
	
	if (
		/*CGRectContainsPoint(currentView.upImage.frame, touchLocation)*/ touchLocation.y < 60){
		NSString *nextvc = [[Catalogue sharedCatalogue] nextActionViewController];
		NSLog(@"loading up vc %@", nextvc);
		NSString *controller = nextvc; //[controllerList objectAtIndex: ++controllerIndex % [controllerList count]];
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
        
		//move this notifcation elsewhere...
        NSDictionary* dict = [NSDictionary dictionaryWithObject:controller forKey:@"controller"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"actionTypeChange" object:nil userInfo:dict];
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
