//
//  MonitorVisitsView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 17/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MonitorVisitsView.h"


@implementation MonitorVisitsView
@synthesize monitorImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
           /* UIImageView *whiteMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whitemask.png"]];
            whiteMask.frame = CGRectMake(439, 0, 130, 298);
            [self addSubview:whiteMask];
            [whiteMask release];*/
    
            //self.backgroundColor = [UIColor Color];
            /*[self setAutoresizesSubviews:YES];
            UIImageView *tmpMonitor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resultvisits.png"]];
                       tmpMonitor.autoresizingMask = UIViewContentModeScaleAspectFit | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
        
            [self addSubview:tmpMonitor];
            self.monitorImage = tmpMonitor;
            [tmpMonitor release];*/
            
            /*
             UIImageView *tmpTest = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok.png"]];
             [self addSubview:tmpTest];
             self.testImage = tmpTest;
             [tmpTest release];*/
            
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
