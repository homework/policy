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
-(NSString *) sitestring:(NSArray *) sites flag:(NSString*)flag;
-(NSString *) percentagestring:(NSNumber *) percentage;

-(NSString *) generatePonderTalkConditionString;
-(NSString *) generatePonderTalkActionString;
-(NSString *) generateNotificationMessage;

-(void) generateCondition:(NSString*) event time:(NSString*) time;
-(void) generateAction:(NSString*) action applyfor:(NSString*) applyfor;

-(void) setAdditionalConditionArgumentsFromPonder:(NSString*) args;
-(NSArray *) getArrayFromPonderString:(NSString *) ponderString;

@end

@implementation Policy

@synthesize identity;
@synthesize localid;

//@synthesize subjectowner;
@synthesize subjectdevice;

@synthesize conditiontype;
@synthesize conditionarguments;

@synthesize actionsubject;
@synthesize actiontype;
@synthesize actionarguments;

@synthesize status;
@synthesize fired;


-(id) init{
    if (self = [super init]){
        identity = @"-1"; 
        status = unsaved;
    }
    return self;
}

- (void) updateStatus:(NSString *) state{
    if ([state isEqualToString:@"ENABLED"])
        status = enabled;
    else if ([state isEqualToString:@"DISABLED"])
        status = disabled;
    else 
        status = unsaved;
}


-(NSString *) statusAsString{
    switch (status) {
        case enabled:
            return @"active";
        
        case disabled:
            return @"saved (but NOT active)";
            
        default:
            return @"unsaved";
    }
}

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
   
    NSArray* argumentarray = [self getArrayFromPonderString:event];
    
    NSString *type = [argumentarray objectAtIndex:0];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if ([type isEqualToString:@"used"]){
        self.conditiontype =  @"timed";
        self.subjectdevice = [argumentarray objectAtIndex:1];
        
        self.conditionarguments = dict;
        
        [self setAdditionalConditionArgumentsFromPonder:time];
    
    }else if ([type isEqualToString:@"allowance"]){
    
        self.conditiontype = @"bandwidth";      
        self.subjectdevice = [argumentarray objectAtIndex:1];
        float percent = [[argumentarray objectAtIndex:2] floatValue] * (float) 100;
        
        [dict setObject: [[NSNumber numberWithFloat:percent] stringValue] forKey:@"percentage"];
        
        self.conditionarguments = dict;
    }else if ([type isEqualToString:@"visits"]){
        
        self.conditiontype = @"visiting";
        self.subjectdevice = [argumentarray objectAtIndex:1];
       
        if ([argumentarray count] > 2){
            
            NSMutableArray *sitearray = [[NSMutableArray alloc] initWithCapacity:([argumentarray count] - 2)];
            
            int i;
            
            for (i = 2; i < [argumentarray count] ; i++){
                NSString *site =  [argumentarray objectAtIndex:i];
                if ([site hasPrefix:@"-"]){
                    NSMutableString *newsite = [NSMutableString stringWithFormat:@"%@",site];
                    
                    NSRange wholeShebang = NSMakeRange(0, [site length]);
                    
                    [newsite replaceOccurrencesOfString: @"-"
                                             withString: @""
                                                options: 0
                                                  range: wholeShebang];                     
                    [dict setObject:@"negative" forKey:@"flag"];
                     [sitearray addObject:newsite];
                }else{
                    [dict setObject:@"positive" forKey:@"flag"];
                    [sitearray addObject:site];
                }
            }
            [dict setObject:sitearray forKey:@"sites"];
            self.conditionarguments = dict;
            [self setAdditionalConditionArgumentsFromPonder:time];
        }
    }
}

