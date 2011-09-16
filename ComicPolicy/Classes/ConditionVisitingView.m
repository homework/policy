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
@synthesize sitecaption;

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
        
        
        UIImageView* bottomcaptionframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"captionframelong.png"]];
		bottomcaptionframe.frame = CGRectMake(87, (300-33), bottomcaptionframe.frame.size.width, bottomcaptionframe.frame.size.height);
        [self addSubview:bottomcaptionframe];
        [bottomcaptionframe release];
        
        self.sitecaption = [[UILabel alloc] initWithFrame:CGRectMake(87,300-32, 200, 30)];
        self.sitecaption.textColor = [UIColor blackColor];
        self.sitecaption.textAlignment = UITextAlignmentCenter;
        self.sitecaption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15.0];
        self.sitecaption.backgroundColor = [UIColor clearColor];
        self.sitecaption.text = @"visits any of these sites";
        [self addSubview:sitecaption];
        [sitecaption release];
    
       
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
