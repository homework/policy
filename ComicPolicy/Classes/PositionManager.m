//
//  PositionManager.m
//  ComicPolicy
//
//  Created by Tom Lodge on 13/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PositionManager.h"
#import "Catalogue.h"

@interface PositionManager ()
-(CGRect) getActionPosition;
-(CGRect) getActionTimePosition;
-(CGRect) getResultPosition;
-(CGRect) getResultMonitorPosition;
-(CGRect) getConditionVisitingTimePosition;
@end

@implementation PositionManager

+ (PositionManager *)sharedPositionManager
{
    static  PositionManager * sPositionManager;
    
    if (sPositionManager == nil) {
        @synchronized (self) {
            sPositionManager = [[PositionManager alloc] init];
            assert(sPositionManager != nil);
        }
    }
    return sPositionManager;
}

- (id)init
{
    // any thread, but serialised by +sharedPolicyManager
    self = [super init];
    if (self != nil) {
    }
    return self;
}

-(CGRect) getPosition:(NSString*) type{
  
    
    if ([type isEqualToString:@"action"]){
         return [self getActionPosition];
    }
    else if  ([type isEqualToString:@"resultmonitor"]){
        return [self getResultMonitorPosition];
    }
    else if  ([type isEqualToString:@"result"]){
        return [self getResultPosition];
    }
    else if  ([type isEqualToString:@"actiontime"]){
        return [self getActionTimePosition];
    }
    else if  ([type isEqualToString:@"conditionvisitingtime"]){
        return [self getConditionVisitingTimePosition];
    }
    return CGRectMake(0, 0, 0, 0);
}

-(CGRect) getConditionVisitingTimePosition{
    if (![[[Catalogue sharedCatalogue] currentCondition] isEqualToString:@"visiting"]){
        return CGRectMake(664,-360,294,301);
    }else{
        return CGRectMake(664,60,294,301);
    }
}
-(CGRect) getActionPosition{
   
    if (![[[Catalogue sharedCatalogue] currentCondition] isEqualToString:@"visiting"]){
        return CGRectMake(666,26,294,334);
        
    }else{
        
        return CGRectMake(64,334,294,301);
    }
}

-(CGRect) getActionTimePosition{
    if ([[[Catalogue sharedCatalogue] currentActionType] isEqualToString:@"block"]){
        
        if ([[[Catalogue sharedCatalogue] currentCondition] isEqualToString:@"visiting"]){
            return CGRectMake(364, 367, 294, 301);            
        }else{
            
            return CGRectMake(64, 367, 294, 301);
            
        }
        
    }else{
        if ([[[Catalogue sharedCatalogue] currentCondition] isEqualToString:@"visiting"]){
            return CGRectMake(64, 800, 294, 301);

            
        }else{
            return  CGRectMake(64, 800, 294, 301);

        }
    }
    
    return CGRectMake(0, 0, 0, 0);
}

-(CGRect) getResultPosition{
    
    
    if ([[[Catalogue sharedCatalogue] currentActionType] isEqualToString:@"block"]){
        
        if ([[[Catalogue sharedCatalogue] currentCondition] isEqualToString:@"visiting"]){
            return CGRectMake(600,150,300,150);
            
            
        }else{
            return CGRectMake(729,0,168,301);
            
        }
        
    }else{
        if ([[[Catalogue sharedCatalogue] currentCondition] isEqualToString:@"visiting"]){
           
            return CGRectMake(697,0,199,301);
            
        }else{
            
            return  CGRectMake(438,0,458,301);
        }
    }
    
    return CGRectMake(0, 0, 0, 0);
}


-(CGRect) getResultMonitorPosition{
    
    if ([[[Catalogue sharedCatalogue] currentActionType] isEqualToString:@"block"]){
        
        if ([[[Catalogue sharedCatalogue] currentCondition] isEqualToString:@"visiting"]){
           
            return  CGRectMake(600,0,300,150);

        
        }else{
            return CGRectMake(300,0,497,301);

        }
    
    }else{
        if ([[[Catalogue sharedCatalogue] currentCondition] isEqualToString:@"visiting"]){
             return CGRectMake(300,0,497,301);

        }else{
            return CGRectMake(0,0,497,301);
        }
    }
    
    return CGRectMake(0, 0, 0, 0);
}

@end
