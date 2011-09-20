    //
//  ActionTimeViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 04/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionTimeViewController.h"
#import "Catalogue.h"

@interface ActionTimeViewController()
-(void) updateCatalogue;
-(void) setSlider:(float) value;
@end


@implementation ActionTimeViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	CGRect aframe = CGRectMake(64,367,294,301);
	self.view = [[UIView alloc] initWithFrame: aframe];
	timeView= [[ActionTimeView alloc] initWithFrame:CGRectMake(0,0,294,301)];
    timeView.timecaption.text = @"forever!";
	
    slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 240, 274, 20.f)];
    //slider.layer.anchorPoint = CGPointMake(0.5, 0.5);
    //slider.transform = CGAffineTransformMakeRotation(M_PI  * -0.25);
    [slider setMaximumValue:24.0f];
    [slider setMinimumValue:0.0f];
    [slider setContinuous:YES];
    
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    //[slider setThumbImage:[UIImage imageNamed:@"clockfacesmall.png"] forState:UIControlStateNormal];
    [timeView addSubview:slider];
    [self update];
    [self.view addSubview:timeView];
	[timeView release];
}

-(void) setSlider:(float) value{
    
    timeView.dark.alpha = value / [slider maximumValue]; 
    timeView.light.alpha = 1 - (value / [slider maximumValue]);
    
    slider.value =  round(value);
    if (slider.value == 0){
        timeView.timecaption.text = @"forever!";
    }else if (slider.value == 24){
        timeView.timecaption.text = @"for a whole day";
    }
    else{
        timeView.timecaption.text = [NSString stringWithFormat:@"for %0.f hours", slider.value];
    }
}

-(void) update{

    NSDictionary *dict = [[Catalogue sharedCatalogue] actionArguments];
    NSLog(@"in update and dict is %@", dict);
    NSString* timeframe = [dict objectForKey:@"timeframe"];
        if (timeframe == nil)
        [self setSlider:0];
    else{
        [self setSlider:[timeframe floatValue]];
    }
    

}

-(void) sliderAction:(UISlider*)sender{
    
    [self setSlider:[sender value]];
    [self updateCatalogue];
}



-(void) updateCatalogue{
    
    NSNumber* duration = [NSNumber numberWithFloat: (round([slider value])) * 60];
    
    NSMutableDictionary *newargs = [[NSMutableDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects: [duration stringValue], nil] forKeys:[[NSArray alloc] initWithObjects:@"timeframe",nil]];
    
    //NSMutableDictionary *newargs = [[Catalogue sharedCatalogue] actionArguments];
    
    //[newargs setObject:[NSNumber numberWithFloat:round([slider value])] forKey:@"timeframe"];
    
    [[Catalogue sharedCatalogue] setActionArguments:newargs];
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
