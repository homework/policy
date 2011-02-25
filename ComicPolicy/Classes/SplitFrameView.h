//
//  SplitFrameView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 25/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageLookup.h"

@interface SplitFrameView : UIView {
	UIImageView *topImage;
	UIImageView *bottomImage;
}

@property(nonatomic, retain) UIImageView* topImage;
@property(nonatomic, retain) UIImageView* bottomImage;

- (id)initWithFrameAndLookup:(CGRect)frame lookup:(NSObject<ImageLookup>*)lookup;

@end
