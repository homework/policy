//
//  Policy.h
//  ComicPolicy
//
//  Created by Tom Lodge on 13/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    unsaved,
    enabled,
    disabled
}PolicyStatus;

@interface Policy : NSObject {
    
    
    NSString*   localid;
    
    NSString*   identity;
    
    NSString*   subjectdevice;
    
    NSString*       conditiontype;
    NSMutableDictionary*   conditionarguments;
    
    NSString*    actionsubject;
    NSString*    actiontype;
    NSMutableDictionary*    actionarguments;
    
    BOOL fired;
    
    PolicyStatus status;
}



- (id)initWithDictionary:(NSDictionary *)aDictionary;
- (id)initWithPolicy:(Policy *)aPolicy;
- (id) initWithPonderString:(NSString *) ponderString;
- (void) updateStatus:(NSString *) state;
-(NSString *) statusAsString;
- (NSString*) toPonderString;
-(void) print;

@property(nonatomic, copy) NSString* identity;
@property(nonatomic, copy) NSString* localid;
//@property(nonatomic, copy) NSString* subjectowner;
@property(nonatomic, copy) NSString* subjectdevice;

@property(nonatomic, copy) NSString* conditiontype;
@property(nonatomic, copy) NSMutableDictionary* conditionarguments;

@property(nonatomic, copy) NSString*  actionsubject;
@property(nonatomic, copy) NSString*  actiontype;
@property(nonatomic, copy) NSMutableDictionary*  actionarguments;

@property(nonatomic, assign)  BOOL  fired;
@property(nonatomic, assign) PolicyStatus status;


@end
