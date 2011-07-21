//
//  SplitFrameView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 25/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SplitFrameView.h"


@implementation SplitFrameView

@synthesize topImage;
@synthesize bottomImage;
@synthesize ownercaption;
@synthesize devicecaption;


- (id)initWithFrameAndLookup:(CGRect)frame lookup:(NSObject<ImageLookup>*)lookup{
	if ((self = [super initWithFrame:frame])) {
		
		
		bottomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[lookup getNextBottomImage]]];
		bottomImage.frame = CGRectMake(0, (300-175), 295, 175);
		[self addSubview:bottomImage];
		
		topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[lookup getNextTopImage]]];
		[self addSubview:topImage];
		
		UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame.png"]];
		[self addSubview:tmpframe];
		[tmpframe release];
    }
    return self;
}


/*
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame.png"]];
		[self addSubview:tmpframe];
		[tmpframe release];
    }
    return self;
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
	[bottomImage release];
	[topImage release];
}


@end
