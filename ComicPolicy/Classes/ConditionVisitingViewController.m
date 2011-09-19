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
-(void) updateCatalogue:(NSString*)site;
@end

@implementation ConditionVisitingViewController

@synthesize sites;
@synthesize addSiteTextField;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibNameAndType:nibNameOrNil bundle:nibBundleOrNil type:@"visiting"])) {
        //NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        
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
        [self relayout];
        
	}
	return self;
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
    [self updateCatalogue:textField.text];
    [self relayout];
    textField.text = @"";
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    addSiteTextField.alpha = 0.0;
    [UIView commitAnimations];
}

-(void) updateCatalogue:(NSString*) site{
    NSLog(@"updating catalogue");
    
    NSArray *currentsites = [conditionArguments objectForKey:@"sites"];
    
    NSMutableArray *newargs = [[NSMutableArray alloc] initWithArray:currentsites];
    
    [newargs addObject:site];
    
    [self.conditionArguments removeObjectForKey:@"sites"];
    
    [self.conditionArguments setObject:newargs forKey:@"sites"];
    
    [[Catalogue sharedCatalogue] setConditionArguments:conditionArguments];
    
}

-(void) relayout{
    //first remove all views that we currently have
    int index = 0;
    for (UIView *aview in self.view.subviews){
        if (index++ > 4){
            [aview removeFromSuperview];
        }
    }
    [self.sites removeAllObjects];
    
    /*
     * regenerate labels from the catalogue...
     */
    
    int YPOS = 40;
    
    //NSMutableDictionary* arguments = [[Catalogue sharedCatalogue] conditionArguments];
    
    NSMutableArray *currentsites = [conditionArguments objectForKey:@"sites"];
    
    for (NSString *site in currentsites){
        UILabel *asitelabel = [[UILabel alloc] initWithFrame:CGRectMake(20,YPOS,250,35)];
        asitelabel.textColor = [UIColor whiteColor];
        asitelabel.backgroundColor = [UIColor clearColor];
        asitelabel.text = site;
        asitelabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:35.0];
        [sites addObject:asitelabel];
        [self.view addSubview:asitelabel];
        YPOS += 40;
    }
}

-(void) removeSite:(NSString *) site{
    for (UILabel* aLabel in sites){
        if ([aLabel.text isEqualToString:site]){
            
            NSMutableArray *currentsites = [conditionArguments objectForKey:@"sites"];
            if (currentsites != nil){
                for (NSString *site in currentsites){
                    if ([site isEqualToString:aLabel.text]){
                        [currentsites removeObject:site];   
                    }
                }
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
    
    
    if (! CGRectContainsPoint(conditionVisitingView.addButton.bounds, touchLocation) && !editing){
        [super touchesBegan:touches withEvent:event];
        return;
    }
    
    if (!editing){//plus button was touched
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
        addSiteTextField.alpha = 1.0;
        [UIView commitAnimations];
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
