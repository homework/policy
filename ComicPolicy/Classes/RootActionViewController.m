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
#import "PositionManager.h"

@implementation RootActionViewController


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	CGRect aframe = CGRectMake(666,26,294,334);
	self.view = [[UIView alloc] initWithFrame: aframe];
	
	NSString *controller = [[Catalogue sharedCatalogue] currentActionViewController];
	
	UIViewController *newController = [[[NSClassFromString(controller) alloc] initWithNibName:nil bundle:nil] retain];
	[[self view] addSubview:[newController view]];
	currentViewController = newController;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionLoaded:) name:@"actionLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conditionChange:) name:@"conditionChange" object:nil];
}

-(void) actionLoaded:(NSNotification *) n{
    NSString *controller = [[Catalogue sharedCatalogue] currentActionViewController];
    UIViewController *newController = [[[NSClassFromString(controller) alloc] initWithNibName:nil bundle:nil] retain];
    [currentViewController.view removeFromSuperview];
    [currentViewController release];
    [[self view] addSubview:[newController view]];
    currentViewController = newController;
}

-(void) conditionChange:(NSNotification *) n{
    NSString *controller = [[Catalogue sharedCatalogue] currentActionViewController];
    UIViewController *newController = [[[NSClassFromString(controller) alloc] initWithNibName:nil bundle:nil] retain];
   
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    
    [currentViewController.view removeFromSuperview];
    [[self view] addSubview:[newController view]];
    newController.view.superview.frame = [[PositionManager sharedPositionManager] getPosition:@"action"];
    [currentViewController release];
    currentViewController = newController;

    if(![[[Catalogue sharedCatalogue] currentCondition] isEqualToString:@"visiting"]){
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    }
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
		
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self.view];

	
	if (touchLocation.y < 60){
		NSString *controller = [[Catalogue sharedCatalogue] nextActionViewController];
		UIViewController *newController = [[[NSClassFromString(controller) alloc] initWithNibName:nil bundle:nil] retain];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
		[currentViewController.view removeFromSuperview];
		
		[[self view] addSubview:[newController view]];
		[UIView commitAnimations];
        [currentViewController release];
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
