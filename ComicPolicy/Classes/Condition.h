//
//  Condition.h
//  ComicPolicy
//
//  Created by Tom Lodge on 29/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class StringOperand;

@interface Condition :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet* newRelationship;

@end


@interface Condition (CoreDataGeneratedAccessors)
- (void)addNewRelationshipObject:(StringOperand *)value;
- (void)removeNewRelationshipObject:(StringOperand *)value;
- (void)addNewRelationship:(NSSet *)value;
- (void)removeNewRelationship:(NSSet *)value;

@end

