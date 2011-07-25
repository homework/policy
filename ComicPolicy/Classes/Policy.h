//
//  Policy.h
//  ComicPolicy
//
//  Created by Tom Lodge on 13/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Policy : NSObject {
    
    NSString*   localid;
    
    NSString*   identity;
    
    NSString*   subjectowner;
    NSString*   subjectdevice;
    
    NSString*       conditiontype;
    NSMutableDictionary*   conditionarguments;
    
    NSString*    actionsubject;
    NSString*    actiontype;
    NSArray*    actionarguments;
    
    BOOL fired;
}

- (id)initWithDictionary:(NSDictionary *)aDictionary;
- (id)initWithPolicy:(Policy *)aPolicy;

@property(nonatomic, copy) NSString* identity;
@property(nonatomic, copy) NSString* localid;
@property(nonatomic, copy) NSString* subjectowner;
@property(nonatomic, copy) NSString* subjectdevice;

@property(nonatomic, copy) NSString* conditiontype;
@property(nonatomic, copy) NSMutableDictionary* conditionarguments;

@property(nonatomic, copy) NSString*  actionsubject;
@property(nonatomic, copy) NSString*  actiontype;
@property(nonatomic, copy) NSArray*  actionarguments;

@property(nonatomic, assign)  BOOL  fired;

@end
