//
//  MonitorVController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 17/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonitorView.h"


@interface MonitorViewController : UIViewController {
    UIView* monitorView;
}

@property(nonatomic, retain) UIView* monitorView;
//@property(nonatomic, retain) NSString* currentMonitorScene;
@property(nonatomic, retain) UIImageView* testImage;

@end
