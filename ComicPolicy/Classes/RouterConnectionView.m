//
//  RouterConnectionView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 18/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RouterConnectionView.h"


@implementation RouterConnectionView

@synthesize  caption;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       UIImageView *loading = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"loadingcatalogue.png"]];
        [self addSubview:loading];
        self.caption = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1024, 700)];
        caption.textColor = [UIColor blackColor];
        caption.textAlignment = UITextAlignmentCenter;
        caption.numberOfLines = 0;
        caption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:50.0];
        caption.backgroundColor = [UIColor clearColor];
        [self addSubview:caption];
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
