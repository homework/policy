//
//  Policy.m
//  ComicPolicy
//
//  Created by Tom Lodge on 13/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Policy.h"

@implementation Policy

@synthesize identity;
@synthesize localid;

@synthesize subjectowner;
@synthesize subjectdevice;

@synthesize conditiontype;
@synthesize conditionarguments;

@synthesize actionsubject;
@synthesize actiontype;
@synthesize actionarguments;

@synthesize fired;

- (id)initWithPolicy:(Policy *)aPolicy{
    
    if ([self init]) {
        self.subjectowner       = aPolicy.subjectowner;
        self.subjectdevice      = aPolicy.subjectdevice;
        
        self.conditiontype      = aPolicy.conditiontype;
        self.conditionarguments = aPolicy.conditionarguments;
        
        self.actionsubject      = aPolicy.actionsubject;
        self.actiontype         = aPolicy.actiontype;
        self.actionarguments    = aPolicy.actionarguments;
        
        self.fired = NO;
    
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)aDictionary{
    if ([self init]) {
        
        NSDictionary *subject   = [aDictionary objectForKey:@"subject"];
        NSDictionary *condition = [aDictionary objectForKey:@"condition"];
        NSDictionary *action    = [aDictionary objectForKey:@"action"];
        
        self.subjectowner       = [subject objectForKey:@"owner"];
        self.subjectdevice      = [subject objectForKey:@"device"];
    
        self.conditiontype      = [condition objectForKey:@"type"];
        self.conditionarguments = (NSMutableDictionary*) [condition objectForKey:@"arguments"];
        
        self.actionsubject      = [action valueForKey:@"subject"];
        self.actiontype         = [action valueForKey:@"type"];
        self.actionarguments    = (NSArray*) [action valueForKey:@"arguments"];
    
    }
    
    return self;
}


@end
