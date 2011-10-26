//
//  ResultBandwidthViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 16/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MonitorBandwidthViewController.h"
#import "MonitorDataSource.h"

@interface MonitorBandwidthViewController()
-(void) createPhysicsWorld;
-(void)addPhysicalBodyForView:(UIView *)aview;
/*-(void) addReading:(long) currentByteCount rangeByteCount:(long) rangeByteCount limitByteCount:(long) limitByteCount;*/
-(void) addReading:(long long) bytes;
-(void)removeOldBags;
-(void) updateDisplay:(long long) bytes;
-(void) updateCaption:(long long) bytes;
-(void) updatePercentage;
@end

@implementation MonitorBandwidthViewController

@synthesize topMask;
@synthesize caption;

#define ARC4RANDOM_MAX 0x7fffffff
#define MAXBAGS 5

static float XSTART = 100;
static float YSTART = 140;
static float KBDIVISOR = 1024;
static float MBDIVISOR = 1048576;
static float GBDIVISOR = 1073741824;

//static long MAXBYTES = 1 * 1024 * 1024;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectDeviceChange:) name:@"subjectDeviceChange" object:nil];
        

        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    

}
*/

- (void)loadView
{
    bagindex = 0;
    lastbytes = 0;
    
    CGRect aframe = [[PositionManager sharedPositionManager] getPosition:@"resultmonitor"];
    UIView *rootView = [[UIView alloc] initWithFrame:aframe];
  	self.view = rootView;
	[rootView release];
    
    
  
    monitorView = [[MonitorView alloc] initWithFrameAndImage: CGRectMake(0,0,rootView.frame.size.width, rootView.frame.size.height) image:@"resultbandwidth.png"];
  
    
    [self.view addSubview: monitorView];
    
   

    
    self.topMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resultbandwidthtop.png"]];
   
    
    
    [self createPhysicsWorld];
    

    tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/25.0 
                                                 target:self 
                                               selector:@selector(tick:) 
                                               userInfo:nil 
                                                repeats:YES];
    [self.monitorView addSubview:topMask];

    
    self.caption = [[UILabel alloc] initWithFrame:CGRectMake(monitorView.frame.size.width - 140, monitorView.frame.size.height - 33, 250, 30)];
    self.caption.textColor = [UIColor blackColor];
    self.caption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:13.0];
    self.caption.backgroundColor = [UIColor clearColor];
    self.caption.text = @"- KB of - GB";
    [self.view addSubview:caption];
    [caption release];
    
    fakeDataTimer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                                     target:self 
                                                   selector:@selector(requestData:)//addReading:) //addSite:
                                                   userInfo:nil 
                                                    repeats:YES];

    [self updatePercentage];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newBandwidthData:) name:@"newUsageData" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bandwidthPercentageChange:) name:@"bandwidthPercentageChange" object:nil];
    

}


-(void) bandwidthPercentageChange:(NSNotification *) notification{
    
    [self updatePercentage];
    
}

-(void) updatePercentage{
    NSNumber* percent = [[[Catalogue sharedCatalogue] conditionArguments] objectForKey:@"percentage"];
    
    if (percent != nil){
        percentage = [percent intValue];
    }else{
        percentage = 100;
    }
    
    [self updateCaption:lastbytes];
}

-(void) subjectDeviceChange:(NSNotification*)notification{
   
    self.caption.text = @"- KB of - GB";
    lastbytes = 0;
}


-(void) requestData:(NSTimer *) timer{
    
    
    NSString * subject = [[Catalogue sharedCatalogue] currentSubjectDevice];
    
    /*
     * Commented out for now...until new version to test against.
     */
   
    [[RPCComm sharedRPCComm] getCumulativeBandwidthFor:subject];
    
 
}

-(void) newBandwidthData:(NSNotification *) notification{
   
    NSNumber* bytes = [notification object];
    [self addReading:[bytes longLongValue]];
    
    /*SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary *data = [notification userInfo];
    NSString *responseString = [data objectForKey:@"data"];
    NSArray* results = (NSArray *) [jsonParser objectWithString:responseString error:nil];
    [self addReading: [[results objectAtIndex:0] longLongValue] rangeByteCount:[[results objectAtIndex:1] longLongValue] limitByteCount:[[results objectAtIndex:2] longLongValue]];*/
    
}

-(long long) currentLimit{
    long long limitbytecount = [[[Catalogue sharedCatalogue] allowance] longLongValue];
    
    float ratio = (float)percentage / 100.0;

    return (long long) (limitbytecount * ratio);
}

-(void) addReading:(long long) bytes{
    
    if (lastbytes == bytes)
        return;
    
    if (bytes == 0)
        return;
    
    
    if (lastbytes == 0){
        lastbytes = bytes;
        [self updateCaption:bytes];
    }else{
       
        [self updateDisplay:(bytes - lastbytes)];
        [self updateCaption:bytes];
        lastbytes = bytes;
    }
}

-(void) updateDisplay:(long long) bytes{
    
    long long limit = [self currentLimit];
    
    float scalefactor = ((float)bytes/limit) + 0.4;
    [topMask removeFromSuperview];
    [caption removeFromSuperview];
    UIImageView *moneyBag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moneybag.png"]];
    moneyBag.frame = CGRectMake(0,60,moneyBag.frame.size.width*scalefactor, moneyBag.frame.size.height*scalefactor);
    moneyBag.tag = bagindex++;
    [self.view addSubview:moneyBag];
    [self addPhysicalBodyForView:moneyBag];
    [moneyBag release];
    [self.view addSubview:topMask];
    [self.view addSubview:caption];
    [self removeOldBags];
}


