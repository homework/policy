//
//  Subject.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubjectView.h"


@implementation SubjectView

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
        bottomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"conddesktop.png"]];
		bottomImage.frame = CGRectMake(0, (300-175), 295, 175);
		[self addSubview:bottomImage];
		
		topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dad.png"]];
		[self addSubview:topImage];
        
        self.ownercaption = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 250, 30)];
        self.ownercaption.textColor = [UIColor blackColor];
        self.ownercaption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15.0];
        self.ownercaption.backgroundColor = [UIColor clearColor];
        [self addSubview:ownercaption];
        [ownercaption release];
        
        self.devicecaption = [[UILabel alloc] initWithFrame:CGRectMake(140, self.frame.size.height - 33, 250, 30)];
        self.devicecaption.textColor = [UIColor blackColor];
        self.devicecaption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15.0];
        self.devicecaption.backgroundColor = [UIColor clearColor];
        [self addSubview:devicecaption];
        [devicecaption release];
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
	//[bottomImage release];
	//[topImage release];
}


@end
