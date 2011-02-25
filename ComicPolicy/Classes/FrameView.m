//
//  FrameView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 25/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FrameView.h"


@implementation FrameView
@synthesize mainImage;


- (id)initWithFrameAndLookup:(CGRect)frame lookup:(NSObject<ImageLookup>*)lookup{
	if ((self = [super initWithFrame:frame])) {
		
		UIImageView *tmpImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[lookup getNextTopImage]]];
		self.mainImage = tmpImage;
		[self addSubview:mainImage];
		[tmpImage release];
		
		UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame.png"]];
		[self addSubview:tmpframe];
		[tmpframe release];
		
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
	[mainImage release];
}


@end
