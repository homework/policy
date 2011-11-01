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
    
    routerConnectionView = [[RouterConnectionView alloc] initWithFrame:CGRectMake(0, 0, appFrame.size.height + 20, appFrame.size.width )];
    
    routerConnectionView.caption.text = [NSString stringWithFormat:@"Getting catalogue from router \n [%@]", [[NetworkManager sharedManager] rootURL]]; 
    
    self.view = routerConnectionView;
    
    exitButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exit.png"]];
    exitButton.frame = CGRectMake(appFrame.size.height -150, appFrame.size.width -150, exitButton.frame.size.width, exitButton.frame.size.height);
    [self.view addSubview:exitButton];
}

-(void) updateCaption:(NSString *) text{
    routerConnectionView.caption.text = text;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
        
    if (CGRectContainsPoint(exitButton.frame, touchLocation)){
        exit(1);
    }
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
