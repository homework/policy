//
//  DayOfWeekView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 26/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DayOfWeekView : UIView {
    BOOL selected;
    UILabel* dowlabel;
}

@property(nonatomic, assign) BOOL selected;
@property(nonatomic, assign) UILabel* dowlabel; 

- (id)initWithFrameAndText:(CGRect)frame text:(NSString *) text selected:(BOOL) selected;

@end
