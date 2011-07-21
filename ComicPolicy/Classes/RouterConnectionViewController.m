//
//  RouterConnectionViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 18/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RouterConnectionViewController.h"
#import "NetworkManager.h"

@implementation RouterConnectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    
    RouterConnectionView *aview = [[RouterConnectionView alloc] initWithFrame:CGRectMake(0, 0, appFrame.size.height + 20, appFrame.size.width )];
    
    aview.caption.text = [NSString stringWithFormat:@"Getting catalogue from router \n [%@]", [[NetworkManager sharedManager] rootURL]]; 
    
    self.view = aview;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
