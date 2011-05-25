    //
//  ResultViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 05/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultViewController.h"


@implementation ResultViewController

@synthesize currentActionScene;
@synthesize resultView;

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
	
	currentActionScene = @"dadwaiting.png";
	
	CGRect aframe = CGRectMake(0,0,897,301);
	UIView *rootView = [[UIView alloc] initWithFrame:aframe];	
	self.view = rootView;
	[rootView release];
	
	ResultView *aview = [[ResultView alloc] initWithFrame: CGRectMake(0,0,897,301)];
	resultView = aview;
	
	
	[self.view addSubview: resultView];
	
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
    //[resultView release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
