    //
//  ConditionTypeViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 24/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionTypeViewController.h"


@implementation ConditionTypeViewController

@synthesize conditionTypeView;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		CGRect nframe = CGRectMake(0,0,294,301);
		ConditionTypeView *aconditionview = [[ConditionTypeView alloc] initWithFrame: nframe];
		self.conditionTypeView = aconditionview;
		self.view = aconditionview;
		[aconditionview release];
	}
	return self;
}

/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"got touched at  condition  type controller");
	//Maybe chain the interaction rather than push up to superview??
	[super touchesBegan:touches withEvent:event];
}*/
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

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
