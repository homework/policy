//
//  PolicyTranslator.m
//  ComicPolicy
//
//  Created by Tom Lodge on 24/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PolicyTranslator.h"

@implementation PolicyTranslator

@synthesize identity;
@synthesize subject;
@synthesize condition;
@synthesize action;

-(id) initWithValues:(NSString*) i subject:(NSString*) s condition:(NSMutableDictionary*)c action:(NSMutableDictionary*) a{
     if ([self init]) {
         self.identity = i;
         self.subject = s;
         self.condition = c;
         self.action = a;
     
     }
     return self;
}


@end
