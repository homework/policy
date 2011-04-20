//
//  ActionView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NotifyActionImageLookup.h"
#import "FlipFrameView.h"

@interface ActionNotifyView : FlipFrameView {
	UIImageView *personImage;
	UIImageView *notifyImage;
}

@property(nonatomic,retain) UIImageView *personImage;
@property(nonatomic,retain) UIImageView *notifyImage;
- (id)initWithFrameAndImages:(CGRect)frame topImage:(NSString *) topImage bottomImage:(NSString *) bottomImage;
@end
