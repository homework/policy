//
//  ComicPolicyViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ComicPolicyViewController.h"

@implementation ComicPolicyViewController



/* The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    }
    return self;
}*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
	
	subjectViewController = [[SubjectViewController alloc] init];
	[self.view addSubview:subjectViewController.view];
	
	
	eventViewController = [[RootConditionViewController alloc] init];
	[self.view addSubview:eventViewController.view];
	
	
	actionViewController = [[ActionViewController alloc] init];
	[self.view addSubview:actionViewController.view];
	
	
	resultViewController = [[ResultViewController alloc] init];
	[self.view addSubview:resultViewController.view];
	
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
