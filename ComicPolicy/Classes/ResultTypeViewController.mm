    //
//  ResultTypeViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 06/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultTypeViewController.h"


@implementation ResultTypeViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)loadView
{
    /*
     * TODOD CALL SuperViewDid
     */
    //self.testImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok.png"]];
    //[self.view addSubview:testImage];
    //currentMonitorScene = @"resultvisits.png";
    CGRect aframe = CGRectMake(0,0,897,301);
	UIView *rootView = [[UIView alloc] initWithFrame:aframe];	
	self.view = rootView;
	[rootView release];
    MonitorView *mview = [[MonitorView alloc] initWithFrameAndImage: CGRectMake(0,0,497,301) image:@"resulttype.png"];
	self.monitorView = mview;
    [mview release];
    [self.view addSubview: monitorView];
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
    [monitorView release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
