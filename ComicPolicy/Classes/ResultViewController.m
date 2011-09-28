    //
//  ResultViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 05/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultViewController.h"
#import "PositionManager.h"

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
	
    BOOL hasFired = [[PolicyManager sharedPolicyManager] hasFiredForSubject:[[Catalogue sharedCatalogue] currentActionSubject]];
    
    ///TODO NB:  setting this to the shared catalogue dict will mean that the dict is cleaned up when this is dealloced
    //and will result in referening a dereferenced pointer....
    
	currentActionScene =  @"";//[[Catalogue sharedCatalogue] getActionResultImage:hasFired];/// @"dadwaiting.png";
    
	    
    /*CGRect aframe = [[PositionManager sharedPositionManager] getPosition:@"resultmonitor"];
	UIView *rootView = [[UIView alloc] initWithFrame:aframe];		
    [rootView setAutoresizesSubviews:YES];
	self.view = rootView;
    [rootView release];*/
    
	//CGRect aframe = CGRectMake(300,0,497,301);
    CGRect aframe = [[PositionManager sharedPositionManager] getPosition:@"result"];
	UIView *rootView = [[UIView alloc] initWithFrame:aframe];	  	
	self.view = rootView;
    [rootView release];
	
	ResultView *aview = [[ResultView alloc] initWithFrame: CGRectMake(0,0,aframe.size.width, aframe.size.height)];
	resultView = aview;
    [resultView setAutoresizesSubviews:YES];
    
    UIImageView *tmpBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    tmpBack.autoresizingMask = UIViewContentModeScaleAspectFit | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tmpBack.frame = CGRectMake(0, 0, resultView.frame.size.width, resultView.frame.size.height);
	[resultView addSubview:tmpBack];
    
    
    UIImageView *tmpscene = [[UIImageView alloc] initWithImage:[UIImage imageNamed:currentActionScene]];
    tmpscene.autoresizingMask = UIViewContentModeScaleAspectFit | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   
    [resultView addSubview:tmpscene];
     tmpscene.frame = CGRectMake(0, 0, resultView.frame.size.width, resultView.frame.size.height);
    resultView.resultMainImage = tmpscene;
    [tmpscene release];
    
	[self.view addSubview: resultView];
	[aview release];
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
