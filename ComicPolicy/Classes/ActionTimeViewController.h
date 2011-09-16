//
//  ActionTimeViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 04/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ActionTimeView.h"

@interface ActionTimeViewController : UIViewController {
    UISlider* slider;
    ActionTimeView* timeView;
}



@end
