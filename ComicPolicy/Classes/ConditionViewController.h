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

@interface ConditionViewController : UIViewController {
	NSMutableDictionary* conditionArguments;
}

@property(nonatomic, retain) NSMutableDictionary* conditionArguments;
@end
