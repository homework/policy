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

@interface ActionPrioritiseViewController()
-(void) updateCatalogue:(int)pint;
-(void) updateSlider:(NSString*) priority;
@end

@implementation ActionPrioritiseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        CGRect aframe = CGRectMake(0,20,294,321);
        
        NSString *topImage = [[Catalogue sharedCatalogue ]currentActionSubjectImage];
        
	
        prioritiseview = [[ActionPrioritiseView alloc] initWithFrameAndImage:aframe topImage:topImage];
		
        slider = [[UISlider alloc] initWithFrame:CGRectMake(40.0f, 220.0f, 200.0f, 20.f)];
        
        [slider setMaximumValue:2.0f];
        [slider setMinimumValue:0.0f];
        [slider setContinuous:NO];
        
        [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
       // [slider setThumbImage:[UIImage imageNamed:@"greenup.png"] forState:UIControlStateNormal];
        [prioritiseview addSubview:slider];
        
        NSDictionary *args = [[Catalogue sharedCatalogue] actionArguments];
        
        [self updateSlider:[args objectForKey:@"priority"]];
        [self updateCatalogue:slider.value];
        prioritiseview.prioritisedevicecaption.text = [NSString stringWithFormat:@"give %@", [[Catalogue sharedCatalogue ]currentActionSubjectName]];
        

        self.view = prioritiseview;
		[prioritiseview release];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	
	
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self.view];

    if (CGRectContainsPoint(prioritiseview.deviceImage.frame, touchLocation)){
        prioritiseview.prioritisedevicecaption.alpha = 0.0;
		NSString* deviceImage = [[Catalogue sharedCatalogue ]nextActionSubjectImage];	
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(addCaptions:finished:context:)];
        
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:prioritiseview.deviceImage cache:YES];
		prioritiseview.deviceImage.image = [UIImage imageNamed:deviceImage];
		[UIView commitAnimations];
		
	}
	[super touchesBegan:touches withEvent:event];


}

-(void) updateCatalogue:(int)pint{
    
    NSString* priority = @"low";
    
   
    if (pint== 1)
        priority = @"medium";
    else if (pint==2)
        priority = @"high";
    
    NSMutableDictionary *newargs = [[[NSMutableDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:priority, nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"priority",nil] autorelease]] autorelease];
    
    [[Catalogue sharedCatalogue] setActionArguments:newargs];
}

- (void)addCaptions:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    prioritiseview.prioritisedevicecaption.alpha = 1.0;

    prioritiseview.prioritisedevicecaption.text = [NSString stringWithFormat:@"give %@", [[Catalogue sharedCatalogue ]currentActionSubjectName]];    
    
}

-(void) updateSlider:(NSString *) priority{
   
    if ([priority isEqualToString:@"medium"]){
        slider.value =  1;
    }
    else if ([priority isEqualToString:@"high"]){
        slider.value = 2;
    }else{
        priority = @"low";
        slider.value = 0;
    }
    prioritiseview.prioritiseamountcaption.text = [NSString stringWithFormat:@"%@ priority for 30 min", priority];
}

-(void) sliderAction:(UISlider*)sender{
    //CGFloat value = [sender value];
    slider.value =  round([sender value]);
    
    if (slider.value == 1){
        [self updateSlider:@"medium"];
    }else if (slider.value == 2){
         [self updateSlider:@"high"];
    }else{
        [self updateSlider:@"low"];
    }
    
    [self updateCatalogue:slider.value];
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
