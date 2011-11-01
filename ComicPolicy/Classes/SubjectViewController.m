    //
//  SubjectViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubjectViewController.h"

@interface SubjectViewController()
-(void) doResize;
-(void) loadCaptions;
-(void) addMoreButton;
@end

@implementation SubjectViewController

//static SubjectImageLookup *lookup;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:self.view];	
	
	if (CGRectContainsPoint(subjectView.topImage.frame, touchLocation)){
		subjectView.ownercaption.alpha = 0.0;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
         [UIView setAnimationDidStopSelector:@selector(addCaptions:finished:context:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:subjectView.topImage cache:NO];
		subjectView.topImage.image = [UIImage imageNamed: [[Catalogue sharedCatalogue] nextSubjectOwnerImage]];
        [self doResize];
		[UIView commitAnimations];
        
        
        
        
	}
	else if (CGRectContainsPoint(subjectView.bottomImage.frame, touchLocation)){
      subjectView.devicecaption.alpha = 0.0;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
         [UIView setAnimationDidStopSelector:@selector(addCaptions:finished:context:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:subjectView.bottomImage cache:NO];
		subjectView.bottomImage.image = [UIImage imageNamed:[[Catalogue sharedCatalogue] nextSubjectDeviceImage]];
        
		[UIView commitAnimations];
        
	}


		
}

-(void) doResize{
   
    if (![[[Catalogue sharedCatalogue] currentSubjectDevice] isEqualToString:@"*"]){
        subjectView.topImage.frame = CGRectMake(0, 0, 295, 180);
    }else{
        subjectView.topImage.frame = CGRectMake(0, 0, 295, 301);
    }
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
    
	//lookup = [[SubjectImageLookup alloc] init];
	CGRect aframe = CGRectMake(64,60,294,301);
    
    
	SubjectView *aview = [[SubjectView alloc] initWithFrameAndImages:aframe topImage: [[Catalogue sharedCatalogue] currentSubjectOwnerImage] bottomImage: [[Catalogue sharedCatalogue] currentSubjectDeviceImage] ];//  lookup:nil];//
	
   
    
    subjectView = aview;
    
	self.view = subjectView;
     [self doResize];
    [self loadCaptions];
	[self addMoreButton];
    [aview release];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectOwnerChange:) name:@"subjectOwnerChange" object:nil];	

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectOwnerLoaded:) name:@"subjectOwnerLoaded" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conditionChange:) name:@"conditionChange" object:nil];
}

-(void) conditionChange:(NSNotification *) n{
    [self loadCaptions];
}

-(void) subjectOwnerLoaded:(NSNotification *) n{
     
    if (![[[Catalogue sharedCatalogue] currentSubjectOwner] isEqualToString:@"any"]){
       
        subjectView.bottomImage.image = [UIImage imageNamed:[[Catalogue sharedCatalogue] currentSubjectDeviceImage]];
        
        subjectView.devicecaption.text = [NSString stringWithFormat:@"device (%@)",[[Catalogue sharedCatalogue] currentDeviceName]];
        
        subjectView.ownercaption.text = [NSString stringWithFormat:@"When %@'s",[[Catalogue sharedCatalogue] currentSubjectOwner]];
        [self addMoreButton];
        
    }else{
        if ([[[Catalogue sharedCatalogue] currentCondition] isEqualToString:@"bandwidth"]){
            subjectView.devicecaption.text = @"When ALL devices";
        }else{
            subjectView.devicecaption.text = @"When any device";
        }
        subjectView.ownercaption.text = @"";
        [self addMoreButton];
    }
    
    subjectView.topImage.image = [UIImage imageNamed:[[Catalogue sharedCatalogue] currentSubjectOwnerImage]];
    [self doResize];

}

-(void) subjectOwnerChange:(NSNotification *) n{
    
    /*
     * don't do anything with the bottom image if the owner is 'any'
     */
	if ([[[Catalogue sharedCatalogue] currentSubjectOwner] isEqualToString:@"any"]){
     	subjectView.bottomImage.image = nil;
        subjectView.devicecaption.text = @"";
        [self addMoreButton];
        return;
    }
    
    subjectView.devicecaption.alpha = 0.0;
	
    
  	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelay:0.70];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(addCaptions:finished:context:)];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:subjectView.bottomImage cache:NO];
	subjectView.bottomImage.image = [UIImage imageNamed:[[Catalogue sharedCatalogue] currentSubjectDeviceImage]];
    [UIView commitAnimations];
    [self addMoreButton];
    
      
}

-(void) addMoreButton{
    
    if (moreButton != nil){
        [moreButton removeFromSuperview];
        moreButton = nil;
    }
    
    if ([[[Catalogue sharedCatalogue] currentSubjectOwner] isEqualToString:@"any"])
        return;
    
    if ([[Catalogue sharedCatalogue] subjectHasMultipleDevices]){
        NSLog(@"The subject has multiple devices....");
        moreButton = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sgreenbuttonup.png"]] autorelease];
        moreButton.frame = CGRectMake(270,210, moreButton.frame.size.width , moreButton.frame.size.height);
        [subjectView addSubview:moreButton];
    }else{
        NSLog(@"the subject doesn't have multiple devices");
    }

}


- (void)addCaptions:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [self loadCaptions];
}

-(void) loadCaptions{
    
   subjectView.devicecaption.alpha = 1.0;
    subjectView.ownercaption.alpha = 1.0;
    
    if ([[[Catalogue sharedCatalogue] currentSubjectOwner] isEqualToString:@"any"]){
        subjectView.ownercaption.text = @"";
        
    
        if ([[[Catalogue sharedCatalogue] currentCondition] isEqualToString:@"bandwidth"]){
            subjectView.devicecaption.text = @"When ALL devices";
        }else{
            subjectView.devicecaption.text = @"When any device";
        }
    }else{
        subjectView.ownercaption.text = [NSString stringWithFormat:@"When %@'s",[[Catalogue sharedCatalogue] currentSubjectOwner]];
        subjectView.devicecaption.text = [NSString stringWithFormat:@"device (%@)",[[Catalogue sharedCatalogue] currentDeviceName]];
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
