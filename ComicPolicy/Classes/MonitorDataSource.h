//
//  ResultDataSource.h
//  ComicPolicy
//
//  Created by Tom Lodge on 05/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MonitorDataSource : NSObject {
    
    
}
+ (MonitorDataSource *)sharedDatasource;
-(void) requestURL:(NSString*) strurl callback:(NSString*) callback;
@end
