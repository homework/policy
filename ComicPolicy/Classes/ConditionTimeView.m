//
//  ConditionTimeView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionTimeView.h"


@implementation ConditionTimeView
@synthesize fromHourHand;
@synthesize fromMinuteHand;
@synthesize toHourHand;
@synthesize toMinuteHand;
@synthesize fromClockFace;
@synthesize toClockFace;
@synthesize fromHourView;


@synthesize initialTransform,currentValue;

BOOL fromScaled = NO;
BOOL toScaled = NO;

static CGPoint delta;
static float deltaAngle;
static float currentAngle;

/*
 * NB: ImageView subviews are NOT passed touch events i.e. TouchesBegan etc will not be called!
 */

- (id)initWithFrameAndLookup:(CGRect)frame lookup:(NSObject<ImageLookup>*)lookup{
	if ((self = [super initWithFrame:frame])) {
		
		clockFromFrame = CGRectMake(5,93,120,121);
		
		clockToFrame= CGRectMake(164,11,120,121);
		
		
		
		UIImageView *tmpImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[lookup getNextTopImage]]];
		self.mainImage = tmpImage;
		[self addSubview:mainImage];
		[tmpImage release];
		
		
		/*UIImageView *thh = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hour.png"]];
		 thh.frame = CGRectMake(219, 25, 11, 51);
		 self.fromHourHand = thh;
		 [[self.fromHourHand layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
		 self.fromHourHand.transform = CGAffineTransformMakeRotation(M_PI/12);
		 [self addSubview:thh];
		 [thh release];*/
		
		/*UIImageView *tmh = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minute.png"]];
		 tmh.frame = CGRectMake(221, 30, 11, 60);
		 self.fromMinuteHand = tmh;
		 [self addSubview:tmh];
		 [tmh release];*/	
		
		UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame.png"]];
		[self addSubview:tmpframe];
		[tmpframe release];
		
		
		fromClockFace = [[UIView alloc] initWithFrame:clockFromFrame];
		UIImageView* tmpfromclock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clockface2.png"]];
		tmpfromclock.frame = CGRectMake(0,0,120,121);
		
		[fromClockFace addSubview:tmpfromclock];
		[tmpfromclock release];
		
		fhh = [[HandView alloc] initWithFrame:CGRectMake(56,36,11,51)];
		
		//fhh = [[HandView alloc] initWithFrame:clockFromFrame];
		[fromClockFace addSubview:fhh];
		[fhh release];
		
		[self addSubview:fromClockFace];
		
		
		
		//[fhh becomeFirstResponder];
		//[rootView addSubview:fhh];
		//		[self addSubview:tmpfromclock];
		
		
		
		
		
		//UIImageView *fhh = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hour2.png"]];
		//fhh.frame = CGRectMake(55, 15, 11, 51);
		//self.fromHourHand = fhh;
		//[self addSubview:fhh];
		//[fhh release];
		
		//UIImageView *fmh = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minute2.png"]];
		//fmh.frame = CGRectMake(55, 4, 11, 60);
		//self.fromMinuteHand = fmh;
		//[self.fromClockFace addSubview:fmh];
		//[fmh release];
		
		
		
		
		//UIImageView* tmptoclock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clockface2.png"]];
		//tmptoclock.frame = clockToFrame;
		//self.toClockFace = tmptoclock;
		//[self addSubview:tmptoclock];
		//[tmptoclock release];
		
		
		NSDictionary* dict = [NSDictionary dictionaryWithObject:[lookup getCurrentTopImage] forKey:@"condition"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"conditionChange" object:nil userInfo:dict];
    }
    return self;
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint pt = [touch locationInView:fhh];
	
	if ([touch view] == fhh){
		float dx = pt.x;
		float dy = pt.y;
		float ang = atan2(dx,dy);
		CGAffineTransform newTrans = CGAffineTransformRotate(fhh.transform, ang);
		fhh.transform = newTrans;
	}
}

/*
 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 UITouch *thisTouch = [touches anyObject];
 delta = [thisTouch locationInView:self];
 
 float dx = delta.x  - fhh.center.x;
 float dy = delta.y  - fhh.center.y;
 deltaAngle = atan2(dy,dx); 
 
 //set an initial transform so we can access these properties through the rotations
 initialTransform = fhh.transform;	
 }*/


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
	if ([touch view] == fhh){
		//return;
		fhh.transform = CGAffineTransformMakeRotation([[fhh.layer valueForKeyPath:@"transform.rotation.z"] floatValue] + (2 * M_PI) / 12);
		return;
	}
	if (CGRectContainsPoint(clockFromFrame, touchLocation)){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		//[UIView setAnimationDidStopSelector:@selector(scaleUp:finished:context:)];
		//[fromClockFace setTransform:CGAffineTransformMakeTranslation(150.0, 0.0)];
		[fromClockFace setTransform:CGAffineTransformMakeScale(2.2, 2.2)];
		
		if (toScaled){
			[toClockFace setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
			toScaled = NO;
		}
		[UIView commitAnimations];
		
		fromScaled = YES;
	}
	else if (CGRectContainsPoint(clockToFrame, touchLocation)){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[toClockFace setTransform:CGAffineTransformMakeScale(2.2, 2.2)];
		
		if (fromScaled){
			[fromClockFace setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
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
			[fromClockFace setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
			fromScaled = NO;
		}
		if (toScaled){
			[toClockFace setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
			toScaled =NO;
		}
		[UIView commitAnimations];			
	}
	else{
		
		[super touchesBegan:touches withEvent:event];
	}
	
}

/*													  
 -(void) scaleUp:(NSString*) animationID finished:(NSNumber *)finshed context:(void*) context{
 [UIView beginAnimations:nil context:nil];
 [UIView setAnimationDelegate:self];
 [UIView setAnimationDuration:1.5];
 [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
 [fromClockFace setTransform:CGAffineTransformMakeScale(2.2, 2.2)];
 [UIView commitAnimations];
 }
 */

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
 // Drawing code
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
 CGContextAddRect(context, CGRectMake(20,20,100,100));
 CGContextFillPath(context);
 CGContextStrokePath(context);
 }*/


- (void)dealloc {
    [super dealloc];
	[fromClockFace release];
}


@end
