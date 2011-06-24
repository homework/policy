//
//  PolicyTranslator.h
//  ComicPolicy
//
//  Created by Tom Lodge on 24/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PolicyTranslator : NSObject {
    
    NSString*   identity;
    
    NSString*   subject;
    
    NSMutableDictionary* condition;
    
    NSMutableDictionary* action;
    
}

-(id) initWithValues:(NSString*) identity subject:(NSString*) subject condition:(NSMutableDictionary*)condition action:(NSMutableDictionary*) action;

@property(nonatomic, copy) NSString* identity;
@property(nonatomic, copy) NSString* subject;
@property(nonatomic, copy) NSMutableDictionary* condition;
@property(nonatomic, copy) NSMutableDictionary* action;

@end
