    //
//  SubjectViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubjectViewController.h"


@implementation SubjectViewController

//static SubjectImageLookup *lookup;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self.view];	
	
	if (CGRectContainsPoint(subjectView.topImage.frame, touchLocation)){
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:subjectView.topImage cache:NO];
		subjectView.topImage.image = [UIImage imageNamed: [[Catalogue sharedCatalogue] nextSubjectOwnerImage]];
		[UIView commitAnimations];
	}
	else if (CGRectContainsPoint(subjectView.bottomImage.frame, touchLocation)){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:subjectView.bottomImage cache:NO];
		subjectView.bottomImage.image = [UIImage imageNamed:[[Catalogue sharedCatalogue] nextSubjectDeviceImage]];
		[UIView commitAnimations];
	}


		
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	
	
	//lookup = [[SubjectImageLookup alloc] init];
	CGRect aframe = CGRectMake(64,60,294,301);
	SubjectView *aview = [[SubjectView alloc] initWithFrame:aframe];//  lookup:nil];//
	subjectView = aview;
	self.view = subjectView;
	[aview release];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectOwnerChange:) name:@"subjectOwnerChange" object:nil];	

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectOwnerLoaded:) name:@"subjectOwnerLoaded" object:nil];
}

-(void) subjectOwnerLoaded:(NSNotification *) n{
    //[UIView beginAnimations:nil context:nil];
	//[UIView setAnimationDuration:0.75];
	//[UIView setAnimationDelay:0.70];
	//[UIView setAnimationDelegate:self];
	
	//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:subjectView.bottomImage cache:NO];
	subjectView.topImage.image = [UIImage imageNamed:[[Catalogue sharedCatalogue] currentSubjectOwnerImage]];
	subjectView.bottomImage.image = [UIImage imageNamed:[[Catalogue sharedCatalogue] currentSubjectDeviceImage]];
	//[UIView commitAnimations];
}

-(void) subjectOwnerChange:(NSNotification *) n{
	
	
  	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelay:0.70];
	[UIView setAnimationDelegate:self];
	//[UIView setAnimationWillStartSelector:@selector(playSound:finished:context:)];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:subjectView.bottomImage cache:NO];
	
	subjectView.bottomImage.image = [UIImage imageNamed:[[Catalogue sharedCatalogue] currentSubjectDeviceImage]];
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
