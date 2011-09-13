//
//  ResultDataSource.m
//  ComicPolicy
//
//  Created by Tom Lodge on 05/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MonitorDataSource.h"
#import "ASIHTTPRequest.h"
#import "NetworkManager.h"

@implementation MonitorDataSource


+ (MonitorDataSource *)sharedDatasource
{
    static MonitorDataSource * sDataSource;
  
    if (sDataSource == nil) {
        @synchronized (self) {
            sDataSource = [[MonitorDataSource alloc] init];
            assert(sDataSource != nil);
        }
    }
    return sDataSource;
}

- (id)init
{
    // any thread, but serialised by +sharedManager
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

-(void) requestURL:(NSString*) strurl callback:(NSString*) callback{
   // NSLog(@"connecting to %@", strurl);
    NSURL *url = [NSURL URLWithString:strurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    request.userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:callback,@"callback", nil];
    [request setDidFinishSelector:@selector(addedRequestComplete:)];
    [[NetworkManager sharedManager] addRequest:request];    
}


- (void)addedRequestComplete:(ASIHTTPRequest *)request{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[request responseString] forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:[request.userInfo objectForKey:@"callback"] object:nil userInfo:dict];
}



@end
