//
//  MonitorViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 05/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MonitorViewController.h"



@implementation MonitorViewController

@synthesize monitorView;
//@synthesize currentMonitorScene;
@synthesize testImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
   
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


-(void) viewDidLoad
{
       NSLog(@"VIEW DID LOAD>>>>>>>>>>>>>");
}



    // Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
  
    CGRect aframe = CGRectMake(0,0,897,301);
	UIView *rootView = [[UIView alloc] initWithFrame:aframe];	
	self.view = rootView;
	[rootView release];
    MonitorView *mview = [[MonitorView alloc] initWithFrame: CGRectMake(0,0,497,301)];
	self.monitorView = mview;
    [self.view addSubview: monitorView];
    [mview release];
    
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    NSLog(@"view            did            unload -----------");
    //[monitorView release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end