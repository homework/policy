    //
//  EventViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootConditionViewController.h"
#import "ConditionViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation RootConditionViewController
@synthesize currentViewController;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        
        [[Catalogue sharedCatalogue] nextCondition];
        NSString *controller = [[Catalogue sharedCatalogue] getConditionViewController];
	
        ConditionViewController *newController = [[NSClassFromString(controller) alloc] initWithNibName:nil bundle:nil];

		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
		[currentViewController.view removeFromSuperview];
		[[self view] addSubview:[newController view]];
		[UIView commitAnimations];
	
		//[currentViewController release];
		self.currentViewController = newController;
        [newController release];
		
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	controllerIndex = 0;
	/*
	 *Set up the root view..
	 */
	
	CGRect aframe = CGRectMake(364,60,294,301);
	self.view = [[UIView alloc] initWithFrame: aframe];
	
	/*
	 * set up the view condition controllers
	 */
	
	NSString *controller = [[Catalogue sharedCatalogue] getConditionViewController];
	
    ConditionViewController *newcontroller = [[[NSClassFromString(controller) alloc] initWithNibName:nil bundle:nil] retain];
			
	/*
	 * Add one of the controller's views as a sub view...
	 */ 
	[self.view addSubview:[newcontroller view]];
	
	currentViewController = newcontroller;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conditionLoaded:) name:@"conditionLoaded" object:nil];
}

-(void) conditionLoaded:(NSNotification *) n{
    
   
    
    NSString *controller = [[Catalogue sharedCatalogue] getConditionViewController];
	
    ConditionViewController *newController = [[[NSClassFromString(controller) alloc] initWithNibName:nil bundle:nil] retain];
    [currentViewController.view removeFromSuperview];
    [[self view] addSubview:[newController view]];
        [currentViewController release];
    currentViewController = newController;
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
	[controllerList release];
}


@end
