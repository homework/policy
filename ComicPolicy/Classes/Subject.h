//
//  Subject.h
//  ComicPolicy
//
//  Created by Tom Lodge on 31/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class StringTuple;

@interface Subject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * identity;
@property (nonatomic, retain) StringTuple * owner;
@property (nonatomic, retain) StringTuple * name;

@end



