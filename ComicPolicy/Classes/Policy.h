//
//  Policy.h
//  ComicPolicy
//
//  Created by Tom Lodge on 31/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Action;
@class Condition;
@class Subject;

@interface Policy :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * identity;
@property (nonatomic, retain) Condition * condition;
@property (nonatomic, retain) Subject * subject;
@property (nonatomic, retain) Action * action;

@end



