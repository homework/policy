//
//  NavigationView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 28/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NavigationView : UIView {
	UIImageView *addNew;
	NSMutableArray *buttons;
}

@property(nonatomic,retain) UIImageView* addNew;
@property(nonatomic,retain) NSMutableArray* buttons;

-(id) initWithFrameAndButtons: (CGRect) frame buttons:(NSArray*) buttons;

@end
