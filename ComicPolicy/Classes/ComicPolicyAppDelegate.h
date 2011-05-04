//
//  ComicPolicyAppDelegate.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Catalogue.h"

@class ComicPolicyViewController;
//@class MirroredViewController;
@interface ComicPolicyAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    //UIWindow *externalWindow;
   // MirroredViewController *mirroredViewController;
    ComicPolicyViewController *viewController;
    NSArray *screenModes;
	//UIScreen *externalScreen;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
//@property (nonatomic, retain) IBOutlet UIWindow *externalWindow;
@property (nonatomic, retain) IBOutlet ComicPolicyViewController *viewController;
//@property (nonatomic, retain) MirroredViewController *mirroredViewController;
@end

