    //
//  ResultViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootResultViewController.h"


@implementation RootResultViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

-(void) conditionChange:(NSNotification *) n{
	NSDictionary *userInfo = [n userInfo];
	NSString* newscene = [Lookup lookupmonitor:[userInfo objectForKey:@"condition"]];
	
	
	if (! [currentMonitorScene isEqualToString:newscene]){
		resultView.monitorWebView.alpha = 0.0;
		NSURL *url = [NSURL URLWithString:newscene];
		NSURLRequest *requestObject = [NSURLRequest requestWithURL:url];
		[resultView.monitorWebView loadRequest:requestObject];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:resultView.monitorWebView cache:YES];
		[resultView.activityIndicatorView startAnimating];
		[UIView commitAnimations];
		currentMonitorScene = newscene;
	}
}

-(void) actionSubjectChange:(NSNotification *) n{
	
		
	NSDictionary *userInfo = [n userInfo];
	NSString* newscene = [Lookup lookupresult:[userInfo objectForKey:@"action"]];
	
	if (! [currentActionScene isEqualToString:newscene]){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:resultView.resultMainImage cache:YES];
		resultView.resultMainImage.image = [UIImage imageNamed:newscene];
		[UIView commitAnimations];
		currentActionScene = newscene;

	}
}

-(void) actionTypeChange:(NSNotification *) n{
	NSDictionary *userInfo = [n userInfo];
	NSString* controller = [userInfo objectForKey:@"controller"];
	NSLog(@"resultView.frame = %@", NSStringFromCGRect(resultView.frame));
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelegate:self];
	

	
	if ([controller isEqualToString:@"ActionBlockViewController"]){
		
				
		CGRect aframe = resultView.frame;
		aframe.origin.x += 300;
		aframe.size.width = 600;
		resultView.comicframe.frame = aframe;
		resultView.resultMainImage.alpha = 0.0;
		resultView.monitorWebView.alpha = 0.0;
		
		
	}else{
		CGRect aframe = resultView.frame;
		aframe.origin.x += 0;
		aframe.size.width = 897;
		resultView.comicframe.frame = aframe;
		resultView.resultMainImage.alpha = 1.0;
		resultView.monitorWebView.alpha = 1.0;
		
	}
	
	[UIView commitAnimations];
	
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

 currentMonitorScene = @"resultbandwidth.png";
 currentActionScene = @"dadwaiting.png";
	
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conditionChange:) name:@"conditionChange" object:nil];	
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionSubjectChange:) name:@"actionSubjectChange" object:nil];	
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionTypeChange:) name:@"actionTypeChange" object:nil];	
	
 CGRect aframe = CGRectMake(64,367,897,301);
 UIView *rootView = [[UIView alloc] initWithFrame:aframe];	
 self.view = rootView;
 [rootView release];
	
 ResultView *aview = [[ResultView alloc] initWithFrame: CGRectMake(0,0,897,301)];
 resultView = aview;
 [resultView.monitorWebView setDelegate:self];
 [self.view addSubview: resultView];
 //[aview release];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
	[resultView.activityIndicatorView stopAnimating];
	//[resultView.monitorWebView setHidden: NO];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelegate:self];
	resultView.monitorWebView.alpha = 1.0;
	[UIView commitAnimations];
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
