    //
//  ConditionViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionViewController.h"


@implementation ConditionViewController

//@synthesize conditionArguments;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibNameAndType:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSString *) type {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
        NSMutableDictionary *dict = [[PolicyManager sharedPolicyManager] getConditionArguments:type];
         [[Catalogue sharedCatalogue] setConditionArguments:dict];
        /*if (dict != nil){
            self.conditionArguments = [[NSMutableDictionary alloc] initWithDictionary:dict];
            //sync with the catalogue...
            [[Catalogue sharedCatalogue] setConditionArguments:conditionArguments];
        }*/
        /*
        if (conditionArguments == nil){
            self.conditionArguments = [[Catalogue sharedCatalogue] conditionArguments];//:@"visiting"]; 
            NSLog(@"type - got default condition arguments %@", conditionArguments);
        }else{
            NSLog(@"got policy condition arguments %@", conditionArguments);
        }*/
        

    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    //[conditionArguments release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
