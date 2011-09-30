//
//  ComicPolicyAppDelegate.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ComicPolicyAppDelegate.h"
#import "ComicPolicyViewController.h"

@implementation ComicPolicyAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize deviceToken;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    //mirroredViewController = [[ComicPolicyViewController alloc] init];
    
    [window addSubview:viewController.view];
    
    // Make iPad window visible.
    
    [window makeKeyAndVisible];
    
    NSLog(@"sorting push...");
   	[[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
   	return YES;
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSDictionary *data = [userInfo objectForKey:@"aps"];
    NSLog(@"Policy %@ fired", [data objectForKey:@"policyid"]);
    [[PolicyManager sharedPolicyManager] policyFired:[data objectForKey:@"policyid"]];
    /*NSString *message = nil;
    id alert = [userInfo objectForKey:@"alert"];
    if ([alert isKindOfClass:[NSString class]]){
        message = alert;
    }else if ([alert isKindOfClass:[NSDictionary class]]){
        message = [alert objectForKey:@"body"];
    }
    if (alert){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Title" message:@"the message" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"button", nil];
        [alertView show];
        [alertView release];
    }
    */
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token { 

	self.deviceToken = [[[[token description]
                          stringByReplacingOccurrencesOfString: @"<" withString: @""]
                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                        stringByReplacingOccurrencesOfString: @" " withString: @""];
    
	NSLog(@"DEVICE TOKEN: %@", deviceToken);
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
