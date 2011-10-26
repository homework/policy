//
//  SubjectViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SubjectView.h"
#import "Lookup.h"
//#import "SubjectImageLookup.h"
#import "Catalogue.h"

@interface SubjectViewController : UIViewController {
	
	SubjectView* subjectView;
	UIImageView* moreButton;
	//NSMutableArray *peopleImages;
	//NSMutableArray *deviceImages;
	//int peopleImageIndex ;
	//int deviceImageIndex ;
}

@end
