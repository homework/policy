//
//  Subject.h
//  ComicPolicy
//
//  Created by Tom Lodge on 29/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Subject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * identity;
@property (nonatomic, retain) NSString * owner;
@property (nonatomic, retain) NSString * name;

@end



