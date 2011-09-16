//
//  ActionTimeView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 04/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameView.h"

@interface ActionTimeView : FrameView{
    UILabel *timecaption;
    UIImageView *light;
    UIImageView *dark;
    
}
@property(nonatomic, assign) UILabel *timecaption;
@property(nonatomic, assign) UIImageView *light;
@property(nonatomic, assign) UIImageView *dark;
@end
