    //
//  EventViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ConditionViewController


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
	
	if (CGRectContainsPoint(conditionView.conditionImage.frame, touchLocation)){
		
		NSString* imageName = [conditionImages objectAtIndex:++conditionImageIndex % [conditionImages count]];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:conditionView.conditionImage cache:YES];
		conditionView.conditionImage.image = [UIImage imageNamed:imageName];
		[UIView commitAnimations];
		NSDictionary* dict = [NSDictionary dictionaryWithObject:imageName forKey:@"condition"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"conditionChange" object:nil userInfo:dict];
		
		/*
		
		NSString* imageName = [conditionImages objectAtIndex:++conditionImageIndex % [conditionImages count]];
		conditionView.conditionImage.image = [UIImage imageNamed:imageName];
		CATransition *transition = [CATransition animation];
		transition.duration = 1.0f;
		transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		transition.type = kCATransitionFade;
		[conditionView.conditionImage.layer addAnimation:transition forKey:nil]; */
		
	}
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	conditionImageIndex = 0;
	conditionImages = [[NSMutableArray alloc] initWithObjects:@"surfing.png",@"downloading.png",@"gaming.png",@"streaming.png",@"timed.png", @"bandwidth.png", @"visiting.png",nil];
	
	CGRect aframe = CGRectMake(364,60,294,301);
	ConditionView *aview = [[ConditionView alloc] initWithFrame: aframe];//
	conditionView = aview;
	self.view = conditionView;
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
