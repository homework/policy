    //
//  EventViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootConditionViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation RootConditionViewController
@synthesize conditionBandwidthViewController;
@synthesize conditionTypeViewController;

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
		UITouch *touch = [[event allTouches] anyObject];
		CGPoint touchLocation = [touch locationInView:self.view];
		NSArray* subviews = [self.view subviews];
		NSString* imageName = [Lookup nextConditionImage]; 
			
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
			
		if ([imageName isEqualToString:@"bandwidth.png"]){
			[[conditionTypeViewController view] removeFromSuperview];
			[[self view] addSubview:[conditionBandwidthViewController view]];
		}else 
		if ([ subviews objectAtIndex:0] == [conditionBandwidthViewController view]){
			[[conditionBandwidthViewController view] removeFromSuperview];
			[conditionTypeViewController conditionTypeView].conditionImage.image = [UIImage imageNamed:imageName];
			[[self view] addSubview:[conditionTypeViewController view]];
		}
		else{
			[conditionTypeViewController conditionTypeView].conditionImage.image = [UIImage imageNamed:imageName];
		}
		
		[UIView commitAnimations];
		NSDictionary* dict = [NSDictionary dictionaryWithObject:imageName forKey:@"condition"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"conditionChange" object:nil userInfo:dict];
		
	
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
		
	/*
	 *Set up the root view..
	 */
	
	CGRect aframe = CGRectMake(364,60,294,301);
	self.view = [[UIView alloc] initWithFrame: aframe];
	
	/*
	 * set up the view condition controllers
	 */
	self.conditionTypeViewController = [[ConditionTypeViewController alloc] initWithNibName:nil bundle:nil];
	self.conditionBandwidthViewController = [[ConditionBandwidthViewController alloc] initWithNibName:nil bundle:nil];
	
	/*
	 * Add one of the controller's views as a sub view...
	 */ 
	[self.view addSubview:[conditionTypeViewController view]];
	
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
