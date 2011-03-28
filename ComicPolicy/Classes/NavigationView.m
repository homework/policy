//
//  NavigationView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 28/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NavigationView.h"


@implementation NavigationView
@synthesize  addNew;

static float PADDING = 15;

- (id)initWithFrameAndButtons:(CGRect)frame buttons:(NSMutableArray*) buttons {
    if ((self = [super initWithFrame:frame])) {
		
		int buttoncount = [buttons count] + 1;
		
		float barlen = (buttoncount * 26) + (PADDING * buttoncount-1);
		
		CGFloat xlen = [[UIScreen mainScreen] bounds].size.height;

		float origin = (xlen / 2) - (barlen / 2);
		
		for (UIImageView *button in buttons){
			UIImageView *tmpView = button;
			tmpView.frame =  CGRectMake(origin, frame.size.height/2, 26, 27);
			[self addSubview:tmpView];
		}
		
		UIImageView *tmpAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addnew.png"]];
		tmpAdd.frame = CGRectMake(origin + barlen - (PADDING + 26), frame.size.height/2, 26, 27);
		addNew = tmpAdd;
		[self addSubview:tmpAdd];
		[tmpAdd release];
		
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

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	NSLog(@"adding new policy...");
	
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
	if (CGRectContainsPoint( addNew.frame , touchLocation)){
		NSLog(@"in here...");
	}

}

- (void)dealloc {
    [super dealloc];
}


@end
