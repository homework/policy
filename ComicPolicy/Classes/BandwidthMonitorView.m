//
//  BandwidthMonitorView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 05/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BandwidthMonitorView.h"


@implementation BandwidthMonitorView

- (void)drawRect:(CGRect)rect {
    NSLog(@"in her drawing rect");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGRect rectangle = CGRectMake(60,170,200,80);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
    
}

@end
