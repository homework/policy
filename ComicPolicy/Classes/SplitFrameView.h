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
    UILabel *ownercaption;
    UILabel *devicecaption;

}

@property(nonatomic, assign) UIImageView* topImage;
@property(nonatomic, assign) UIImageView* bottomImage;

@property(nonatomic, assign) UILabel *ownercaption;
@property(nonatomic, assign) UILabel *devicecaption;

//- (id)initWithFrameAndLookup:(CGRect)frame lookup:(NSObject<ImageLookup>*)lookup;

@end
