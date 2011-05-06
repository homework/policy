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
//@synthesize externalWindow;
@synthesize viewController;
//@synthesize mirroredViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    //mirroredViewController = [[ComicPolicyViewController alloc] init];
    
    [window addSubview:viewController.view];
    
    // Make iPad window visible.
    
    [window makeKeyAndVisible];
    
   // self.externalWindow = [[UIWindow alloc] init];
    
    //self.externalWindow.hidden = YES;
    
    /*int screencount = [[UIScreen screens] count];
    
    if (screencount > 1) {
        
        NSString *screens = [NSString stringWithFormat:@"found %d screens", screencount];
        externalScreen = [[[UIScreen screens] objectAtIndex:1] retain];
        screenModes = [externalScreen.availableModes retain];
		NSLog(@"Found an external screen.");
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"External Display Size" 
														 message:@"Found an external screen,please select size" 
														delegate:self 
											   cancelButtonTitle:nil 
											   otherButtonTitles:nil] autorelease];
		for (UIScreenMode *mode in screenModes) {
			CGSize modeScreenSize = mode.size;
			[alert addButtonWithTitle:[NSString stringWithFormat:@"%.0f x %.0f pixels", modeScreenSize.width, modeScreenSize.height]];
		}
		[alert show];

    }*/
	return YES;
}

/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	UIScreenMode *desiredMode = [screenModes objectAtIndex:buttonIndex];
	externalScreen.currentMode = desiredMode;
	externalWindow.screen = externalScreen;
	
	[screenModes release];
	[externalScreen release];
	
	CGRect rect = CGRectZero;
	rect.size = desiredMode.size;
    [externalWindow makeKeyAndVisible];

    [externalWindow addSubview:[mirroredViewController view]];
    
	//externalWindow.frame = rect;
    externalWindow.frame = [[UIScreen mainScreen] applicationFrame];
	externalWindow.clipsToBounds = YES;
	externalWindow.hidden = NO;
    
	}


*/


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
