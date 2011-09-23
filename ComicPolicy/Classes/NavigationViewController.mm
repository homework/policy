    //
//  NavigationViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 30/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NavigationViewController.h"
#import "PolicyManager.h"
#import "Policy.h"

@interface NavigationViewController()
-(void) updateNavigation;
-(void) updateSelected;
@end


//TODO: Currently assume that policy ids are numbers - but they can be strings, so need to do a lookiup from view.tag to a string.

@implementation NavigationViewController

@synthesize navigationView;

static float PADDING = 15;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

    
	CGFloat ylen = [[UIScreen mainScreen] bounds].size.height;
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ylen,50)];	
	self.view = rootView;
	[rootView release];
    
    NavigationView *tmpNav = [[NavigationView alloc] initWithFrame:CGRectMake(0,0, ylen,50)];
	self.navigationView = tmpNav;
    [self.view addSubview:navigationView];
    [tmpNav release];
    
    	
    [self updateNavigation];
}

-(void) viewDidLoad{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(totalPoliciesChanged:) name:@"totalPoliciesChanged" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(policyLoaded:) name:@"policyLoaded" object:nil];
}

-(void) totalPoliciesChanged:(NSNotification*) notification{
   [self updateNavigation];
}

-(void) updateNavigation{
    
  
    NSArray *policyids = [[PolicyManager sharedPolicyManager]policyids];
    
    int buttoncount = [policyids count] + 1;
    
	float barlen = (buttoncount * 45) + (PADDING * buttoncount);
	CGFloat xlen = [[UIScreen mainScreen] bounds].size.height;
	float origin = (xlen / 2) - (barlen / 2);
	int count = 0;
	
	for (UIView *view in self.navigationView.subviews){
     //   NSLog(@"rmoving view from superview///");
		[view removeFromSuperview];	
	}
	
	
	for (NSString *policy in policyids ){
       
       
		UIImageView *button = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"empty.png"]];
		button.tag = [policy intValue];
        
       //UILabel *tmp = [[UILabel alloc] initWithFrame:CGRectMake((count < 9) ? 8 : 3,0,45,47)];
        UILabel *tmp = [[UILabel alloc] initWithFrame:CGRectMake(0,0,45,47)];
        tmp.textColor = [UIColor blackColor];
        tmp.textAlignment = UITextAlignmentCenter;
        tmp.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:30.0];
        tmp.backgroundColor = [UIColor clearColor];
		tmp.text = [NSString stringWithFormat:@"%d", count+1];
		[button addSubview:tmp];
        
		button.frame = CGRectMake(origin + (count * (45 + PADDING)), 5, 45, 47);
		button.transform = CGAffineTransformMakeScale(0.8, 0.8);	
        //button.backgroundColor = [UIColor blueColor];
		[self.navigationView addSubview:button];
        [button release];
		count++;
	}
	
	UIImageView *tmpAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addnew.png"]];
	tmpAdd.frame = CGRectMake(origin + (count * (45 + PADDING)), 5, 45,47);
	self.navigationView.addNew = tmpAdd;
	[self.navigationView addSubview:tmpAdd];
	[tmpAdd release];

    [self updateSelected];
}

//-(void) updatePolicyIds:(NSMutableArray *) policyids{
//	[navigationView updateNavigation:policyids];
//}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [touches anyObject];

	CGPoint touchLocation = [touch locationInView:self.navigationView];
	
    if (CGRectContainsPoint(self.navigationView.addNew.frame, touchLocation)){
        
        [[PolicyManager sharedPolicyManager] newDefaultPolicy];
    }
	
	for(UIView *view in self.navigationView.subviews){  ///how come none here yet??
       
               
		if (CGRectContainsPoint(view.frame, touchLocation)){
            
            
            if (view.tag > 0){
				
                if (selectedView != nil){
					selectedView.transform = CGAffineTransformMakeScale(0.8, 0.8);	
				}	
                
                selectedPolicy = view.tag;
                
                selectedView = view;
                
               // NSLog(@"SELECTED POLICY IS %d", selectedPolicy);
                [[PolicyManager sharedPolicyManager] loadPolicy:[NSString stringWithFormat:@"%d",selectedPolicy]];
                
				//view.transform = CGAffineTransformMakeScale(2.0, 2.0);
				
				break;
			}
		}
	}
}

-(void) policyLoaded:(NSNotification *) notification{
    
    Policy *p = [[PolicyManager sharedPolicyManager] currentPolicy];
       
    selectedPolicy = [p.localid intValue];
    
    [self updateNavigation];
    //[self updateSelected];
}

-(void) updateSelected{
   
    //selectedPolicy = [[[PolicyManager sharedPolicyManager] currentPolicyId] intValue];
    
    
    //NSLog(@"IN UPDATE SELECTED....");
    
    for(UIView *view in self.navigationView.subviews){
        
        if (view.tag == selectedPolicy){
            
            if (selectedView != nil){
                selectedView.transform = CGAffineTransformMakeScale(0.8, 0.8);	
               // NSLog(@"ITRANSFORMING SELECTED VIew to 0.8 0.8");
            }	
            
            ///NSLog(@"selcted view is %d", view.tag);
            view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            selectedView = view;
            break;
        }
    }

}

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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
