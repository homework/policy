//
//  ActionPrioritiseViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 09/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionPrioritiseViewController.h"
#import "math.h"
#import "Catalogue.h"

@implementation ActionPrioritiseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect aframe = CGRectMake(0,20,294,321);
        
        NSString *topImage = [[Catalogue sharedCatalogue ]currentActionSubjectImage];
        
		NSLog(@"top image is %@", topImage);
        ActionPrioritiseView *aview = [[ActionPrioritiseView alloc] initWithFrameAndImage:aframe topImage:topImage];
		
        slider = [[UISlider alloc] initWithFrame:CGRectMake(-70.0f, 150.0f, 200.0f, 20.f)];
        
        [slider setMaximumValue:2.0f];
        [slider setMinimumValue:0.0f];
        slider.layer.anchorPoint = CGPointMake(0.5,0.5); 
        slider.transform = CGAffineTransformMakeRotation(M_PI * -0.5);
        [slider setContinuous:NO];
        
        [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [slider setThumbImage:[UIImage imageNamed:@"greenup.png"] forState:UIControlStateNormal];
        [aview addSubview:slider];
        
        
        self.view = aview;
		[aview release];
    }
    return self;
}

-(void) sliderAction:(UISlider*)sender{
    //CGFloat value = [sender value];
    slider.value =  round([sender value]);
    
    
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

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
