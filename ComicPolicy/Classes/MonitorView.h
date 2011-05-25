//
//  MonitorView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 06/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MonitorView : UIView {
	UIImageView *monitorImage;
     UIImageView* testImage;
}
@property(nonatomic, retain) UIImageView *monitorImage;
@property(nonatomic, retain) UIImageView *testImage;

- (id)initWithFrameAndImage:(CGRect)frame image:(NSString *) image;

@end
