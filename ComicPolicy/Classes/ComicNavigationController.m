    //
//  ComicNavigationController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 28/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ComicNavigationController.h"


@implementation ComicNavigationController

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
	buttons = [[NSMutableArray alloc] init];
	[buttons addObject: [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"empty.png"]]];
	 
	CGFloat ylen = [[UIScreen mainScreen] bounds].size.height;
	
	NavigationView *tmpNav = [[NavigationView alloc] initWithFrameAndButtons:CGRectMake(0,0, ylen,40) buttons:buttons];
	UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ylen, 40)];
	
	[tmpView addSubview:tmpNav];
	[tmpNav release];
	self.view = tmpView;
	[tmpView release];
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
