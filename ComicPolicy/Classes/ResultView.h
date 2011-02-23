//
//  ResultView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResultView : UIView {
	UIImageView *monitorImage;
	UIImageView *resultImage;
}

@property(nonatomic,retain) UIImageView *monitorImage;
@property(nonatomic,retain) UIImageView *resultImage;

@end
