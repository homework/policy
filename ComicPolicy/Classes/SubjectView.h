//
//  Subject.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitFrameView.h"

@interface SubjectView : SplitFrameView {
}

//- (id)initWithFrameAndImages:(CGRect)frame topImage:(NSString*) ti: (NSString*) bi;
- (id)initWithFrameAndImages:(CGRect)frame topImage:(NSString*) ti bottomImage: (NSString*) bi ;

//-(void) setImage:(NSString *) device owner: (NSString *) owner;
@end
