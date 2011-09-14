//
//  ConditionVisitingTimeViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 13/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionVisitingTimeViewController.h"


@implementation ConditionVisitingTimeViewController

bool timerangeselected = false;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        self.view.frame = [[PositionManager sharedPositionManager] getPosition:@"conditionvisitingtime"];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touched something...");
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self.view];
	NSLog(@"touch location y is %f", touchLocation.y);
    if ( touchLocation.y > 250){
        if ([conditionTimeView.caption.text isEqualToString:@"at any time"]){
            [self updateCaption];
        }
        else{
            conditionTimeView.caption.text = @"at any time";
            timerangeselected = false;
            [self updateCatalogue];
            NSLog(@"setting time range selected to false");
        }
    }
    [super touchesBegan:touches withEvent:event];
}


-(void) updateCaption{
    NSLog(@"in update caption..");
    timerangeselected = true;
    conditionTimeView.caption.text = [NSString stringWithFormat:@"between %02d:%02d and %02d:%02d",  fromhour, fromminute, tohour, tominute];
    
}

-(void) updateCatalogue{
    
    NSLog(@"in update catalogue..and time range selected is %@", timerangeselected ? @"TRUE": @"FALSE");
    NSString *from = [NSString stringWithFormat:@"%02d:%02d", fromhour, fromminute];
    NSString *to = [NSString stringWithFormat:@"%02d:%02d", tohour, tominute];
    
    
    NSMutableDictionary *newargs = [[Catalogue sharedCatalogue] conditionArguments];
    
    if (timerangeselected == true){
        [newargs setObject:from forKey:@"from"];
        [newargs setObject:to forKey:@"to"];
    }else{
        NSLog(@"removing objects from and to");
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
