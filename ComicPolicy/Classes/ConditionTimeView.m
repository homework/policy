//
//  ConditionTimeView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionTimeView.h"


@implementation ConditionTimeView

@synthesize fromClockFace;
@synthesize toClockFace;



BOOL fromScaled = NO;
BOOL toScaled = NO;

/*
 * NB: ImageView subviews are NOT passed touch events i.e. TouchesBegan etc will not be called!
 */


- (id)initWithFrameAndImage:(CGRect)frame image:(NSString *)image{
	if ((self = [super initWithFrame:frame])) {
		hour    = 0;
        minute  = 0;
		clockFromFrame = CGRectMake(5,93,120,121);
		
		clockToFrame= CGRectMake(164,11,120,121);
		
        UIImageView *tmpImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
		self.mainImage = tmpImage;
		[self addSubview:mainImage];
		[tmpImage release];
		
		
		UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame.png"]];
		[self addSubview:tmpframe];
		[tmpframe release];
		
		
		fromClockFace = [[UIView alloc] initWithFrame:clockFromFrame];
		UIImageView* tmpfromclock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clockface2.png"]];
		tmpfromclock.frame = CGRectMake(0,0,120,121);
		[fromClockFace addSubview:tmpfromclock];
		[tmpfromclock release];
		
		fhh = [[HandView alloc] initWithFrameAndImage:CGRectMake(56,36,11,51) image:@"hour2.png"];
		[fromClockFace addSubview:fhh];
		[fhh release];
		
		fmh = [[HandView alloc] initWithFrameAndImage:CGRectMake(56,32,11,60) image:@"minute2.png"];
		[fromClockFace addSubview:fmh];
		[fmh release];
		
		[self addSubview:fromClockFace];
		
		
		toClockFace = [[UIView alloc] initWithFrame:clockToFrame];
		UIImageView* tmptoclock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clockface2.png"]];
		tmptoclock.frame = CGRectMake(0,0,120,121);
		[toClockFace addSubview:tmptoclock];
		[tmptoclock release];
		
		thh = [[HandView alloc] initWithFrameAndImage:CGRectMake(56,36,11,51) image:@"hour2.png"];
		[toClockFace addSubview:thh];
		[thh release];
		
		tmh = [[HandView alloc] initWithFrameAndImage:CGRectMake(56,32,11,60) image:@"minute2.png"];
		[toClockFace addSubview:tmh];
		[tmh release];
		
		[self addSubview:toClockFace];
    }
    return self;
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [[event allTouches] anyObject];
	
	if ([touch view] == fhh || [touch view] == fmh || [touch view] == thh || [touch view] == tmh){
		
		UIView* container = [[touch view] superview];
		
		float centerx = (container.bounds.size.width / 2);
		float centery = (container.bounds.size.height / 2);
		
		CGPoint touchLocation = [touch locationInView: container];  
		
		float x, y;
		
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
	
		if (x > 0){
			[touch view].transform = CGAffineTransformMakeRotation(-ang + (M_PI/2));
            if ([touch view] == fhh || [touch view] == thh)
               hour =  (int)  ((-ang + (M_PI/2)) * ((float)180/M_PI)/30);
            else
               minute = (int) ((-ang + (M_PI/2)) * ((float)180/M_PI)/6);
		}else{
			[touch view].transform = CGAffineTransformMakeRotation(-ang - (M_PI/2));
            if ([touch view] == fhh || [touch view] == thh)
                hour = 11 - (int) ((-ang - (M_PI/2))  * ((float)180/M_PI) / -30);
            else
                minute = 59 - (int) ((-ang - (M_PI/2))  * ((float)180/M_PI) / -6);
		}
        
        NSLog(@"%d : %d", hour, minute);
        
	}
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
	toClockFace.userInteractionEnabled = YES;
	fromClockFace.userInteractionEnabled = YES;
	
	if ([touch view] == fhh || [touch view] == fmh || [touch view] == thh || [touch view] == tmh){
		return;
	}
	if (CGRectContainsPoint(fromClockFace.frame, touchLocation)){
		
		[fromClockFace removeFromSuperview];
		[self addSubview:fromClockFace];

		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[fromClockFace setTransform:CGAffineTransformMakeScale(2.2, 2.2)];
		CGRect frame = fromClockFace.frame;
		frame.origin.x = 5.0;
		fromClockFace.frame = frame;
		
		if (toScaled){
			[toClockFace setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
			CGRect frame = toClockFace.frame;
			frame.origin.x = 164.0;
			frame.origin.y = 10.0;
			toClockFace.frame = frame;
			toScaled = NO;
		}
		
		[UIView commitAnimations];
		toClockFace.userInteractionEnabled = NO;
		fromScaled = YES;
	}
	else if (CGRectContainsPoint(toClockFace.frame, touchLocation)){
		[toClockFace removeFromSuperview];
		[self addSubview:toClockFace];
	
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[toClockFace setTransform:CGAffineTransformMakeScale(2.2, 2.2)];
		CGRect frame = toClockFace.frame;
		frame.origin.x = 10.0;
		frame.origin.y = 10.0;
		toClockFace.frame = frame;
		
		if (fromScaled){
			[fromClockFace setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
			CGRect frame = fromClockFace.frame;
			frame.origin.x = 5.0;
			fromClockFace.frame = frame;
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
			toClockFace.userInteractionEnabled = NO;
			[fromClockFace setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
			CGRect frame = fromClockFace.frame;
			frame.origin.x = 5.0;
			fromClockFace.frame = frame;
			fromScaled = NO;
		}
		if (toScaled){
			fromClockFace.userInteractionEnabled = NO;
			[toClockFace setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
			CGRect frame = toClockFace.frame;
			frame.origin.x = 164.0;
			frame.origin.y = 10.0;
			toClockFace.frame = frame;
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
	[fromClockFace setTransform:CGAffineTransformMakeTranslation(50.0, 0.0)];
	[UIView commitAnimations];
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
 - (void)drawRect:(CGRect)rect {

}*/


- (void)dealloc {
    [super dealloc];
	[fromClockFace release];
}


@end
