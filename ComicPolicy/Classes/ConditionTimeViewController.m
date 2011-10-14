    //
//  ConditionTimeViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionTimeViewController.h"


@interface ConditionTimeViewController()
-(void) addWeekdaySelection;
-(void) updateLabelColors;
-(int) indexForDay:(NSString* ) day;
@end

@implementation ConditionTimeViewController



 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    //if ((self = [super initWithNibNameAndType:nibNameOrNil bundle:nibBundleOrNil type:@"timed"])){ 
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])){ 
       
       
        for (int i = 0; i < 7; i++){
            selected[i] = false;
        }
        
        days = [[[NSArray alloc] initWithObjects:@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun", nil] retain];
        
        [self addWeekdaySelection];
        UIImageView* topcaptionframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"captionframe.png"]];
		topcaptionframe.frame = CGRectMake(10, 10, topcaptionframe.frame.size.width, topcaptionframe.frame.size.height);
        [self.view addSubview:topcaptionframe];
        
        UILabel* caption = [[[UILabel alloc] initWithFrame:CGRectMake(10,10,topcaptionframe.frame.size.width,topcaptionframe.frame.size.height)] autorelease];
        caption.textColor = [UIColor blackColor];
        caption.textAlignment = UITextAlignmentCenter;
        caption.backgroundColor = [UIColor clearColor];
        caption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:18.0];
        caption.text = @"is used between";
        [self.view addSubview:caption];

    
        [self updateCatalogue];
        //[self updateCaption];
        //[self updateCatalogue];
	}
    return self;
}

-(void) updateCaption{
    conditionTimeView.caption.text = [NSString stringWithFormat:@"%02d:%02d and %02d:%02d %@",  fromhour, fromminute, tohour, tominute, [self weekdaycaption]];
    
}

-(NSString *) weekdaycaption{
    int fromindex, toindex;
    int i =0;
    NSMutableString *selecteddays = [NSMutableString stringWithFormat:@""];
    
    while(i < 7){
        if (selected[i]){
            fromindex = i;
            toindex = fromindex;
            
            while(selected[++toindex]);
            
            if (toindex-1 == fromindex){
                selecteddays = [NSMutableString stringWithFormat:@"%@%@%@",selecteddays, [selecteddays isEqualToString:@""] ? @"": @",", [days objectAtIndex:fromindex]];
            }else{
                 selecteddays = [NSMutableString stringWithFormat:@"%@%@%@-%@",selecteddays, [selecteddays isEqualToString:@""] ? @"": @",", [days objectAtIndex:fromindex], [days objectAtIndex:toindex-1]];
            }
            i = toindex;
        }
        i++;
    }
    
    if ([selecteddays isEqualToString:@""]){
        return @"on any day";
    }
    
    return selecteddays ;
}

-(void) addWeekdaySelection{
    
    
    NSArray *daysselected = [[[Catalogue sharedCatalogue] conditionArguments] objectForKey:@"daysofweek"];
    
    
    int index =0;
    
    NSMutableArray *tmp = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSString *day in days){
        
        int xval = 130  + (index % 3) * 50;
        int yval = 170 + (index / 3) * 30;
        index++;
        UILabel* dow = [[[UILabel alloc] initWithFrame:CGRectMake(xval,yval,50,40)] autorelease];
        dow.textColor = [UIColor blackColor];
        dow.textAlignment = UITextAlignmentCenter;
        dow.backgroundColor = [UIColor clearColor];
        dow.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:18.0];
        dow.text = day;
        [tmp addObject:dow];
        [self.view addSubview:dow];
    }
   
    dayLabels = [[[NSArray alloc] initWithArray:tmp] retain];
    
   
    if (daysselected != nil && [daysselected count] > 0){
        for (NSString *day in daysselected){
            selected[[self indexForDay:day]] = true;
        }
        [self updateLabelColors];
    }
    
    [self updateCaption];
    
}


-(int) indexForDay:(NSString* ) day{
    int index = 0;
    for (NSString *aday in days){
        if ([day isEqualToString:aday])
            return index;
        index++;
    }
    return -1;
}

-(void) updateValues:(int)index{
    
    selected[index] = !selected[index];
    
    NSMutableArray *daysofweek = [[[NSMutableArray alloc] init] autorelease];
    int selecteddayscount = 0;
    
    for (int i =0; i < 7; i++){
        if (selected[i] == true){
            [daysofweek addObject:[days objectAtIndex:i]];
            selecteddayscount += 1;
        }
    }
    
    if (selecteddayscount == 7){ //same as none selected to deselect everything
        [daysofweek removeAllObjects];
        for (int i = 0 ; i < 7; i++)
            selected[i] = false;
        [self updateLabelColors];
        [self updateCaption];
    }
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    
    if ([daysofweek count] > 0){
        [dict setValue:daysofweek forKey:@"daysofweek"];
        [[Catalogue sharedCatalogue] setConditionArguments:dict];
    } else{
        [[[Catalogue sharedCatalogue] conditionArguments] removeObjectForKey:@"daysofweek"];
    }
   
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
	
    bool labeltouched = false;
    int index = 0;
    for (UILabel *dow in dayLabels){
        if (CGRectContainsPoint(dow.frame, touchLocation)){
            labeltouched = true;
            [self updateValues:index];
            
        }
        index++;
    }
    
    [self updateLabelColors];
    [self updateCaption];
    if (!labeltouched)
        [super touchesBegan:touches withEvent:event];
}

-(void) updateLabelColors{
    for (int i =0; i < 7; i++){
        UILabel* dow = [dayLabels objectAtIndex:i];
        dow.textColor = selected[i] ? [UIColor redColor] : [UIColor blackColor];
    }
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
        // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    [days release];
 //   [dayLabels release];
}


@end
