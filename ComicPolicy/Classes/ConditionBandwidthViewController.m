    //
//  ConditionBandwidthViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 24/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionBandwidthViewController.h"


@implementation ConditionBandwidthViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		
        // Custom initialization
		CGRect aframe = CGRectMake(0,0,294,301);
		ConditionBandwidthView *aconditionbandwidthview = [[ConditionBandwidthView alloc] initWithFrame: aframe];
		//is this needed??
		conditionBandwidthView = aconditionbandwidthview;
		self.view = aconditionbandwidthview;
		
		UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
		[self.view addGestureRecognizer:pinchGestureRecognizer];
		[pinchGestureRecognizer release];
		
		[aconditionbandwidthview release];
		
    }
    return self;
}


-(void) handlePinch:(UIGestureRecognizer *) gesture {
	
	UIView *view = conditionBandwidthView.moneyImage;
	
	UIPinchGestureRecognizer *pinchGesture = (UIPinchGestureRecognizer *) gesture;
	if (view.frame.size.width >= 165 &&  pinchGesture.scale > 1)
		return;
	if (view.frame.size.width <= 30 &&  pinchGesture.scale < 1)
		return;
	
	if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state == UIGestureRecognizerStateChanged) {
		
		//pinchGesture.view;
		NSLog(@"scale is %f", pinchGesture.scale);
		view.transform = CGAffineTransformScale(view.transform, pinchGesture.scale, pinchGesture.scale);
		pinchGesture.scale = 1;
		NSLog(@"view scale is %3.0f, %3.0f", view.frame.size.width, view.frame.size.height);
		
	}
	
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self.view];
	
	if (! CGRectContainsPoint(conditionBandwidthView.moneyImage.bounds, touchLocation)){
	//if( [touches count] == 1){
		[super touchesBegan:touches withEvent:event];
		
	}
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
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
