//
//  MonitorTimeView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 26/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MonitorTimeView.h"


@implementation MonitorTimeView


@synthesize redcog;
@synthesize yellowcog;
@synthesize pinkcog;
@synthesize pointer;
@synthesize smallpointer;
@synthesize routercaption;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /*UIImageView *whiteMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whitemask.png"]];
        whiteMask.frame = CGRectMake(439, 0, 130, 298);
        [self addSubview:whiteMask];
        [whiteMask release];*/
        
        UIImageView *tmpMonitor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resulttime.png"]];
        tmpMonitor.autoresizingMask = UIViewContentModeScaleAspectFit;// UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:tmpMonitor];
        [tmpMonitor release];
         
        self.pinkcog = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinkcog.png"]];
        self.pinkcog.center = CGPointMake(74,68);
        [self.pinkcog.layer setAnchorPoint:CGPointMake(0.5,0.5)];
        [self addSubview:pinkcog];
        [pinkcog release];
        
        self.yellowcog = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellowcog.png"]];
        self.yellowcog.center = CGPointMake(78,201);
        [self addSubview:yellowcog];
        [yellowcog release];
        
        self.redcog = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redcog.png"]];
        self.redcog.center = CGPointMake(171,171);
        [self addSubview:redcog];
        [redcog release];
        
        /*UIImageView *cface = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"monitorclockface.png"]];
        cface.center = CGPointMake(324,135);
        [self addSubview:cface];
        [cface release];
        
        UIImageView *tmpvbranch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vbranch.png"]];
        tmpvbranch.center = CGPointMake(323,66);
        [self addSubview:tmpvbranch];
        [tmpvbranch release];
        
        UIImageView *tmphbranch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hbranch.png"]];
        tmphbranch.center = CGPointMake(250,154);
        [self addSubview:tmphbranch];
        [tmphbranch release];*/
        
        /*self.pointer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointer.png"]];
        self.pointer.center = CGPointMake(322,135);
        [self.pointer.layer setAnchorPoint:CGPointMake(0.5, 0.64)]; 
        [self addSubview:pointer];
        [pointer release];*/
        
        UIImageView *tmpdash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dash.png"]];
        tmpdash.center = CGPointMake(207,217);
        [self addSubview:tmpdash];
        [tmpdash release];
        
        self.smallpointer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointer.png"]];
        self.smallpointer.center = CGPointMake(208,305);
        [self.smallpointer.layer setAnchorPoint:CGPointMake(0.5, 0.7)]; 
        [self addSubview:smallpointer];
        [smallpointer release];
        
        /*UIImageView *semicog = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"semicog.png"]];
        semicog.center = CGPointMake(228,289);
        [self addSubview:semicog];
        [semicog release];*/
        
        UIImageView *leaf1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leaf.png"]];
        leaf1.center = CGPointMake(101,274);
        [self addSubview:leaf1];
        [leaf1 release];
        
        UIImageView *leaf2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leaf.png"]];
        leaf2.center = CGPointMake(342,274);
        [self addSubview:leaf2];
        [leaf2 release];

        self.routercaption = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, self.frame.size.height - 35, 250, 30)];
        self.routercaption.textColor = [UIColor blackColor];
        self.routercaption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:25.0];
        self.routercaption.backgroundColor = [UIColor clearColor];
        [self addSubview:routercaption];
        [routercaption release];
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
    NSLog(@"releasing monitor time view....");
    /*[redcog.layer removeAllAnimations];
    [yellowcog.layer removeAllAnimations];
    [pinkcog.layer removeAllAnimations];
    [pointer.layer removeAllAnimations];
    [smallpointer.layer removeAllAnimations];*/
    
    /*[redcog release];
    [yellowcog release];
    [pinkcog release];
    [pointer release];
    [smallpointer release];*/
    
    [super dealloc];
}

@end
