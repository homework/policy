//
//  ActionPrioritiseView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 09/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlipFrameView.h"

@interface ActionPrioritiseView : FlipFrameView {
    UIImageView *deviceImage;
    UILabel *prioritisedevicecaption;
    UILabel *prioritiseamountcaption;

}

@property(nonatomic, assign) UILabel* prioritisedevicecaption;
@property(nonatomic, assign) UILabel* prioritiseamountcaption;
@property(nonatomic, assign) UIImageView *deviceImage;

- (id)initWithFrameAndImage:(CGRect)frame topImage:(NSString*)topImage;

@end
