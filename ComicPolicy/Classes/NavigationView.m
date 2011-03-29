//
//  NavigationView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 28/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NavigationView.h"


@implementation NavigationView
@synthesize addNew;
@synthesize buttons;
static float PADDING = 15;

- (id)initWithFrameAndButtons:(CGRect)frame buttons:(NSMutableArray*) btns {
    if ((self = [super initWithFrame:frame])) {
		self.buttons = btns;
		UIImageView *tmpAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addnew.png"]];
		addNew = tmpAdd;
		[self.buttons addObject:addNew];
		[tmpAdd release];
		[self createButtons];		
    }
    return self;
}

-(void) createButtons{
	
	int buttoncount = [buttons count];
	float barlen = (buttoncount * 26) + (PADDING * buttoncount-1);
	CGFloat xlen = [[UIScreen mainScreen] bounds].size.height;
	float origin = (xlen / 2) - (barlen / 2);
	int count = 0;
	
	for (UIImageView *button in buttons){
		UIImageView *tmpView = button;
		tmpView.frame = CGRectMake(origin + (count * (26 + PADDING)), self.frame.size.height/2, 26, 27);
		if (tmpView.superview != self){
			[self addSubview:tmpView];
		}
		count++;
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	
	
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
	if (CGRectContainsPoint( addNew.frame , touchLocation)){
		UIImageView *tmpButton = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"empty.png"]];
		UILabel *tmp = [[UILabel alloc] initWithFrame:CGRectMake(9,0,26,27)];
		tmp.backgroundColor = [UIColor clearColor];
		tmp.text = [NSString stringWithFormat:@"%d", [buttons count]];
		[tmpButton addSubview:tmp];
		[buttons insertObject: tmpButton atIndex:[buttons count]-1];
		[self createButtons];
	}

}

- (void)dealloc {
    [super dealloc];
}


@end
