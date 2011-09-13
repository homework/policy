//
//  PositionManager.h
//  ComicPolicy
//
//  Created by Tom Lodge on 13/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PositionManager : NSObject {
    
}

+ (PositionManager *)sharedPositionManager;

-(CGRect) getPosition:(NSString*) type;
                       
@end