-(NSString *) createUnitsString :(long long) bytes{
    NSString* units;
    float convertedRange;
    
    if (bytes <= MBDIVISOR){
        units = @"KB";
        convertedRange = bytes / KBDIVISOR;
    }
    else if (bytes <= GBDIVISOR){
        units = @"MB";
        convertedRange = bytes / MBDIVISOR;
    }else{
        units = @"GB";
        convertedRange = bytes / GBDIVISOR;
    }
    
    return [NSString stringWithFormat:@"%.1f %@", convertedRange, units];
}

-(void) updateCaption:(long long) bytes{
    
    long long limit = [self currentLimit];
    
    
    NSString* currentBytes = [self createUnitsString: bytes];
    NSString* currentLimit = [self createUnitsString: limit];
    
    caption.text = [NSString stringWithFormat:@"%@ of %@", currentBytes, currentLimit];
}


/*
-(void) addReading:(long) currentByteCount rangeByteCount:(long) rangeByteCount limitByteCount:(long) limitByteCount{
    
    if (currentByteCount <= 0) 
        return;
}*/

-(void) removeOldBags{
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        if (b->GetUserData() != NULL){
            UIView *oneView = (UIView *) b->GetUserData();
            if ((oneView.tag + MAXBAGS) < bagindex){
                [oneView removeFromSuperview];
                world->DestroyBody(b);
            }
        }   
        
    }
    
}


/*
-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    //b2Vec2 gravity;
    //gravity.Set(acceleration.y * 9.81, -acceleration.x * 9.81);
    //world->SetGravity(gravity);
}*/

-(void) createPhysicsWorld
{
    CGSize screenSize = self.monitorView.bounds.size;
    //CGRect aframe = self.monitorView.frame;
    
    b2Vec2 gravity;
    gravity.Set(1.0f, -2.81f);
    bool doSleep = false;
    world = new b2World(gravity, doSleep);
    world->SetContinuousPhysics(false);
    
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0);
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    b2EdgeShape groundBox;
    
    //bottom (with hole!)
    groundBox.Set(b2Vec2(0,0), b2Vec2((screenSize.width*0.50)/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox, 0);
    
    //bottom rhs
    groundBox.Set(b2Vec2((screenSize.width*0.698)/PTM_RATIO,0), b2Vec2(screenSize.width/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox, 0);
    
    //top
    groundBox.Set(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
    groundBody->CreateFixture(&groundBox, 0);
    
    //left
    groundBox.Set(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
    groundBody->CreateFixture(&groundBox, 0);
    
    //right
    groundBox.Set(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox, 0);
    
    //slope
    groundBox.Set(b2Vec2((screenSize.width*0.22)/PTM_RATIO, (screenSize.height*0.317)/PTM_RATIO), b2Vec2((screenSize.width*0.50)/PTM_RATIO,40/PTM_RATIO));
    groundBody->CreateFixture(&groundBox, 0);
    
    //top of slope
    groundBox.Set(b2Vec2(0, (screenSize.height*0.317)/PTM_RATIO), b2Vec2((screenSize.width*0.22)/PTM_RATIO,(screenSize.height*0.317)/PTM_RATIO));
    groundBody->CreateFixture(&groundBox, 0);
}

-(void) addPhysicalBodyForView:(UIView *) physicalView
{
    //CGPoint start = CGPointMake(self.view.center.x, self.view.center.y);
    CGPoint start = CGPointMake(XSTART, YSTART);
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    //CGPoint p = physicalView.center;
    CGPoint boxDimensions = CGPointMake(physicalView.bounds.size.width/PTM_RATIO/2.0, physicalView.bounds.size.height/PTM_RATIO/2.0);
    //bodyDef.position.Set(p.x/PTM_RATIO, (460.0 - p.y)/PTM_RATIO);
    bodyDef.position.Set(start.x / PTM_RATIO, start.y / PTM_RATIO);
    bodyDef.userData = physicalView;
    
    //tell the physics world to create the body
    b2Body *body = world->CreateBody(&bodyDef);
    b2PolygonShape dynamicBox;
    dynamicBox.SetAsBox(boxDimensions.x, boxDimensions.y);
    
    //define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicBox;
    fixtureDef.density = 4.0f;
    fixtureDef.friction = 0.4f;
    fixtureDef.restitution = 0.3f;
    body->CreateFixture(&fixtureDef);
    body->SetType(b2_dynamicBody);
}

-(void) tick:(NSTimer *)timer{
    int32 velocityIterations = 9;
    int32 positionIterations = 1;
    
    world->Step(1.0f/6.0f, velocityIterations, positionIterations);
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        if (b->GetUserData() != NULL){
            UIView *oneView = (UIView *) b->GetUserData();
            CGPoint newCenter = CGPointMake(b->GetPosition().x * PTM_RATIO, self.view.bounds.size.height - b->GetPosition().y * PTM_RATIO);
            oneView.center = newCenter;
            CGAffineTransform transform = CGAffineTransformMakeRotation(- b->GetAngle());
            oneView.transform = transform;
        }
    }
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    [caption release];
    monitorView = nil;
    //[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    [tickTimer invalidate], tickTimer = nil;
    [fakeDataTimer invalidate], fakeDataTimer = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
