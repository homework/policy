//
//  ResultViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootResultViewController.h"
#import "Catalogue.h"

@implementation RootResultViewController
@synthesize resultController;
@synthesize monitorController;

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
	
    NSString* newscene = [[Catalogue sharedCatalogue] getConditionResultImage:[userInfo objectForKey:@"condition"]];
    
    NSString *newcontroller = [[Catalogue sharedCatalogue] getConditionResultController:[userInfo objectForKey:@"condition"]];
    NSLog(@"new controller is %@", newcontroller);
    
    MonitorViewController *newController = [[NSClassFromString(newcontroller) alloc] initWithNibName:nil bundle:nil];

	

	//if (! [currentController.currentMonitorScene isEqualToString:newscene]){
        NSLog(@"-----> loading up %@", newscene);
        [UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view/*monitorController.monitorView.monitorImage*/ cache:YES];
		monitorController.monitorView.monitorImage.image = [UIImage imageNamed:newscene];
        monitorController.currentMonitorScene = newscene;
        
       
        [UIView commitAnimations];
     [[self view] addSubview:[newController view]];
    [currentMonitorViewController.view removeFromSuperview];
    [currentMonitorViewController release];
        currentMonitorViewController = newController;
	//}
}

-(void) actionSubjectChange:(NSNotification *) n{
	
	NSDictionary *userInfo = [n userInfo];
    NSString *newscene =  [[Catalogue sharedCatalogue] getActionResultImage:[userInfo objectForKey:@"action"] action:[userInfo objectForKey:@"type"]];
	
	if (newscene != NULL){
		//if (! [currentController.currentActionScene isEqualToString:newscene]){
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.75];
			//[UIView setAnimationDelay:0.70];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:resultController.resultView.resultMainImage cache:YES];
			resultController.resultView.resultMainImage.image = [UIImage imageNamed:newscene];
			[UIView commitAnimations];
			resultController.currentActionScene = newscene;
		//}
	}
}

-(void) actionTypeChange:(NSNotification *) n{
	NSDictionary *userInfo = [n userInfo];
	NSString* controller = [userInfo objectForKey:@"controller"];
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	//[UIView setAnimationDelay:0.70];
	[UIView setAnimationDelegate:self];
	
	if ([controller isEqualToString:@"ActionBlockViewController"]){
		
        CGRect aframe = resultController.resultView.frame;
		aframe.origin.x = 300;
		aframe.size.width = 600;
		resultController.resultView.comicframe.frame = aframe;
		resultController.resultView.resultMainImage.alpha = 1.0;
		monitorController.monitorView.monitorImage.alpha = 1.0;
		aframe = monitorController.monitorView.monitorImage.frame;
		aframe.origin.x = 300;
		monitorController.monitorView.monitorImage.frame = aframe;
		
		
	}else{
        CGRect aframe = resultController.resultView.frame;
		aframe.size.width = 897;
		resultController.resultView.comicframe.frame = aframe;
		resultController.resultView.resultMainImage.alpha = 1.0;
		aframe = monitorController.monitorView.monitorImage.frame;
		aframe.origin.x = 0;
		monitorController.monitorView.monitorImage.frame = aframe;
		monitorController.monitorView.monitorImage.alpha = 1.0;
	}
	
	[UIView commitAnimations];
	
}

- (void)stopped:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	NSLog(@"stopped....");
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
   
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conditionChange:) name:@"conditionChange" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionSubjectChange:) name:@"actionSubjectChange" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionTypeChange:) name:@"actionTypeChange" object:nil];	
	
		
	CGRect aframe = CGRectMake(64,367,897,301);
	UIView *rootView = [[UIView alloc] initWithFrame:aframe];	
	self.view = rootView;
	[rootView release];
	
	ResultViewController *tmpResultController = [[[NSClassFromString(@"ResultViewController") alloc] initWithNibName:nil bundle:nil] retain];
   
    MonitorViewController *tmpMonitorController = [[[NSClassFromString(@"MonitorViewController") alloc] initWithNibName:nil bundle:nil] retain];

       [[self view] addSubview:[tmpMonitorController view]];
	[[self view] addSubview:[tmpResultController view]];
 
	resultController = tmpResultController;
	monitorController = tmpMonitorController;
    
    
    //[newController release];
	
	/*
	ResultView *aview = [[ResultView alloc] initWithFrame: CGRectMake(0,0,897,301)];
	resultView = aview;
	[resultView.monitorWebView setDelegate:self];
	[self.view addSubview: resultView];
	//[aview release];
	 */
}

/*
-(void) webViewDidFinishLoad:(UIWebView *)webView{
	[currentController.resultView.activityIndicatorView stopAnimating];
	//[resultView.monitorWebView setHidden: NO];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelegate:self];
	currentController.resultView.monitorWebView.alpha = 1.0;
	[UIView commitAnimations];
}*/

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