-(void) generateAction:(NSString*) action applyfor:(NSString*) applyfor{

    NSArray* argumentarray = [self getArrayFromPonderString:action];

    NSString *type = [argumentarray objectAtIndex:0];
   
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if ([type isEqualToString:@"block"]){
        self.actiontype = @"block";
        self.actionsubject = [argumentarray objectAtIndex:1];
        
        if (applyfor != nil){
            NSArray *actionargumentarray =  [self getArrayFromPonderString:applyfor];
            float timeframe =  [(NSString*) [actionargumentarray objectAtIndex:0] floatValue];
            [dict setObject:[NSString stringWithFormat:@"%0.f",timeframe/(float)60] forKey:@"timeframe"];
        }
        
        self.actionarguments = dict;
        
    }else if ([type isEqualToString:@"notify"]){
        self.actiontype = @"notify";
        NSArray* chunks = [[argumentarray objectAtIndex:1] componentsSeparatedByString:@","];
        self.actionsubject = [chunks objectAtIndex:0];
        [dict setObject:[chunks objectAtIndex:1] forKey: @"options"];
        self.actionarguments = dict;
    }else if ([type isEqualToString:@"prio"]){
        self.actiontype = @"prioritise";
        self.actionsubject = [argumentarray objectAtIndex:1];
        [dict setObject:[argumentarray objectAtIndex:2] forKey:@"priority"];
         self.actionarguments = dict;
    }
    
}

-(NSArray *) getArrayFromPonderString:(NSString *) ponderString{
    
    if (ponderString != nil && ![ponderString isEqualToString:@""]){
        
        NSError *error = NULL;
        
        NSRegularExpression *eventregex = [NSRegularExpression regularExpressionWithPattern:@"\\(.*?\\)" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSRegularExpression *whitespaceregex = [NSRegularExpression regularExpressionWithPattern:@"\\s" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSRegularExpression *quoteregex = [NSRegularExpression regularExpressionWithPattern:@"\"" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSRange rangeOfFirstMatch = [eventregex rangeOfFirstMatchInString:ponderString options:0 range:NSMakeRange(0, [ponderString length])];
        
        if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))){
            ponderString = [ponderString substringWithRange:NSMakeRange(rangeOfFirstMatch.location + 1, rangeOfFirstMatch.length-2)];
        } 
        
        NSString *tmp = [whitespaceregex stringByReplacingMatchesInString:ponderString options:0 range:NSMakeRange(0, [ponderString length]) withTemplate:@";"];
        
        tmp = [quoteregex stringByReplacingMatchesInString:tmp options:0 range:NSMakeRange(0, [tmp length]) withTemplate:@""];
        
        return [tmp componentsSeparatedByString:@";"];
    }
    return nil;
}

-(void) setAdditionalConditionArgumentsFromPonder:(NSString*) args{
  
    if (args != nil && ![args isEqualToString:@""]){
        
                
        NSArray* conditionargs = [self getArrayFromPonderString:args];
        
        if (conditionargs != nil && [conditionargs count] > 0){
                
            NSMutableDictionary *dict =  [[NSMutableDictionary alloc] initWithDictionary:conditionarguments];
            
                if ([conditionargs count] != 3)
                    return;
                
                [dict setObject:[conditionargs objectAtIndex:0] forKey:@"from"];
                [dict setObject:[conditionargs objectAtIndex:1] forKey:@"to"];
                if (![[conditionargs objectAtIndex:2] isEqualToString:@"*"]){
                    [dict setObject:[[conditionargs objectAtIndex:2] componentsSeparatedByString:@","] forKey:@"daysofweek"];
                }
            self.conditionarguments = dict;
            
        }
    }
}

- (id)initWithPolicy:(Policy *)aPolicy{
    
    if ([self init]) {
       // self.subjectowner       = aPolicy.subjectowner;
        self.subjectdevice      = aPolicy.subjectdevice;
        
        self.conditiontype      = aPolicy.conditiontype;
        self.conditionarguments = aPolicy.conditionarguments;
        
        self.actionsubject      = aPolicy.actionsubject;
        self.actiontype         = aPolicy.actiontype;
        self.actionarguments    = aPolicy.actionarguments;
        
        self.identity = aPolicy.identity;
        self.fired = NO;
    
    }
    return self;
}

-(NSString *) weekdaystring:(NSArray *) daysofweek{
    if (daysofweek == nil || [daysofweek count] <= 0){
        return @"*";
    }
    return [daysofweek componentsJoinedByString:@","];
}

-(NSString *) sitestring:(NSArray *) sites flag: (NSString*) flag{
    
    
    if ([flag isEqualToString:@"negative"]){
        NSMutableArray *negative = [[NSMutableArray alloc] init];
        for (NSString *site in sites){
            [negative addObject:[NSString stringWithFormat:@"-%@", site]];
        }
        return [negative componentsJoinedByString:@"\" \""];
    }
    
    return [sites componentsJoinedByString:@"\" \""];

}

