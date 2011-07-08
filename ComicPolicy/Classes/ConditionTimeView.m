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

@synthesize fhh;
@synthesize fmh;
@synthesize thh;
@synthesize tmh;
@synthesize fromAMPM;
@synthesize toAMPM;
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
		

        
        self.fromAMPM = [[UIButton alloc] initWithFrame:CGRectMake(76, 47, 30,30)];
        [fromAMPM setTitle:@"AM" forState:UIControlStateNormal];
        [fromAMPM setTitle:@"PM" forState:UIControlStateSelected];
        [fromAMPM setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [fromAMPM setTitleColor:[UIColor purpleColor] forState:UIControlStateSelected];
        fromAMPM.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:12.0];
        [fromAMPM setBackgroundColor:[UIColor clearColor]];
        [fromClockFace addSubview:fromAMPM];

        
		self.fhh = [[HandView alloc] initWithFrameAndImage:CGRectMake(56,36,11,51) image:@"hour2.png"];
		[fromClockFace addSubview:fhh];
		[fhh release];
		
		self.fmh = [[HandView alloc] initWithFrameAndImage:CGRectMake(56,32,11,60) image:@"minute2.png"];
		[fromClockFace addSubview:fmh];
		[fmh release];
		
        
                
        
        [self addSubview:fromClockFace];
		
		
		toClockFace = [[UIView alloc] initWithFrame:clockToFrame];
		UIImageView* tmptoclock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clockface2.png"]];
		tmptoclock.frame = CGRectMake(0,0,120,121);
		[toClockFace addSubview:tmptoclock];
		[tmptoclock release];
		
        
        self.toAMPM = [[UIButton alloc] initWithFrame:CGRectMake(76, 47, 30,30)];
        [toAMPM setTitle:@"AM" forState:UIControlStateNormal];
        [toAMPM setTitle:@"PM" forState:UIControlStateSelected];
        [toAMPM setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [toAMPM setTitleColor:[UIColor purpleColor] forState:UIControlStateSelected];
        toAMPM.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:12.0];
        [toAMPM setBackgroundColor:[UIColor clearColor]];
        [toClockFace addSubview:toAMPM];
    
        
    
        
		self.thh = [[HandView alloc] initWithFrameAndImage:CGRectMake(56,36,11,51) image:@"hour2.png"];
		[toClockFace addSubview:thh];
		[thh release];
		
		self.tmh = [[HandView alloc] initWithFrameAndImage:CGRectMake(56,32,11,60) image:@"minute2.png"];
		[toClockFace addSubview:tmh];
		[tmh release];
        
		[self addSubview:toClockFace];
        
        self.caption = [[UILabel alloc] initWithFrame:CGRectMake(50, self.frame.size.height - 40, 250, 30)];
        self.caption.textColor = [UIColor blackColor];
        self.caption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:16.0];
        self.caption.backgroundColor = [UIColor clearColor];
        [self addSubview:caption];
    }
    return self;
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
    NSLog(@"time view in dealloc...");
    [super dealloc];
	[fromClockFace release];
    [toClockFace release];
    [fhh release];
    [fmh release];
    [thh release];
    [tmh release];
}


@end
