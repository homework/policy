//
//  ImageLookup.h
//  ComicPolicy
//
//  Created by Tom Lodge on 25/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ImageLookup

-(NSString *) getNextTopImage;
-(NSString *) getNextBottomImage;
-(NSString *) getPreviousTopImage;
-(NSString *) getPreviousBottomImage;
-(NSString *) getCurrentTopImage;
-(NSString *) getCurrentBottomImage;
@end
