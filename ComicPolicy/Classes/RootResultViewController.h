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
#import "Lookup.h"
#import "SubjectView.h"

@interface RootResultViewController : UIViewController <UIWebViewDelegate>{
	ResultView* resultView;
	NSString* currentMonitorScene;
	NSString* currentActionScene;
}

@end
