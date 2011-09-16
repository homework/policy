//
//  Policy.m
//  ComicPolicy
//
//  Created by Tom Lodge on 13/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Policy.h"

@interface Policy()
-(NSString *) weekdaystring:(NSArray *) daysofweek;
-(NSString *) sitestring:(NSArray *) sites;
-(NSString *) percentagestring:(NSNumber *) percentage;

-(NSString *) generatePonderTalkConditionString;
-(NSString *) generatePonderTalkActionString;

-(void) generateCondition:(NSString*) event time:(NSString*) time;
-(void) generateAction:(NSString*) action applyfor:(NSString*) applyfor;

@end

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



- (id) initWithPonderString:(NSString *) ponderString{
    if ([self init]){
        NSError *error = NULL;
        
        NSString *event = nil;
        NSString *time = nil;
        
        NSString *applyfor = nil;
        NSString *action = nil;
        
        
        NSRegularExpression *eventregex = [NSRegularExpression regularExpressionWithPattern:@"event:#\\(.*?\\)" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSRegularExpression *actionregex = [NSRegularExpression regularExpressionWithPattern:@"action:#\\(.*?\\)" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSRegularExpression *timeregex = [NSRegularExpression regularExpressionWithPattern:@"time:#\\(.*?\\)" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSRegularExpression *forregex = [NSRegularExpression regularExpressionWithPattern:@"for:#\\(.*?\\)" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSRange rangeOfFirstMatch = [eventregex rangeOfFirstMatchInString:ponderString options:0 range:NSMakeRange(0, [ponderString length])];
        
        if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))){
            event = [ponderString substringWithRange:rangeOfFirstMatch];
        } 
        
        rangeOfFirstMatch = [actionregex rangeOfFirstMatchInString:ponderString options:0 range:NSMakeRange(0, [ponderString length])];
        
        
        if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))){
            action = [ponderString substringWithRange:rangeOfFirstMatch];
        }
        
        rangeOfFirstMatch = [timeregex rangeOfFirstMatchInString:ponderString options:0 range:NSMakeRange(0, [ponderString length])];
        
        if (!NSEqualRanges(rangeOfFirstMatch,  NSMakeRange(NSNotFound, 0))){
            time = [ponderString substringWithRange:rangeOfFirstMatch];
        }
        
        rangeOfFirstMatch = [forregex rangeOfFirstMatchInString:ponderString options:0 range:NSMakeRange(0, [ponderString length])];
        
        
        if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))){
            applyfor = [ponderString substringWithRange:rangeOfFirstMatch];
        }

        
        [self generateCondition:event  time:time];
        [self generateAction:action applyfor:applyfor];
        
    }
    return self;
}


-(void) generateCondition:(NSString*) event time:(NSString*) time{
    
}

-(void) generateAction:(NSString*) action applyfor:(NSString*) applyfor{

    
}

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

-(NSString *) weekdaystring:(NSArray *) daysofweek{
    if ([daysofweek count] <= 0){
        return @"*";
    }
    return [daysofweek componentsJoinedByString:@","];
}

-(NSString *) sitestring:(NSArray *) sites{
    return [sites componentsJoinedByString:@"\" \""];
}

-(NSString *) percentagestring:(NSNumber *) percentage{
    return [NSString stringWithFormat:@"%.2f", [percentage floatValue] / 100]; 
}
  
-(NSString *) toPonderString{
    NSLog(@"subject owner %@", subjectowner);
    NSLog(@"subject device %@", subjectdevice);
    NSLog(@"condition type %@", conditiontype);
    NSLog(@"condition arguments %@", conditionarguments);
    NSLog(@"action subject %@", actionsubject);
    NSLog(@"action type is %@", actiontype);
    NSLog(@"action arguments is %@", actionarguments);
   
    NSString* conditionstring = [self generatePonderTalkConditionString];
    NSString* actionstring    = [self generatePonderTalkActionString];
    
       
    NSString* policyString = [NSString stringWithFormat:@"pw/hwpe addPolicy:\"%@\" %@ %@", @"an example policy", conditionstring, actionstring];
         
    //NSLog(@"%@",policyString);
    
    [self ponderStringParse:policyString];
    
    return policyString;
    
    
    
}

-(NSString *) generatePonderTalkConditionString{
    
    NSString *conditionstring = @"";
    
    if ([conditiontype isEqualToString: @"timed"]){
        
        NSString* timestring = [NSString stringWithFormat:@"time:#(\"%@\" \"%@\" \"%@\")", 
                                
                                [conditionarguments objectForKey:@"from"], 
                                [conditionarguments objectForKey:@"to"],
                                [self weekdaystring:[conditionarguments objectForKey:@"daysofweek"]]
                                ];
        
        NSString* eventstring = [NSString stringWithFormat:@"event:#(\"used\" \"%@\")", subjectdevice];
        
        conditionstring = [NSString stringWithFormat:@"%@ %@", timestring, eventstring];
        
    }else if ([conditiontype isEqualToString:@"visiting"]){
        
        NSString* timestring = @"";
        
        if ( [conditionarguments objectForKey:@"from"] != nil  && [conditionarguments objectForKey:@"to"] != nil){
        
            timestring = [NSString stringWithFormat:@"time:#(\"%@\" \"%@\" \"*\")", 
                                [conditionarguments objectForKey:@"from"], 
                                [conditionarguments objectForKey:@"to"]];
        }                       
        
        NSString *eventstring = [NSString stringWithFormat:@"event:#(\"visits\" \"%@\" \"%@\")", 
                                 subjectdevice,
                                  [self sitestring:[conditionarguments objectForKey:@"sites"]]
                                  ];
        conditionstring = [NSString stringWithFormat:@"%@ %@", timestring, eventstring];
        
        
    }else if ([conditiontype isEqualToString: @"bandwidth"]){
        
        conditionstring = [NSString stringWithFormat:@"event:#(\"allowance\" \"%@\" \"%@\" \"%@\")", 
                                @"*",
                                [self percentagestring:[conditionarguments objectForKey:@"percentage"]],
                                subjectdevice
                           ];
    }
    return conditionstring;
}


-(NSString *) generatePonderTalkActionString{
    
    if ([actiontype isEqualToString:@"prioritise"]){
        
        NSString *priority = [NSString stringWithFormat:@"action:#(\"prio\" \"%@\" \"%@\")",
                    actionsubject,
                    [actionarguments objectForKey:@"priority"]
                ];
        
        NSString* duration = [conditiontype isEqualToString: @"timed"] ? @"" : @"for (\"30\" \"m\")";
        
        return [NSString stringWithFormat:@"%@ %@",priority, duration];
        
    }else if ([actiontype isEqualToString:@"block"]){

         NSString *block = [NSString stringWithFormat:@"action:#(\"block\" \"%@\")",
                actionsubject
                ];
        
        
        
        NSString* duration =  [actionarguments objectForKey:@"timeframe"];
        
        if ([duration isEqualToString:@"forever"])
            duration = @"";
        else{
        
            duration = [NSString stringWithFormat:@"for:#(\"%@\" \"m\")",duration];
        }
                             
        
        return [NSString stringWithFormat:@"%@ %@",block, duration];
        
        
    }else if ([actiontype isEqualToString:@"notify"]){
        
        return [NSString stringWithFormat:@"action:#(\"notify\" \"%@:%@\")",actionsubject,[actionarguments objectForKey:@"options"]];
        

    }
    return @"";
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
        self.actionarguments    = (NSMutableDictionary*) [action valueForKey:@"arguments"];
    
    }
    
    return self;
}


@end
