//
//  ActionView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ActionNotifyView : UIView {
	UIImageView *personImage;
	UIImageView *notifyImage;
	UIImageView *upImage;
}

@property(nonatomic,retain) UIImageView *personImage;
@property(nonatomic,retain) UIImageView *notifyImage;
@property(nonatomic,retain) UIImageView *upImage;

@end
