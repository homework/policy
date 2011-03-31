//
//  Condition.h
//  ComicPolicy
//
//  Created by Tom Lodge on 31/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class StringTuple;

@interface Condition :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet* operand;

@end


@interface Condition (CoreDataGeneratedAccessors)
- (void)addOperandObject:(StringTuple *)value;
- (void)removeOperandObject:(StringTuple *)value;
- (void)addOperand:(NSSet *)value;
- (void)removeOperand:(NSSet *)value;

@end

