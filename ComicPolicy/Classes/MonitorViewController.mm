//
//  MonitorViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 05/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MonitorViewController.h"
#import "PositionManager.h"



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
     
}



    // Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
  /*
    CGRect aframe = CGRectMake(0,0,897,301);
	UIView *rootView = [[UIView alloc] initWithFrame:aframe];	
	self.view = rootView;
	[rootView release];
    self.view.backgroundColor = [UIColor blackColor];
    MonitorView *mview = [[MonitorView alloc] initWithFrame: [[PositionManager sharedPositionManager] getPosition:@"resultmonitor"]];//CGRectMake(0,0,497,301)];
	self.monitorView = mview;
    [self.view addSubview: monitorView];
    monitorView.backgroundColor = [UIColor purpleColor];
    [mview release];
 */
    
    /*CGRect aframe = CGRectMake(0,0,897,301);
	UIView *rootView = [[UIView alloc] initWithFrame:aframe];	  	
	self.view = rootView;
    [rootView release];
    
    CGRect frame =  [[PositionManager sharedPositionManager] getPosition:@"resultmonitor"];
	*/
	
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
