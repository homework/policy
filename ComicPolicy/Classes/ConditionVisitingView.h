//
//  ConditionVisitingView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 15/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameView.h"

@interface ConditionVisitingView : FrameView {
    UIImageView* addButton;
    UITextField* addTextField;
    UILabel* sitecaption;
}

@property(nonatomic, retain) UIImageView* addButton;
@property(nonatomic, retain) UITextField* addTextField;
@property(nonatomic, assign) UILabel* sitecaption;
@end
