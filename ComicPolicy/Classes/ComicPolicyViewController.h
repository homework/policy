//
//  ComicPolicyViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>
#import "SubjectViewController.h"
#import "RootConditionViewController.h"
#import "RootActionViewController.h"
#import "RootResultViewController.h"
#import "ActionTimeViewController.h"
#import "NavigationViewController.h"
#import "RouterConnectionViewController.h"
#import "ConditionVisitingTimeViewController.h"

@interface ComicPolicyViewController : UIViewController {
	
	NSMutableArray *policyids;
	
    UIImageView *deleteButton;
	UIImageView *saveButton;
    //UIImageView *refreshButton;
	UIImageView *activateButton;
    UILabel * statusLabel;
    AVAudioPlayer *tickPlayer;
	AVAudioPlayer *tockPlayer;
	
	NavigationViewController        *navigationViewController;
	SubjectViewController           *subjectViewController;
	RootConditionViewController     *eventViewController;
	RootActionViewController        *actionViewController;
	RootResultViewController        *resultViewController;
	ActionTimeViewController        *actionTimeViewController;
    RouterConnectionViewController  *routerConnectionViewController;
    ConditionVisitingTimeViewController *conditionVisitingTimeViewController;
    
    UIView *progressView;
    UIView *disableInteractionView;
    
    BOOL inprogress;
    BOOL splashscreenshowing;
    
    NSTimer* requestTimer;
	
}
-(void) playTock:(NSTimer *)timer;

@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) UIImageView *addNew;
@property (nonatomic, retain) NSMutableArray *policyids;
@property (nonatomic, retain) AVAudioPlayer *tickPlayer;
@property (nonatomic, retain) AVAudioPlayer *tockPlayer;
@property (nonatomic, assign) UILabel* statusLabel;
@end

