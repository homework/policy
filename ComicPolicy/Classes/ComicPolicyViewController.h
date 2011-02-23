//
//  ComicPolicyViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectViewController.h";
#import "ConditionViewController.h";
#import "ActionViewController.h";
#import "ResultViewController.h";

@interface ComicPolicyViewController : UIViewController {
	SubjectViewController *subjectViewController;
	ConditionViewController	 *eventViewController;
	ActionViewController *actionViewController;
	ResultViewController *resultViewController;
}

@end

