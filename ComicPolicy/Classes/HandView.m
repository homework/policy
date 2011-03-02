//
//  HandView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 02/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HandView.h"

@implementation HandView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		UIImageView* hand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hour2.png"]];
		hand.frame = CGRectMake(0,0, frame.size.width, frame.size.height);
		self.backgroundColor = [UIColor cyanColor];
		[self addSubview: hand];
		[self.layer setAnchorPoint:CGPointMake(0.5, 0.9)]; 
		[hand release];
	}
    return self;
}

/*
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self ];
	float dx = touchLocation.x;
	float dy = touchLocation.y;
	NSLog(@"%f %f", dx,dy);
	double a = atan2(dx,dy);
	
	//self.transform = CGAffineTransformMakeRotation(a);
	
	self.transform = CGAffineTransformMakeRotation([[self.layer valueForKeyPath:@"transform.rotation.z"] floatValue] + a);// atan2(touchLocation.x, touchLocation.y));
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	NSLog(@"touched!!");
	//[[gaugepointer layer] setAnchorPoint:CGPointMake(0.5, 0.2)];
	//UITouch *touch = [[event allTouches] anyObject];
	//CGPoint touchLocation = [touch locationInView:self];
	//self.transform = CGAffineTransformMakeRotation([[self.layer valueForKeyPath:@"transform.rotation.z"] floatValue] + atan2(touchLocation.x, touchLocation.y));
}
*/


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
