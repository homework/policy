    //
//  ActionNotifyViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 28/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionNotifyViewController.h"


@implementation ActionNotifyViewController

static NotifyActionImageLookup *lookup;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		CGRect aframe = CGRectMake(0,20,294,321);
		lookup = [[NotifyActionImageLookup alloc] init];
		ActionNotifyView *aview = [[ActionNotifyView alloc] initWithFrameAndLookup:aframe lookup:lookup];//
		actionNotifyView = aview;
		self.view = aview;
		[aview release];
	}
    return self;
}



/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	
		
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self.view];
	
	if (CGRectContainsPoint(actionNotifyView.personImage.frame, touchLocation)){
		
		NSString* personImage = [lookup getNextTopImage];//[personImages objectAtIndex:++personImageIndex % [personImages count]];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:actionNotifyView.personImage cache:YES];
		actionNotifyView.personImage.image = [UIImage imageNamed:personImage];
		[UIView commitAnimations];
		NSDictionary* dict = [NSDictionary dictionaryWithObject:personImage forKey:@"action"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:dict];
		
		
	}
	else if (CGRectContainsPoint(actionNotifyView.notifyImage.frame, touchLocation)){
		
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:actionNotifyView.notifyImage cache:YES];
		actionNotifyView.notifyImage.image = [UIImage imageNamed:[lookup getNextBottomImage]];// [UIImage imageNamed:[notifyImages objectAtIndex:++notifyImageIndex % [notifyImages count]]];
		[UIView commitAnimations];
		
	}
	[super touchesBegan:touches withEvent:event];

}

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
