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

@property(nonatomic,retain) UIImageView* redcog;
@property(nonatomic,retain) UIImageView* yellowcog;
@property(nonatomic,retain) UIImageView* pinkcog;
@property(nonatomic,retain) UIImageView* pointer;
@property(nonatomic,retain) UIImageView* smallpointer;
@end
