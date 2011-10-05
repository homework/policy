//
//  ConditionTypeViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 24/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionVisitingViewController.h"

@interface ConditionVisitingViewController() 
-(void) relayout;
-(void) updateCatalogue;
-(void) readInArguments;
-(void) addSite:(NSString*)site;
@end

@implementation ConditionVisitingViewController

@synthesize sites;
@synthesize addSiteTextField;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibNameAndType:nibNameOrNil bundle:nibBundleOrNil type:@"visiting"])) {
        //NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        
        [self readInArguments];
       
        
        self.sites = [[NSMutableArray alloc] init];
        
        editing = false;
        
        CGRect nframe = CGRectMake(0,0,294,301);
		//lookup = [[ConditionImageLookup alloc] init];
		ConditionVisitingView *aconditionview = [[ConditionVisitingView alloc] initWithFrameAndImage:nframe image: [[Catalogue sharedCatalogue] getConditionImage]];
		self.view = aconditionview;
       
        conditionVisitingView = aconditionview;
		[aconditionview release];
       
        UITextField *tmpTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 10, 200,30)];
        [tmpTextField setBackgroundColor:[UIColor whiteColor]];
        [tmpTextField setBorderStyle:UITextBorderStyleLine];
        tmpTextField.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:25.0];
        tmpTextField.delegate = self;
        tmpTextField.alpha = 0.0;
        tmpTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        tmpTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        [self.view addSubview:tmpTextField];
        self.addSiteTextField = tmpTextField;
        [tmpTextField release];
        
        [self updateCatalogue];
        
        [self relayout];
        
	}
	return self;
}


-(void) readInArguments{
    NSDictionary *dict = [[Catalogue sharedCatalogue] conditionArguments];
    if ([dict objectForKey:@"flag"] != nil && [[dict objectForKey:@"flag"] isEqualToString:@"negative"])
        doesvisit = NO;
    else
        doesvisit = YES;
}


-(void) updateCatalogue{
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];

    if (doesvisit){
        [dict setObject:@"positive" forKey:@"flag"];
    }else{
        [dict setObject:@"negative" forKey:@"flag"];
    }
    
    [[Catalogue sharedCatalogue] setConditionArguments:dict];
    
     NSLog(@"condition args are %@", [[Catalogue sharedCatalogue] conditionArguments]);
}

-(void) updateCaption{
    
    if (doesvisit){
        conditionVisitingView.sitecaption.text = @"visits any of these sites";
    }
    else{
        conditionVisitingView.sitecaption.text = @"visits a site that is NOT above";
    }
    
   
}
          

-(BOOL) textFieldShouldReturn:(UITextField *)theTextField{
	[theTextField resignFirstResponder];
	return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    editing = true;
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    editing = false;
    
    NSURL* candidateURL = [NSURL URLWithString:textField.text];
    NSURL* candidateURLv2 = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", textField.text]];
    
    if ( (candidateURL && candidateURL.host) || (candidateURLv2 && candidateURLv2.host)){
        [self addSite:textField.text];
        [self relayout];
        textField.text = @"";
    }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
        addSiteTextField.alpha = 0.0;
        [UIView commitAnimations];
    
}



-(void) addSite:(NSString*) site{
    
    
    NSArray *currentsites = [[[Catalogue sharedCatalogue] conditionArguments] objectForKey:@"sites"];
    
    NSMutableArray *newargs = [[[NSMutableArray alloc] initWithArray:currentsites] autorelease];
    
    [newargs addObject:site];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:newargs forKey:@"sites"];
    [[Catalogue sharedCatalogue] setConditionArguments:dict];
    [dict release];    
    [self updateCatalogue];
}


-(void) relayout{
    
    
   for (UIView *aview in self.view.subviews){
        if (aview.tag >= 100)
            [aview removeFromSuperview];
    }
    [self.sites removeAllObjects];
    
    
    
     // regenerate labels from the catalogue...
     
    
   
    int YPOS = 40;
    
    NSMutableArray *currentsites = [[[Catalogue sharedCatalogue] conditionArguments] objectForKey:@"sites"];
    int tag = 100;
    float size = [currentsites count] >= 5 ? 20.0 : 35.0;
    int lineheight = [currentsites count] >= 5 ? 20: 40;
    
    for (NSString *site in currentsites){
        UILabel *asitelabel = [[[UILabel alloc] initWithFrame:CGRectMake(20,YPOS,250,size)] autorelease];
        asitelabel.textColor = [UIColor whiteColor];
        asitelabel.backgroundColor = [UIColor clearColor];
        asitelabel.text = site;
        asitelabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:size];
        asitelabel.tag = tag++;
        [sites addObject:asitelabel];
        [self.view addSubview:asitelabel];
        YPOS += lineheight;
    }
    
    [self updateCaption];
}

-(void) removeSite:(NSString *) site{
    
    //can't remove the last site...
    if ([sites count] == 1)
        return;
    
    for (UILabel* aLabel in sites){
        if ([aLabel.text isEqualToString:site]){
            
            NSMutableArray *currentsites = [[[Catalogue sharedCatalogue] conditionArguments] objectForKey:@"sites"];
            NSMutableArray *todiscard = [[[NSMutableArray alloc] init] autorelease];
            
            if (currentsites != nil){
                for (NSString *site in currentsites){
                    if ([site isEqualToString:aLabel.text]){
                        [todiscard addObject:site];
                    }
                }
                  [currentsites removeObjectsInArray:todiscard];
            }
            
            [aLabel removeFromSuperview];
        }
    }
    [self relayout];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];

    for (UILabel* aLabel in sites){
        if (CGRectContainsPoint(aLabel.frame, touchLocation)){
            [self removeSite:aLabel.text];
            return;
        }
    }
    
    if ( touchLocation.y > 250){
        doesvisit = !doesvisit;
        [self updateCaption];
        [self updateCatalogue];
        return;
    }
      
    
   
    
    if ((touchLocation.y > 40 && !editing)){
        [super touchesBegan:touches withEvent:event];
        return;
    }
    
         
    if (!editing){//plus button was touched
         NSArray *currentsites = [[[Catalogue sharedCatalogue] conditionArguments] objectForKey:@"sites"];
        if ([currentsites count] < 10){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.75];
            [UIView setAnimationDelegate:self];
            addSiteTextField.alpha = 1.0;
            [UIView commitAnimations];
        }
    }
    
    
    //Maybe chain the interaction rather than push up to superview??
    
    
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
    [sites release];
    [addSiteTextField release];
}


- (void)dealloc {
    [super dealloc];
	//[conditionTypeView release];
}


@end
