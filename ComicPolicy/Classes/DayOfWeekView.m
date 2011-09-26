//
//  DayOfWeekView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 26/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DayOfWeekView.h"


@implementation DayOfWeekView

@synthesize dowlabel;
@synthesize selected;

- (id)initWithFrameAndText:(CGRect)frame text:(NSString *) text selected:(BOOL) selected{
    self = [super initWithFrame:frame];
    if (self) {
        dowlabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
        dowlabel.textColor = [UIColor blackColor];
        dowlabel.textAlignment = UITextAlignmentCenter;
        dowlabel.text = text;
        dowlabel.backgroundColor = [UIColor clearColor];
        dowlabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:18.0];
        [self addSubview:dowlabel];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"am touched");
    if (selected == NO)
         dowlabel.textColor = [UIColor redColor];
    else
         dowlabel.textColor = [UIColor blackColor];
    
    selected = !selected;
    [super touchesBegan:touches withEvent:event];
     
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
