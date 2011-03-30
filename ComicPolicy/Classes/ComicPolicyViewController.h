//
//  ComicPolicyViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SubjectViewController.h";
#import "RootConditionViewController.h";
#import "RootActionViewController.h";
#import "RootResultViewController.h";
#import "ActionTimeViewController.h";
#import "NavigationViewController.h";
#import "Subject.h";

@interface ComicPolicyViewController : UIViewController {
	NSManagedObjectContext *managedObjectContext;
	NSMutableArray *policyids;
	UIImageView *deleteButton;
	UIImageView *saveButton;
	
	NavigationViewController	*navigationViewController;
	SubjectViewController		*subjectViewController;
	RootConditionViewController	 *eventViewController;
	RootActionViewController *actionViewController;
	RootResultViewController *resultViewController;
	ActionTimeViewController *actionTimeViewController;
	
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) UIImageView *addNew;
@property (nonatomic, retain) UIImageView *deleteButton;
@property (nonatomic, retain) UIImageView *saveButton;
@property (nonatomic, retain) NSMutableArray *policyids;
@end

