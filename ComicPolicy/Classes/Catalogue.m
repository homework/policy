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
static NSDictionary* imageLookup;
static NSDictionary* ownerLookup;

static NSArray* ownership;
static int ownershipindex;

static NSArray* devices;
static int devicesindex;

+(void) initialize{
	
	if (init)
		return;
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
	NSString *content = [[NSString alloc] initWithContentsOfFile:filePath];
	SBJsonParser *jsonParser = [SBJsonParser new];
	
		
	NSDictionary *data  = (NSDictionary *) [jsonParser objectWithString:content error:nil];
	
	if (data == nil){
		NSLog(@"DATA IS NIL>>>>");
	}
	else{
		NSDictionary *main = (NSDictionary *) [data objectForKey:@"catalogue"];
		imageLookup = [(NSDictionary *) [main objectForKey:@"images"] retain];
		ownerLookup = [(NSDictionary *) [main objectForKey:@"ownership"] retain];
		
		ownership = [[ownerLookup allKeys] retain];
		ownershipindex = 0;
		
	
		NSLog(@"owner is %@", [self currentSubjectOwner]);
		
		devices =  [[ownerLookup objectForKey:[self currentSubjectOwner]] retain];
		devicesindex = 0;
		
		for (NSString *key in devices){
			NSLog(@"device...%@", key);
		}
		//NSDictionary *devices = (NSDictionary *) [ownerLookup objectForKey:[self currentSubjectOwner]];
		//device = [[devices allValues] retain];
		//deviceindex = 0;
		
		//NSLog(@"starting at owner %@ and device %@", [self currentSubjectOwner], device);
		
		
		NSLog(@"images");
		for (id key in imageLookup){
			NSLog(@"key is %@", key);
		}
		NSLog(@"ownership");
		for (id key in ownerLookup){
			NSLog(@"key is %@", key);
		}
					   
		/*for (NSDictionary * dict in images){
			for (id key in dict){
				NSLog(@"key is %@", key);
				NSArray *x = (NSArray *) [dict objectForKey:key];
				
				for (NSDictionary * imagedict in x){
					for (id key2 in imagedict){
						NSLog(@"key 2 is %@", key2);
					}
				}
			}
		}*/
		/*NSArray *items = (NSArray*) [menu objectForKey:@"items"];
		
		for (id *item in items){
			NSLog(@"item %@", [NSString stringWithFormat:@" %@", (NSDictionary *) item]);
		}
		*/
		//for (id key in menu){
	//		NSLog(@"%@",key);
	//	}
	}
	//NSLog(@"error %@", error);//[NSString stringWithFormat:" %@", (NSDictionary *) data]);
		  
	/*	NSArray *items = (NSArray*) [menu objectForKey:@"items"];
	for (id *item in items){
		NSLog(@"item %@", [NSString stringWithFormat:" %@", (NSDictionary *) item]);
	}*/
	init = TRUE;
}	

+(NSString *) lookupMainImage:(NSString*)identity{
	NSDictionary *images = (NSDictionary *) [imageLookup objectForKey:identity];
	return [images objectForKey:@"main"];
}

+(NSString *) currentSubjectOwner{
	return [ownership objectAtIndex:ownershipindex % [ownership count]];	
}

+(NSString *) nextSubjectOwner{
	NSString *next =  [ownership objectAtIndex:++ownershipindex % [ownership count]];
	[devices release];
	devices =  [[ownerLookup objectForKey:[self currentSubjectOwner]] retain];
	devicesindex = 0;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"subjectOwnerChange" object:nil userInfo:nil];
	return next;
}

+(NSString *) nextSubjectOwnerImage{
	//NSString *identity =
	return [self lookupMainImage: [self nextSubjectOwner]];
	
	//NSDictionary *images = (NSDictionary *) [imageLookup objectForKey:identity];
	//return [images objectForKey:@"main"];
}


+(NSString *) currentSubjectDevice{
	return [devices objectAtIndex:devicesindex % [devices count]];
}

+(NSString *) nextSubjectDevice{
	return [devices objectAtIndex:++devicesindex % [devices count]];
}

+(NSString *) nextSubjectDeviceImage{
	return [self lookupMainImage: [self nextSubjectDevice]];
}

+(NSString *) currentSubjectDeviceImage{
	return [self lookupMainImage: [self currentSubjectDevice]];
}


+(NSString *) nextConditionViewController{
	return nil;
}

+(NSString *) nextActionViewController{
	return nil;
}

+(NSString *) nextActionSubject{
	return nil;
}

+(NSString *) nextAction{
	return nil;
}

@end
