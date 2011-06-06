    //
//  ActionBlockViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 28/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionBlockViewController.h"
#import "Catalogue.h"

@implementation ActionBlockViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionChange:) name:@"actionChange" object:nil];	
		
		CGRect aframe = CGRectMake(0,20,294,321);
	
		NSString *topImage = [[Catalogue sharedCatalogue ]currentActionSubjectImage];
		NSString *bottomImage = [[Catalogue sharedCatalogue] currentActionImage];

       
		ActionBlockView *aview = [[ActionBlockView alloc] initWithFrameAndImages:aframe topImage:topImage bottomImage:bottomImage];//
		actionBlockView = aview;
		self.view = aview;
		[aview release];		
    }
    return self;
}

-(void) actionChange:(NSNotification *) n{
	
	NSString* deviceImage = [[Catalogue sharedCatalogue] currentActionImage];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelay:0.75];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:actionBlockView.blockImage cache:YES];
	actionBlockView.blockImage.image = [UIImage imageNamed:deviceImage];
	[UIView commitAnimations];	
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	
	
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self.view];
	
	if (CGRectContainsPoint(actionBlockView.personImage.frame, touchLocation)){
		
		NSString* personImage = [[Catalogue sharedCatalogue] nextActionSubjectImage];		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:actionBlockView.personImage cache:YES];
		actionBlockView.personImage.image = [UIImage imageNamed:personImage];
		[UIView commitAnimations];
		
		
	}
	else if (CGRectContainsPoint(actionBlockView.blockImage.frame, touchLocation)){
		NSString* deviceImage = [[Catalogue sharedCatalogue] nextActionImage];		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:actionBlockView.blockImage cache:YES];
		actionBlockView.blockImage.image = [UIImage imageNamed:deviceImage];
		[UIView commitAnimations];
		
	}
	[super touchesBegan:touches withEvent:event];
	
}





// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*- (void)loadView {
	

}*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
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
