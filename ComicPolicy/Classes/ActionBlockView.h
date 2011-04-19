//
//  ActionBlockView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 28/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NotifyActionImageLookup.h"
#import "FlipFrameView.h"

@interface ActionBlockView : FlipFrameView {
	
	UIImageView *personImage;
	UIImageView *blockImage;
}

@property(nonatomic,retain) UIImageView *personImage;
@property(nonatomic,retain) UIImageView *blockImage;



@end
