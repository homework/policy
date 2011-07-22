//
//  NetworkManager.m
//  ComicPolicy
//
//  Created by Tom Lodge on 18/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "NetworkManager.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

@interface NetworkManager ()
- (void)delegateStarted:(ASIHTTPRequest *)request;
- (void)delegateFinished:(ASIHTTPRequest *)request;
- (void)delegateRequest:(ASIHTTPRequest *)request receivedResponseHeaders:(NSDictionary *)responseHeaders;
- (void)delegateFailed:(ASIHTTPRequest *)request;
- (NSString*)getGatewayAddress;
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
        
        self.rootURL = [NSString stringWithFormat:@"http://%@:%d/policyserver", [self getGatewayAddress], 8080];
        
        //self.rootURL = [NSString stringWithFormat:@"http://10.2.0.1:9000"];
        
        self.networkQueue = [ASINetworkQueue queue];
        [networkQueue setDelegate:self];
        [networkQueue setRequestDidStartSelector:@selector(delegateStarted:)];
        [networkQueue setRequestDidFinishSelector:@selector(delegateFinished:)];
        [networkQueue setRequestDidFailSelector:@selector(delegateFailed:)];
        [networkQueue go];
        
    }
    return self;
}

-(NSString *)getGatewayAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    NSArray *addrs = [address componentsSeparatedByString:@"."];
    int gwbit =  [((NSString *) [addrs objectAtIndex:3]) intValue];
    return [NSString stringWithFormat:@"%@.%@.%@.%d",[addrs objectAtIndex:0], [addrs objectAtIndex:1], [addrs objectAtIndex:2], gwbit+1];
}


-(void) addRequest:(ASIHTTPRequest *) request{
      [networkQueue addOperation:request];    
}

-(void) removeAllRequests{
    [networkQueue cancelAllOperations];
}

- (void)delegateStarted:(ASIHTTPRequest *)request
{
	
}

- (void) delegateRequest:(ASIHTTPRequest *)request receivedResponseHeaders:(NSDictionary *)responseHeaders
{
   
}

- (void)delegateFinished:(ASIHTTPRequest *)request
{
   	
}

- (void)delegateFailed:(ASIHTTPRequest *)request
{
    NSLog(@"connection failed....");
}



@end
