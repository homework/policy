//
//  ActionPrioritiseView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 09/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionPrioritiseView.h"


@implementation ActionPrioritiseView

@synthesize prioritisedevicecaption;
@synthesize prioritiseamountcaption;
@synthesize deviceImage;

- (id)initWithFrameAndImage:(CGRect)frame topImage:(NSString*)topImage{
	if ((self = [super initWithFrame:frame])) {
        
        UIImageView* priority = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"priority.png"]];
		priority.frame = CGRectMake(0, (300-128), 295, 142);
		
        [self addSubview:priority];	
        
        
       
        
        UIImageView* bottomcaptionframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"captionframe.png"]];
		bottomcaptionframe.frame = CGRectMake(143, (300-18), bottomcaptionframe.frame.size.width, bottomcaptionframe.frame.size.height);
        [self addSubview:bottomcaptionframe];
        
        deviceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:topImage]];
		deviceImage.frame = CGRectMake(0, 14, 295, 160);
		[self addSubview:deviceImage];
        
        UIImageView* topcaptionframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"captionframe.png"]];
		topcaptionframe.frame = CGRectMake(6, 19, topcaptionframe.frame.size.width, topcaptionframe.frame.size.height);
        [self addSubview:topcaptionframe];
        
        UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame2.png"]];
		[self addSubview:tmpframe];
		[tmpframe release]; 
        
        upImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenup.png"]];
		upImage.frame = CGRectMake(135, 4, 27, 26);
		[self addSubview:upImage];
        
        self.prioritisedevicecaption = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 150, 30)];
        self.prioritisedevicecaption.textColor = [UIColor blackColor];
        self.prioritisedevicecaption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15.0];
        self.prioritisedevicecaption.backgroundColor = [UIColor clearColor];
        
        self.prioritiseamountcaption = [[UILabel alloc] initWithFrame:CGRectMake(143,(300-18), bottomcaptionframe.frame.size.width, bottomcaptionframe.frame.size.height)];
        self.prioritiseamountcaption.textColor = [UIColor blackColor];
        self.prioritiseamountcaption.textAlignment = UITextAlignmentCenter;
        self.prioritiseamountcaption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:13.0];
        self.prioritiseamountcaption.backgroundColor = [UIColor clearColor];
        
        
        [self addSubview:prioritisedevicecaption];
        [self addSubview:prioritiseamountcaption];
        
        [prioritisedevicecaption release];
        [prioritiseamountcaption release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
