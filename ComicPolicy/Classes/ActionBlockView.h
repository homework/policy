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
    UILabel *blockcaption;
    UILabel *devicecaption;
}

@property(nonatomic,assign) UIImageView *personImage;
@property(nonatomic,assign) UIImageView *blockImage;

@property(nonatomic,assign) UILabel *blockcaption;
@property(nonatomic,assign) UILabel *devicecaption;

- (id)initWithFrameAndImages:(CGRect)frame topImage:(NSString*)topImage bottomImage:(NSString*) bottomImage;



@end
