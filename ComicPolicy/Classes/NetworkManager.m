//
//  NetworkManager.m
//  ComicPolicy
//
//  Created by Tom Lodge on 18/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkManager.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

@interface NetworkManager ()
- (void)delegateStarted:(ASIHTTPRequest *)request;
- (void)delegateFinished:(ASIHTTPRequest *)request;
- (void)delegateRequest:(ASIHTTPRequest *)request receivedResponseHeaders:(NSDictionary *)responseHeaders;
- (void)delegateFailed:(ASIHTTPRequest *)request;
@end

@implementation NetworkManager

@synthesize networkQueue;
@synthesize rootURL;

+ (NetworkManager *)sharedManager
{
    static NetworkManager * sNetworkManager;
    
    // This can be called on any thread, so we synchronise.  We only do this in 
    // the sNetworkManager case because, once sNetworkManager goes non-nil, it can 
    // never go nil again.
    
    if (sNetworkManager == nil) {
        @synchronized (self) {
            sNetworkManager = [[NetworkManager alloc] init];
            assert(sNetworkManager != nil);
        }
    }
    return sNetworkManager;
}

- (id)init
{
    // any thread, but serialised by +sharedManager
    self = [super init];
    if (self != nil) {
        self.rootURL = @"http://10.2.0.1:9000";
        self.networkQueue = [ASINetworkQueue queue];
        [networkQueue setDelegate:self];
        [networkQueue setRequestDidStartSelector:@selector(delegateStarted:)];
        [networkQueue setRequestDidFinishSelector:@selector(delegateFinished:)];
        [networkQueue setRequestDidFailSelector:@selector(delegateFailed:)];
        [networkQueue go];
        
    }
    return self;
}

-(void) addRequest:(ASIHTTPRequest *) request{
    // // NSString *password = (NSString*) [self.passwordItem objectForKey:(id)kSecValueData];
    //NSLog(@"got the password %@", password);
    //if ([self hasAccountDetails]){
     //   [request addBasicAuthenticationHeaderWithUsername:account andPassword:password];
        [networkQueue addOperation:request];
    //}
}

- (void)delegateStarted:(ASIHTTPRequest *)request
{
	NSLog(@"started something");
}

- (void) delegateRequest:(ASIHTTPRequest *)request receivedResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"received response headers");
}

- (void)delegateFinished:(ASIHTTPRequest *)request
{
    NSLog(@"finished something");	
}

- (void)delegateFailed:(ASIHTTPRequest *)request
{
    NSLog(@"test failed....");
}



@end
