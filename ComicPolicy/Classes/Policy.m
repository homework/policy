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
@synthesize subjectowner;
@synthesize subjectdevice;

@synthesize conditiontype;
@synthesize conditionarguments;

@synthesize actionsubject;
@synthesize actiontype;
@synthesize actionarguments;

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
