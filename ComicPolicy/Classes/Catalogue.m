//
//  Catalogue.m
//  ComicPolicy
//
//  Created by Tom Lodge on 31/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Catalogue.h"



@implementation Catalogue

static BOOL init = FALSE;


+(void) initialize{
	NSLog(@"initialising");
	
	if (init)
		return;
	NSLog(@"am here...initialising");
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"json2" ofType:@"json"];
	
	NSLog(@"am here...fiel path %@", filePath);
	NSString *content = [[NSString alloc] initWithContentsOfFile:filePath];
	NSLog(@"content is %@",content);
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *data  = (NSDictionary *) [jsonParser objectWithString:content error:nil];
	
	if (data == nil){
		NSLog(@"DATA IS NIL>>>>");
	}
	/*else{
		NSDictionary *menu = (NSDictionary *) [data objectForKey:@"menu"];
		
		NSArray *items = (NSArray*) [menu objectForKey:@"items"];
		
		for (id *item in items){
			NSLog(@"item %@", [NSString stringWithFormat:@" %@", (NSDictionary *) item]);
		}
		
		//for (id key in menu){
	//		NSLog(@"%@",key);
	//	}
	}*/
	//NSLog(@"error %@", error);//[NSString stringWithFormat:" %@", (NSDictionary *) data]);
		  
	/*	NSArray *items = (NSArray*) [menu objectForKey:@"items"];
	for (id *item in items){
		NSLog(@"item %@", [NSString stringWithFormat:" %@", (NSDictionary *) item]);
	}*/
	init = TRUE;
}	

+(NSString *) resetSubjectOwner:(NSString *) image{
}

+(NSString *) nextSubjectOwnerImage{
}

+(NSString *) nextSubjectDeviceImage{
}

+(NSString *) nextConditionViewController{
}

+(NSString *) nextActionViewController{
}

+(NSString *) nextActionSubject{
}

+(NSString *) nextAction{
}

@end