-(NSString *) percentagestring:(NSNumber *) percentage{
    return [NSString stringWithFormat:@"%.3f", [percentage floatValue] / (float)100]; 
}
  
-(NSString *) toPonderString{
    NSString* conditionstring = [self generatePonderTalkConditionString];
    NSString* actionstring    = [self generatePonderTalkActionString];
    NSString* policyString = [NSString stringWithFormat:@"pe/hwpe addPolicy:\"%@\" %@ %@", @"an example policy", conditionstring, actionstring];
    return policyString;
}

-(void) print{
    NSLog(@"PRINTOUT OF THE POLICY localid %@  globalid %@{", localid, identity);
    NSLog(@"    subject device %@", subjectdevice);
    NSLog(@"    condition type %@", conditiontype);
    NSLog(@"    condition arguments %@", conditionarguments);
    NSLog(@"    action subject %@", actionsubject);
    NSLog(@"    action type is %@", actiontype);
    NSLog(@"    action arguments is %@", actionarguments);
    NSLog(@"}"); 
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
                                 [self sitestring:[conditionarguments objectForKey:@"sites"] flag:[conditionarguments objectForKey:@"flag"]]
                                  ];
        conditionstring = [NSString stringWithFormat:@"%@ %@", timestring, eventstring];
        
        
    }else if ([conditiontype isEqualToString: @"bandwidth"]){
        
        conditionstring = [NSString stringWithFormat:@"event:#(\"allowance\" \"%@\" \"%@\" \"%@\")", 
                                subjectdevice,
                                [self percentagestring:[conditionarguments objectForKey:@"percentage"]],
                                @"*"
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
        
        NSString* duration = [conditiontype isEqualToString: @"timed"] ? @"" : @"for (\"30\" \"min\")";
        
        return [NSString stringWithFormat:@"%@ %@",priority, duration];
        
    }else if ([actiontype isEqualToString:@"block"]){

        NSString *block = [NSString stringWithFormat:@"action:#(\"block\" \"%@\")",actionsubject];
 
        NSString* duration =  [actionarguments objectForKey:@"timeframe"];
        
        if (duration == nil || [duration isEqualToString:@"forever"])
            duration = @"";
        else{
        
            duration = [NSString stringWithFormat:@"for:#(\"%@\" \"min\")",duration];
        }
                             
        return [NSString stringWithFormat:@"%@ %@",block, duration];
        
        
    }else if ([actiontype isEqualToString:@"notify"]){
        
        return [NSString stringWithFormat:@"action:#(\"notify\" \"%@,%@,%@\")",actionsubject,[actionarguments objectForKey:@"options"],[self generateNotificationMessage]];
        

    }
    return @"";
}

-(NSString *) generateNotificationMessage{
    
    NSString* message = [NSString stringWithFormat:@"Hello %@ - device %@ ", self.actionsubject, self.subjectdevice];
    
    
    if ([conditiontype isEqualToString:@"visiting"]){
        message =  [NSString stringWithFormat:@"%@ visited a site", message];
    }else if ([conditiontype isEqualToString:@"bandwidth"]){
        float percent = [[conditionarguments objectForKey:@"percentage"] floatValue];
        message =  [NSString stringWithFormat:@"has used %@ percent of the bandwidth limit",  [NSString stringWithFormat:@"%.0f", percent]];
    }else if ([conditiontype isEqualToString:@"timed"]){
        message =  [NSString stringWithFormat:@"was used between %@ and %@", [conditionarguments objectForKey:@"from"], [conditionarguments objectForKey:@"to"]];
    }
    return message;
}

- (id)initWithDictionary:(NSDictionary *)aDictionary{
    if ([self init]) {
        
        NSDictionary *subject   = [aDictionary objectForKey:@"subject"];
        NSDictionary *condition = [aDictionary objectForKey:@"condition"];
        NSDictionary *action    = [aDictionary objectForKey:@"action"];
        
        //self.subjectowner       = [subject objectForKey:@"owner"];
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
