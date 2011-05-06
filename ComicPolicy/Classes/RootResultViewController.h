//
//  ResultViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ResultView.h"
#import "SubjectView.h"
#import "ResultViewController.h"
#import "MonitorViewController.h"

@interface RootResultViewController : UIViewController <UIWebViewDelegate>{
	ResultViewController    *resultController;
    MonitorViewController   *monitorController;

}

@property(nonatomic, retain) ResultViewController* resultController;
@property(nonatomic, retain) MonitorViewController* monitorController;

@end
