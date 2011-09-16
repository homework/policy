    //
//  ActionNotifyViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 28/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionNotifyViewController.h"
#import "Catalogue.h"

@implementation ActionNotifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionChange:) name:@"actionChange" object:nil];	
		
		CGRect aframe = CGRectMake(0,20,294,321);
		 NSString *topImage = [[Catalogue sharedCatalogue] currentActionSubjectImage];
		NSString *bottomImage = [[Catalogue sharedCatalogue ]currentActionImage];
		
		ActionNotifyView *aview = [[ActionNotifyView alloc] initWithFrameAndImages:aframe topImage:topImage bottomImage:bottomImage];
		actionNotifyView = aview;
		self.view = aview;
		[aview release];
		
			
	}
    return self;
}


-(void) actionChange:(NSNotification *) n{
	
    NSString *notificationImage = [[Catalogue sharedCatalogue] currentActionImage];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:actionNotifyView.notifyImage cache:YES];
    actionNotifyView.notifyImage.image = [UIImage imageNamed:notificationImage];
    [UIView commitAnimations];
    

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
		
		NSString* personImage = [[Catalogue sharedCatalogue] nextActionSubjectImage];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:actionNotifyView.personImage cache:YES];
		actionNotifyView.personImage.image = [UIImage imageNamed:personImage];
		[UIView commitAnimations];
		
	}
	else if (CGRectContainsPoint(actionNotifyView.notifyImage.frame, touchLocation)){
		
		NSString *nextImage = [[Catalogue sharedCatalogue] nextActionImage];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:actionNotifyView.notifyImage cache:YES];
		actionNotifyView.notifyImage.image = [UIImage imageNamed:nextImage];
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
