//
//  ConditionTypeViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 24/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionViewController.h"
#import "ConditionVisitingView.h"

@interface ConditionVisitingViewController : ConditionViewController <UITextFieldDelegate> {
    
    ConditionVisitingView *conditionVisitingView;
    
    /*
     * Array containing the UIViews of all of the sites that have been added so far..
     */
    UITextField* addSiteTextField;
    NSMutableArray* sites;
    BOOL editing;
    BOOL doesvisit;
}

@property(nonatomic, retain) NSMutableArray* sites;
@property(nonatomic, retain) UITextField *addSiteTextField;

@end
