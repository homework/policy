    //
//  SubjectViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubjectViewController.h"


@implementation SubjectViewController

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
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:subjectView.topImage cache:YES];
		subjectView.topImage.image = [UIImage imageNamed:[peopleImages objectAtIndex:++peopleImageIndex % [peopleImages count]]];
		[UIView commitAnimations];
		/*subjectView.topImage.image = [UIImage imageNamed:[peopleImages objectAtIndex:++peopleImageIndex % [peopleImages count]]];
		CATransition *transition = [CATransition animation];
		transition.duration = 1.0f;
		transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		transition.type = kCATransitionPush;
		[subjectView.topImage.layer addAnimation:transition forKey:nil]; */
		
	}
	else if (CGRectContainsPoint(subjectView.bottomImage.frame, touchLocation)){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:subjectView.bottomImage cache:YES];
		subjectView.bottomImage.image = [UIImage imageNamed:[deviceImages objectAtIndex:++deviceImageIndex % [deviceImages count]]];
		[UIView commitAnimations];
		
		/*
		subjectView.bottomImage.image = [UIImage imageNamed:[deviceImages objectAtIndex:++deviceImageIndex % [deviceImages count]]];
		CATransition *transition = [CATransition animation];
		transition.duration = 1.0f;
		transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		transition.type = kCATransitionFade;
		[subjectView.bottomImage.layer addAnimation:transition forKey:nil]; */
	}


		
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	peopleImageIndex = 0;
	peopleImages = [[NSMutableArray alloc] initWithObjects:@"dad.png",@"mum.png",@"katie.png",@"john.png",@"everyone.png",nil];
	
	deviceImageIndex = 0;
	deviceImages = [[NSMutableArray alloc] initWithObjects:@"condcomputer.png",@"condphone.png",@"condlaptop.png",@"conddesktop.png",@"conddevices.png",nil];
	
	CGRect aframe = CGRectMake(64,60,294,301);
	SubjectView *aview = [[SubjectView alloc] initWithFrame: aframe];//
	subjectView = aview;
	self.view = subjectView;
	//self.view.delegate = self;
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
