//
//  ActionBlockView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 28/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionBlockView.h"


@implementation ActionBlockView

@synthesize personImage;
@synthesize blockImage;

- (id)initWithFrameAndLookup:(CGRect)frame lookup:(NSObject<ImageLookup>*)lookup{
	if ((self = [super initWithFrame:frame])) {
		NSString *deviceImage = [lookup getNextBottomImage];
		blockImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:deviceImage]];
		blockImage.frame = CGRectMake(0, (300-128), 295, 142);
		[self addSubview:blockImage];
		
		personImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[lookup getNextTopImage]]];
		personImage.frame = CGRectMake(0, 14, 295, 160);
		[self addSubview:personImage];		
		
		UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame2.png"]];
		[self addSubview:tmpframe];
		[tmpframe release]; 
		
		upImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenup.png"]];
		upImage.frame = CGRectMake(135, 4, 27, 26);
		[self addSubview:upImage];
		
		NSDictionary* dict = [NSDictionary dictionaryWithObject:deviceImage forKey:@"action"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:dict];
    }
    return self;
	
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
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
}


@end
