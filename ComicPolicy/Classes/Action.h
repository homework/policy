//
//  Action.h
//  ComicPolicy
//
//  Created by Tom Lodge on 29/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class StringOperand;

@interface Action :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet* operands;

@end


@interface Action (CoreDataGeneratedAccessors)
- (void)addOperandsObject:(StringOperand *)value;
- (void)removeOperandsObject:(StringOperand *)value;
- (void)addOperands:(NSSet *)value;
- (void)removeOperands:(NSSet *)value;

@end

