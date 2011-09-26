//
//  RootConditionTimeViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 26/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionViewController.h"
#import "ConditionTimeView.h"

@interface RootConditionTimeViewController : ConditionViewController {
	ConditionTimeView* conditionTimeView;
    
    int fromhour;
    int fromminute;
    
    int tohour;
    int tominute;
    
    CGRect clockFromFrame;
	CGRect clockToFrame;

}

-(void) updateCaption;
-(void) updateCatalogue;
-(void) setFromHour:(int) hour;
-(void) setToHour:(int) hour;
-(void) setFromMinute:(int) minute;
-(void) setToMinute:(int) minute;
-(void) setUpConditionView;
-(void) initialiseClocks;
@end
