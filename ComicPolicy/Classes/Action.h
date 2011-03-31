//
//  Action.h
//  ComicPolicy
//
//  Created by Tom Lodge on 31/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class StringTuple;
@class Subject;

@interface Action :  NSManagedObject  
{
}

@property (nonatomic, retain) Subject * subject;
@property (nonatomic, retain) StringTuple * type;
@property (nonatomic, retain) NSSet* operands;

@end


@interface Action (CoreDataGeneratedAccessors)
- (void)addOperandsObject:(StringTuple *)value;
- (void)removeOperandsObject:(StringTuple *)value;
- (void)addOperands:(NSSet *)value;
- (void)removeOperands:(NSSet *)value;

@end

