//
//  NetworkManager.h
//  ComicPolicy
//
//  Created by Tom Lodge on 18/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ASINetworkQueue;
@class ASIHTTPRequest;

@interface NetworkManager : NSObject {
    ASINetworkQueue *networkQueue;
    NSString *rootURL;
    NSString *gwaddr;
    NSString *myaddr;
}

@property(nonatomic,retain) ASINetworkQueue* networkQueue;
@property(nonatomic,retain) NSString* rootURL;
@property(nonatomic,retain) NSString* gwaddr;
@property(nonatomic,retain) NSString* myaddr;

+ (NetworkManager *)sharedManager;

-(void) addRequest:(ASIHTTPRequest *) request;
-(void) removeAllRequests;
-(BOOL) connectToHWDB;
-(void) readPoliciesFromHWDB;

@end
