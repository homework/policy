//
//  URLObject.h
//  ComicPolicy
//
//  Created by Tom Lodge on 04/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "timestamp.h"
#include <netinet/ip.h>	

@interface URLObject : NSObject {
    unsigned int proto;
    NSString* saddr;
    unsigned int sport;
    NSString* daddr;
    unsigned int dport;
    NSString* hst;
    NSString*  uri;
    NSString* cnt;
    tstamp_t tstamp;    
}


typedef struct url{
    unsigned int proto;
    char saddr[16];
    unsigned int sport;
    char daddr[16];
    unsigned int dport;
    char hst[128];
    char uri[128];
    char cnt[128];
    tstamp_t tstamp;
}Url;

-(id) initWithUrl: (Url *) u;


@property(nonatomic, assign)    unsigned int proto;
@property(nonatomic, copy)      NSString* saddr;
@property(nonatomic, assign)    unsigned int sport;
@property(nonatomic, copy)      NSString* daddr;
@property(nonatomic, assign)    unsigned int dport;
@property(nonatomic, copy)      NSString* hst;
@property(nonatomic, copy)      NSString*  uri;
@property(nonatomic, copy)      NSString* cnt;
@property(nonatomic, assign)    tstamp_t tstamp;    

@end
