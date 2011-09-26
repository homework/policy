//
//  RequestObject.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum requestType{
    requestCreate,
    requestRemove,
    requestEnable,
    requestDisable
}RequestType;

@interface RequestObject : NSObject {
    NSString* localId;
    RequestType requestType;
    NSString* requestString; 
}

@property(nonatomic, copy) NSString* localId;
@property(nonatomic, copy) NSString* requestString;
@property(nonatomic, assign) RequestType requestType;

-(id) initWithValues:(NSString *) localId type: (RequestType) type request: (NSString *) request;

@end
