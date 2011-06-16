//
//  ConditionVisitingView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 15/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionVisitingView.h"


@implementation ConditionVisitingView

@synthesize addButton;
@synthesize addTextField;

- (id)initWithFrameAndImage:(CGRect)frame image:(NSString *) image{
	if ((self = [super initWithFrame:frame])) {
		
		UIImageView *tmpImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
		self.mainImage = tmpImage;
		[self addSubview:mainImage];
		[tmpImage release];
		
		UIImageView *tmpAddImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plus.png"]];
		
        self.addButton = tmpAddImage;
		[self addSubview:tmpAddImage];
		[tmpAddImage release];
        
               
		UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame.png"]];
		[self addSubview:tmpframe];
		[tmpframe release];
    
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
