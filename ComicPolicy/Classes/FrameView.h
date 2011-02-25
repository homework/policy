//
//  FrameView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 25/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageLookup.h"

@interface FrameView : UIView {
	UIImageView *mainImage;

}

@property (nonatomic,retain) UIImageView *mainImage;

- (id)initWithFrameAndLookup:(CGRect)frame lookup:(NSObject<ImageLookup>*)lookup;

@end
