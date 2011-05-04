//
//  NavigationView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 28/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NavigationView.h"
#import "PolicyManager.h"

@interface NavigationView()
    -(void) updateNavigation;
@end

@implementation NavigationView
@synthesize addNew;

static float PADDING = 15;

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        [self updateNavigation];		
    }
    return self;
}

-(void) updateNavigation{
	
	NSArray *policyids = [[PolicyManager sharedPolicyManager]policyids];
    
	int buttoncount = [policyids count] + 1;
		
	float barlen = (buttoncount * 26) + (PADDING * buttoncount-1);
	CGFloat xlen = [[UIScreen mainScreen] bounds].size.height;
	float origin = (xlen / 2) - (barlen / 2);
	int count = 0;
	
	for (UIView *view in self.subviews){
		[view removeFromSuperview];	
	}
	
	
	for (NSString *policy in policyids ){
		UIImageView *button = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"empty.png"]];
		button.tag = [policy intValue];
		UILabel *tmp = [[UILabel alloc] initWithFrame:CGRectMake(8,0,26,27)];
		tmp.backgroundColor = [UIColor clearColor];
		tmp.text = [NSString stringWithFormat:@"%d", count+1];
		[button addSubview:tmp];
		button.frame = CGRectMake(origin + (count * (26 + PADDING)), 20, 26, 27);
		button.transform = CGAffineTransformMakeScale(0.8, 0.8);	
		[self addSubview:button];
		count++;
	}
	
	UIImageView *tmpAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addnew.png"]];
	tmpAdd.frame = CGRectMake(origin + (count * (26 + PADDING)), 20, 26, 27);
	addNew = tmpAdd;
	[self addSubview:tmpAdd];
	[tmpAdd release];
	
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
