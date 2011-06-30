//
//  MonitorTimeView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 26/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MonitorTimeView : UIView {
    UIImageView* redcog;
    UIImageView* yellowcog;
    UIImageView* pinkcog;
    UIImageView* pointer;
    UIImageView* smallpointer;
}

@property(nonatomic,assign) UIImageView* redcog;
@property(nonatomic,assign) UIImageView* yellowcog;
@property(nonatomic,assign) UIImageView* pinkcog;
@property(nonatomic,assign) UIImageView* pointer;
@property(nonatomic,assign) UIImageView* smallpointer;
@end
