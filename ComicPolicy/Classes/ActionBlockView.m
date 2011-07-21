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
@synthesize blockcaption;
@synthesize devicecaption;

- (id)initWithFrameAndImages:(CGRect)frame topImage:(NSString*)topImage bottomImage:(NSString*) bottomImage{
	if ((self = [super initWithFrame:frame])) {
		blockImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bottomImage]];
		blockImage.frame = CGRectMake(0, (300-128), 295, 142);
		[self addSubview:blockImage];
		
		personImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:topImage]];
		personImage.frame = CGRectMake(0, 14, 295, 160);
		[self addSubview:personImage];		
		
		UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame2.png"]];
		[self addSubview:tmpframe];
		[tmpframe release]; 
		
		upImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenup.png"]];
		upImage.frame = CGRectMake(135, 4, 27, 26);
		[self addSubview:upImage];
        
        self.blockcaption = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 150, 30)];
        self.blockcaption.textColor = [UIColor blackColor];
        self.blockcaption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15.0];
        self.blockcaption.text = @"BLOCK!";
        self.blockcaption.backgroundColor = [UIColor clearColor];
        [self addSubview:blockcaption];
        [blockcaption release];
        
        self.devicecaption = [[UILabel alloc] initWithFrame:CGRectMake(160, self.frame.size.height - 37, 250, 30)];
        self.devicecaption.textColor = [UIColor blackColor];
        self.devicecaption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15.0];
        self.devicecaption.backgroundColor = [UIColor clearColor];
        [self addSubview:devicecaption];
        [devicecaption release];
		
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
