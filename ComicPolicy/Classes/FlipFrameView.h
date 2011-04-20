//
//  FlipFrameView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 28/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlipFrameView : UIView {
	UIImageView *upImage;
}

@property(nonatomic, retain) UIImageView* upImage;
- (id)initWithFrameAndImage:(CGRect)frame topImage:(NSString*) topImage bottomImage: (NSString *) bottomImage;
@end
