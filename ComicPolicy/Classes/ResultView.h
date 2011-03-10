//
//  ResultView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResultView : UIView {
	UIWebView *monitorWebView;
	UIActivityIndicatorView *activityIndicatorView;
	UIImageView *resultMainImage;
	UIImageView *comicframe;
}

@property(nonatomic,retain) UIWebView *monitorWebView;
@property(nonatomic,retain) UIImageView *resultMainImage;
@property(nonatomic,retain) UIImageView *comicframe;
@property(nonatomic,retain) UIActivityIndicatorView *activityIndicatorView;

@end
