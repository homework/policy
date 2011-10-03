//
//  RootConditionTimeViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 26/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootConditionTimeViewController.h"


@implementation RootConditionTimeViewController

BOOL fromScaled = NO;
BOOL toScaled = NO;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    //if ((self = [super initWithNibNameAndType:nibNameOrNil bundle:nibBundleOrNil type:@"timed"])) {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
            
        [self setUpConditionView];
        [self initialiseClocks];
        [self updateCaption];
        [self updateCatalogue];
        //[self addWeekdaySelection];
	}
    return self;
}


-(void) setUpConditionView{
    CGRect aframe = CGRectMake(0,0,294,301);
    ConditionTimeView *aconditionview = [[ConditionTimeView alloc] initWithFrame:aframe];        
    conditionTimeView = aconditionview;
    self.view = aconditionview;
}

-(void) initialiseClocks{
    
    
    [conditionTimeView.toAMPM addTarget:self action:@selector(AMPMClicked:) forControlEvents:UIControlEventTouchUpInside];
    [conditionTimeView.fromAMPM addTarget:self action:@selector(AMPMClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *from = [[[Catalogue sharedCatalogue] conditionArguments] objectForKey:@"from"];
    NSString *to = [[[Catalogue sharedCatalogue] conditionArguments] objectForKey:@"to"];
    
    NSArray *fchunks = [from componentsSeparatedByString:@":"];
    NSArray *tchunks = [to componentsSeparatedByString:@":"];                  
    
    NSString* fhstr = [fchunks objectAtIndex:0];
    NSString* fmstr = [fchunks objectAtIndex:1];
    
    NSString* thstr = [tchunks objectAtIndex:0];
    NSString* tmstr = [tchunks objectAtIndex:1];
    
    [self setFromHour: [fhstr intValue]];
    
    [self setFromMinute:[fmstr intValue]];
    
    [self setToHour: [thstr intValue]];
    
    [self setToMinute:[tmstr intValue]];
    
    
}

-(void) AMPMClicked:(id) sender{
    if (sender == conditionTimeView.toAMPM){
        if ([sender isSelected]){
            tohour -= 12;
        }else{
            tohour += 12;
        }
    }
    else if (sender == conditionTimeView.fromAMPM){
        if ([sender isSelected]){
            fromhour -= 12;
        }else{
            fromhour += 12;
        }
    }
    [self updateCaption];
    [self updateCatalogue];
    [sender setSelected:![sender isSelected]];
    
}

-(void) updateCatalogue{
    
    NSString *from = [NSString stringWithFormat:@"%02d:%02d", fromhour, fromminute];
    NSString *to = [NSString stringWithFormat:@"%02d:%02d", tohour, tominute];
   // NSArray *daysofweek = [NSArray arrayWithObjects:@"Mo", @"Tu", @"We", nil];
   //
    NSMutableDictionary *newargs = [[[NSMutableDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:from, to, nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"from", @"to",nil] autorelease]] autorelease];
    
    [[Catalogue sharedCatalogue] setConditionArguments:newargs];
    
}

-(void) updateCaption{
    conditionTimeView.caption.text = [NSString stringWithFormat:@"is used between %02d:%02d and %02d:%02d",  fromhour, fromminute, tohour, tominute];
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [[event allTouches] anyObject];
	
	if ([touch view] == conditionTimeView.fhh || [touch view] == conditionTimeView.fmh || [touch view] == conditionTimeView.thh || [touch view] == conditionTimeView.tmh){
		
		UIView* container = [[touch view] superview];
		
		float centerx = (container.bounds.size.width / 2);
		float centery = (container.bounds.size.height / 2);
		
		CGPoint touchLocation = [touch locationInView: container];  
		
		float x = 0, y =0;
		
		if (touchLocation.y > centery){
			y = -(touchLocation.y-centery);
		}
		else if (touchLocation.y < centery){
			y = centery-touchLocation.y;
		}
		
		if (touchLocation.x > centerx){
			x = touchLocation.x-centerx;
		}
		else if (touchLocation.x < centerx){
			x = -(centerx-touchLocation.x);
		}
		
		float ang = atan(y/x);
        
        int sign = (x >= 0) ? 1 : -1;
        int multiplier = (x > 0) ? 0 : 1;
        int PM = 0;
        
        if ([touch view] == conditionTimeView.fhh)
            PM = [conditionTimeView.fromAMPM isSelected] ? 12 : 0;
        else if ([touch view] == conditionTimeView.thh)
            PM = [conditionTimeView.toAMPM isSelected] ? 12 : 0;
        
        //NSLog(@"pm is %@", PM);
        
        if (x >= 0)
            [touch view].transform = CGAffineTransformMakeRotation(-ang +  (M_PI/2));
        else
            [touch view].transform = CGAffineTransformMakeRotation(-ang - (M_PI/2));
        
        if ([touch view] == conditionTimeView.fhh){ 
            fromhour = PM + (int) abs((multiplier*-6) + ((-ang + (M_PI/2)) * ((float)180/M_PI)/ (sign * 30)));
        }
        else if ([touch view] == conditionTimeView.thh){
            tohour = PM + (int) abs((multiplier*-6) + ((-ang + (M_PI/2)) * ((float)180/M_PI) / (sign * 30)));
        }
        else if ([touch view] == conditionTimeView.fmh){
            fromminute = (int) abs((-30 * multiplier) + ((-ang + (M_PI/2)) * ((float)180/M_PI)/ (sign *6)));
        }else if ([touch view] == conditionTimeView.tmh){
            tominute = (int) abs((-30 * multiplier) + ((-ang + (M_PI/2)) * ((float)180/M_PI)/ (sign *6)));
        }
        
        [self updateCaption];
        [self updateCatalogue];
        
        
	}
}

-(void) setFromHour:(int) hour{
    int deg = (int) (hour * (float)(360/12)) + 15;
    float rad = deg * (M_PI/180);
    conditionTimeView.fhh.transform = CGAffineTransformMakeRotation(rad);
    fromhour = hour;
    
    if (fromhour >= 12){
        [conditionTimeView.fromAMPM setSelected:YES];
    }else{
        [conditionTimeView.fromAMPM setSelected:NO];
    }
}

-(void) setToHour:(int) hour{
    int deg = (int) (hour * (float)(360/12)) + 15;
    float rad = deg * (M_PI/180);
    conditionTimeView.thh.transform = CGAffineTransformMakeRotation(rad);
    tohour = hour;
    
    if (tohour >= 12){
        [conditionTimeView.toAMPM setSelected:YES];
    }else{
        [conditionTimeView.toAMPM setSelected:NO];
    }
}

-(void) setFromMinute:(int) minute{
    int deg = (int) (minute * (float)(360/60));
    float rad = deg * (M_PI/180);
    conditionTimeView.fmh.transform = CGAffineTransformMakeRotation(rad);
    fromminute = minute;
}

-(void) setToMinute:(int) minute{
    int deg = (int) (minute * (float)(360/60));
    float rad = deg * (M_PI/180);
    conditionTimeView.tmh.transform = CGAffineTransformMakeRotation(rad);
    tominute = minute;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self.view];
	
	conditionTimeView.toClockFace.userInteractionEnabled = YES;
	conditionTimeView.fromClockFace.userInteractionEnabled = YES;

    
	if ([touch view] == conditionTimeView.fhh || [touch view] == conditionTimeView.fmh || [touch view] == conditionTimeView.thh || [touch view] == conditionTimeView.tmh){
		return;
	}
	if (CGRectContainsPoint(conditionTimeView.fromClockFace.frame, touchLocation)){
		
		[conditionTimeView.fromClockFace removeFromSuperview];
		[self.view addSubview:conditionTimeView.fromClockFace];
        [conditionTimeView.caption removeFromSuperview];
        [self.view addSubview:conditionTimeView.caption];
        
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[conditionTimeView.fromClockFace setTransform:CGAffineTransformMakeScale(2.2, 2.2)];
		CGRect frame = conditionTimeView.fromClockFace.frame;
		frame.origin.x = 5.0;
		conditionTimeView.fromClockFace.frame = frame;
		
		if (toScaled){
			[conditionTimeView.toClockFace setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
			CGRect frame = conditionTimeView.toClockFace.frame;
			frame.origin.x = 164.0;
			frame.origin.y = 10.0;
			conditionTimeView.toClockFace.frame = frame;
			toScaled = NO;
		}
		
		[UIView commitAnimations];
		conditionTimeView.toClockFace.userInteractionEnabled = NO;
		fromScaled = YES;
	}
	else if (CGRectContainsPoint(conditionTimeView.toClockFace.frame, touchLocation)){
		[conditionTimeView.toClockFace removeFromSuperview];
		[self.view addSubview:conditionTimeView.toClockFace];
        [conditionTimeView.caption removeFromSuperview];
        [self.view addSubview:conditionTimeView.caption];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[conditionTimeView.toClockFace setTransform:CGAffineTransformMakeScale(2.2, 2.2)];
		CGRect frame = conditionTimeView.toClockFace.frame;
		frame.origin.x = 10.0;
		frame.origin.y = 10.0;
		conditionTimeView.toClockFace.frame = frame;
		
		if (fromScaled){
			[conditionTimeView.fromClockFace setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
			CGRect frame = conditionTimeView.fromClockFace.frame;
			frame.origin.x = 5.0;
			conditionTimeView.fromClockFace.frame = frame;
			fromScaled = NO;
		}
		[UIView commitAnimations];
		
		toScaled = YES;
	}
	else if (fromScaled || toScaled){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		
		if (fromScaled){
			conditionTimeView.toClockFace.userInteractionEnabled = NO;
			[conditionTimeView.fromClockFace setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
			CGRect frame = conditionTimeView.fromClockFace.frame;
			frame.origin.x = 5.0;
			conditionTimeView.fromClockFace.frame = frame;
			fromScaled = NO;
		}
		if (toScaled){
			conditionTimeView.fromClockFace.userInteractionEnabled = NO;
			[conditionTimeView.toClockFace setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
			CGRect frame = conditionTimeView.toClockFace.frame;
			frame.origin.x = 164.0;
			frame.origin.y = 10.0;
			conditionTimeView.toClockFace.frame = frame;
			toScaled =NO;
		}
		[UIView commitAnimations];			
	}
	else{
		[super touchesBegan:touches withEvent:event];
	}
}


-(void) translate:(NSString*) animationID finished:(NSNumber *)finshed context:(void*) context{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[conditionTimeView.fromClockFace setTransform:CGAffineTransformMakeTranslation(50.0, 0.0)];
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
    [conditionTimeView release];
      
}


@end
