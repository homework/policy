//
//  ConditionViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ConditionImageLookup.h"
#import "Catalogue.h"
#import "PolicyManager.h"
#import "Policy.h"

@interface ConditionViewController : UIViewController {
	NSMutableDictionary* conditionArguments;

}

@property(nonatomic, retain) NSMutableDictionary* conditionArguments;
- (id)initWithNibNameAndType:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSString*) type;
@end
