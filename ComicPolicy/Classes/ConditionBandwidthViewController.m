    //
//  ConditionBandwidthViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 24/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionBandwidthViewController.h"

@interface ConditionBandwidthViewController() 
-(void) updateCaption;
-(void) updateCatalogue;
@end

@implementation ConditionBandwidthViewController



 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibNameAndType:nibNameOrNil bundle:nibBundleOrNil type:@"bandwidth"])) {  //add type as argument         
		CGRect aframe = CGRectMake(0,0,294,301);
		ConditionBandwidthView *aconditionview = [[ConditionBandwidthView alloc] initWithFrameAndImage:aframe image: [[Catalogue sharedCatalogue] getConditionImage]];
		conditionBandwidthView = aconditionview;
		self.view = aconditionview;
		
		
		UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
		[self.view addGestureRecognizer:pinchGestureRecognizer];
		[pinchGestureRecognizer release];
		[aconditionview release];
        bandwidth = [(NSNumber*) [[[Catalogue sharedCatalogue] conditionArguments] objectForKey:@"percentage"] intValue];
        conditionBandwidthView.moneyImage.transform =  CGAffineTransformScale(conditionBandwidthView.moneyImage.transform, (float) bandwidth/100, (float) bandwidth/100);
        [self updateCaption];
		
    }
    return self;
}




-(void) handlePinch:(UIGestureRecognizer *) gesture {
	
	UIView *view = conditionBandwidthView.moneyImage;
	
	
	if (view.frame.size.width > 165){
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		view.transform = CGAffineTransformScale(view.transform,0.8, 0.8);
		[UIView commitAnimations];
		return;
	}
	
	UIPinchGestureRecognizer *pinchGesture = (UIPinchGestureRecognizer *) gesture;
	
	if (pinchGesture.velocity > 10)
		return;
	if (view.frame.size.width >= 165 &&  pinchGesture.scale > 1)
		return;
	if (view.frame.size.width <= 30 &&  pinchGesture.scale < 1)
		return;
	
	if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state == UIGestureRecognizerStateChanged) {
		
	
		view.transform = CGAffineTransformScale(view.transform, pinchGesture.scale, pinchGesture.scale);
		pinchGesture.scale = 1;		
	}
	
	bandwidth = ((float) view.frame.size.width / 150) * 100;
	[self updateCaption];
    [self updateCatalogue];
	
	
}

-(void) updateCaption{
    conditionBandwidthView.bandwidthLabel.text = [NSString stringWithFormat:@"%d%%", bandwidth];
    conditionBandwidthView.bandwidthcaption.text = [NSString stringWithFormat:@"uses %d%% of the household limit", bandwidth];
}

-(void) updateCatalogue{
    
    NSNumber* bwidth = [NSNumber numberWithInt:bandwidth];
    NSString* captype = @"*";
    
    NSMutableDictionary *newargs = [[NSMutableDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:bwidth,captype,nil] forKeys:[[NSArray alloc] initWithObjects:@"percentage",@"captype",nil]];
    
    [[Catalogue sharedCatalogue] setConditionArguments:newargs];
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
	//[conditionBandwidthView release];
}


@end
