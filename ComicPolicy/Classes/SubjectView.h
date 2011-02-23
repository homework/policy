//
//  Subject.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SubjectView : UIView {
	
	UIImageView* topImage;
	UIImageView* bottomImage;
}

@property(nonatomic,retain) UIImageView *topImage;
@property(nonatomic,retain) UIImageView *bottomImage;

@end
