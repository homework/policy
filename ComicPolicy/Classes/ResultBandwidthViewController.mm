//
//  ResultBandwidthViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 16/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultBandwidthViewController.h"

@interface ResultBandwidthViewController()
-(void) createPhysicsWorld;
-(void)addPhysicalBodyForView:(UIView *)aview;
@end

@implementation ResultBandwidthViewController

@synthesize topMask;

#define ARC4RANDOM_MAX 0x7fffffff

static float XSTART = 100;
static float YSTART = 140;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    //self.testImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok.png"]];
    //[self.view addSubview:testImage];
    //currentMonitorScene = @"resultvisits.png";
    [super loadView];
    CGRect aframe = CGRectMake(0,0,897,301);
	UIView *rootView = [[UIView alloc] initWithFrame:aframe];	
	self.view = rootView;
	[rootView release];
    MonitorView *mview = [[MonitorView alloc] initWithFrameAndImage: CGRectMake(0,0,497,301) image:@"resultbandwidth.png"];
    self.monitorView = mview;
    [mview release];
    
    
    [self.view addSubview: monitorView];
    
   
    
    self.topMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resultbandwidthtop.png"]];
   
    
    
    [self createPhysicsWorld];
    

    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0/60.0)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/25.0 
                                                 target:self 
                                               selector:@selector(tick:) 
                                               userInfo:nil 
                                                repeats:YES];
    [self.view addSubview:topMask];
    
    
    fakeDataTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 
                                                     target:self 
                                                   selector:@selector(addReading:)//requestData:) //addSite:
                                                   userInfo:nil 
                                                    repeats:YES];

}

-(void) addReading:(NSTimer*) timer{
    [topMask removeFromSuperview];
    UIImageView *moneyBag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moneybag.png"]];
    
    //generate a scale factor between 0.5 and 1.6
    double scalefactor = 0.4 + floorf(((double) arc4random() / ARC4RANDOM_MAX  ) * 0.8f);
    
    
    moneyBag.frame = CGRectMake(0,60,moneyBag.frame.size.width*scalefactor, moneyBag.frame.size.height*scalefactor);
    
    [self.view addSubview:moneyBag];
    
   
    [self addPhysicalBodyForView:moneyBag];
    [moneyBag release];
    [self.view addSubview:topMask];

}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    //b2Vec2 gravity;
    //gravity.Set(acceleration.y * 9.81, -acceleration.x * 9.81);
    //world->SetGravity(gravity);
}

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
    physicalView.tag = (int) body;
    
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
    [monitorView release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
