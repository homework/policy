//
//  ConditionBandwidthView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 24/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionBandwidthView.h"


@implementation ConditionBandwidthView
//@synthesize conditionImage;
@synthesize moneyImage;
@synthesize bandwidthLabel;

- (id)initWithFrameAndLookup:(CGRect)frame lookup:(NSObject<ImageLookup>*)lookup{
	if ((self = [super initWithFrame:frame])) {
		
		UIImageView *tmpImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[lookup getNextTopImage]]];
		self.mainImage = tmpImage;
		[self addSubview:mainImage];
		[tmpImage release];
		
		UIImageView *tmpMoneyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"conditionmoneybag.png"]];
		self.moneyImage = tmpMoneyImage;
		[self addSubview:tmpMoneyImage];
		[tmpMoneyImage release];
		
		UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame.png"]];
		[self addSubview:tmpframe];
		[tmpframe release];
		
		bandwidthLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 20,100,100)];
		bandwidthLabel.text = @"100%";
		[bandwidthLabel setFont:[UIFont fontWithName:@"Copperplate" size:25]];
		bandwidthLabel.textAlignment = UITextAlignmentCenter;
		bandwidthLabel.shadowColor = [UIColor blackColor];
		bandwidthLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:bandwidthLabel];
		
		NSDictionary* dict = [NSDictionary dictionaryWithObject:[lookup getCurrentTopImage] forKey:@"condition"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"conditionChange" object:nil userInfo:dict];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
	[moneyImage release];
}


@end
