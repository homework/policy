//
//  ConditionVisitingTimeViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 13/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionVisitingTimeViewController.h"

@interface ConditionVisitingTimeViewController() 
-(void) updateSelected;
@end

@implementation ConditionVisitingTimeViewController

bool timerangeselected = false;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    [self setUpConditionView];
    [self initialiseClocks];
    
    self.view.frame = [[PositionManager sharedPositionManager] getPosition:@"conditionvisitingtime"];
   
    [self updateSelected];
    [self updateCaption];
       return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void) updateSelected{
    NSLog(@"in update selected condition args are %@", [[Catalogue sharedCatalogue] conditionArguments]);
    if ([[[Catalogue sharedCatalogue] conditionArguments] objectForKey:@"from"] == nil){
        timerangeselected = false;
    }else{
        timerangeselected = true;
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self.view];
	
    if ( touchLocation.y > 250){
        timerangeselected = !timerangeselected;
        [self updateCaption];
    }
    //if (timerangeselected)
        [self updateCatalogue];
    
    [super touchesBegan:touches withEvent:event];
}


-(void) updateCaption{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    if (!timerangeselected){
        conditionTimeView.caption.text = @"at any time";
        conditionTimeView.fromClockFace.alpha = 0.0;
        conditionTimeView.toClockFace.alpha = 0.0;
        conditionTimeView.fmh.alpha = 0.0;
        conditionTimeView.tmh.alpha = 0.0;
        conditionTimeView.fhh.alpha = 0.0;
        conditionTimeView.thh.alpha = 0.0;
        conditionTimeView.fromAMPM.alpha = 0.0;
        conditionTimeView.toAMPM.alpha = 0.0;
    }
    else{
        conditionTimeView.caption.text = [NSString stringWithFormat:@"between %02d:%02d and %02d:%02d",  fromhour, fromminute, tohour, tominute];
        conditionTimeView.fromClockFace.alpha = 1.0;
        conditionTimeView.toClockFace.alpha = 1.0;
        conditionTimeView.fmh.alpha = 1.0;
        conditionTimeView.tmh.alpha = 1.0;
        conditionTimeView.fhh.alpha = 1.0;
        conditionTimeView.thh.alpha = 1.0;
        conditionTimeView.fromAMPM.alpha = 1.0;
        conditionTimeView.toAMPM.alpha = 1.0;

   }
    [UIView commitAnimations];
}

-(void) initialiseClocks{
    /*
     * this can be called from the root controller (ComicPolicyViewController) so only
     * do the init if the current condition is visiting.
     */
    if (![[[Catalogue sharedCatalogue] currentCondition] isEqualToString:@"visiting"])
        return;
    
    NSLog(@"UPDATING VISTING TIME CAPTION");
    [self updateSelected];
    if (timerangeselected){
        [super initialiseClocks];
    }
    [self updateCatalogue];
   
    [self updateCaption];
}

-(void) updateCatalogue{
    

    NSString *from = [NSString stringWithFormat:@"%02d:%02d", fromhour, fromminute];
    NSString *to = [NSString stringWithFormat:@"%02d:%02d", tohour, tominute];
   
    if (fromhour == tohour && fromminute == tominute){
        if (fromminute == 59){
            fromminute = 58;
            [self setFromMinute:fromminute];
        }else{
            tominute = tominute + 1;
            [self setToMinute:tominute];
        }
    }
    
    NSMutableDictionary *newargs = [[Catalogue sharedCatalogue] conditionArguments];
    
    if (timerangeselected){
        [newargs setObject:from forKey:@"from"];
        [newargs setObject:to forKey:@"to"];
    }else{
        [newargs removeObjectForKey:@"from"];
        [newargs removeObjectForKey:@"to"];
    }
    
    
    [[Catalogue sharedCatalogue] setConditionArguments:newargs];
    
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
