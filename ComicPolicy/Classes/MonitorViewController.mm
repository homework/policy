//
//  MonitorViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 05/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MonitorViewController.h"



@implementation MonitorViewController

@synthesize monitorView;
@synthesize currentMonitorScene;
@synthesize testImage;

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
    [tickTimer invalidate], tickTimer = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


-(void) viewDidLoad
{
       NSLog(@"VIEW DID LOAD>>>>>>>>>>>>>");
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    b2Vec2 gravity;
    gravity.Set(acceleration.y * 9.81, -acceleration.x * 9.81);
    world->SetGravity(gravity);
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
                 
    // Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    //self.testImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok.png"]];
    //[self.view addSubview:testImage];
    currentMonitorScene = @"resultbandwidth.png";
    CGRect aframe = CGRectMake(0,0,897,301);
	UIView *rootView = [[UIView alloc] initWithFrame:aframe];	
	self.view = rootView;
	[rootView release];
    MonitorView *mview = [[MonitorView alloc] initWithFrame: CGRectMake(0,0,497,301)];
	monitorView = mview;
    
    [self.view addSubview: monitorView];
    
    /*
    [self createPhysicsWorld];
    
    for (int i = 0; i < 10; i++){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok.png"]];
        [self.monitorView addSubview:image];
        [self addPhysicalBodyForView:image];
    }
    [self addPhysicalBodyForView:monitorView.testImage];
    
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0/60.0)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    */
    /*
    tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/25.0 
                                                 target:self 
                                               selector:@selector(tick:) 
                                               userInfo:nil 
                                                repeats:YES];*/

    
}

-(void) createPhysicsWorld
{
    CGSize screenSize = self.monitorView.bounds.size;
    //CGRect aframe = self.monitorView.frame;
    
    b2Vec2 gravity;
    gravity.Set(0, -9.81f);
    bool doSleep = false;
    world = new b2World(gravity, doSleep);
    world->SetContinuousPhysics(true);
    
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0);
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    b2EdgeShape groundBox;
    
    //bottom
    groundBox.Set(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
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
}

-(void) addPhysicalBodyForView:(UIView *) physicalView
{
    CGPoint start = self.monitorView.center;
    start.x = start.x + arc4random() % 200;
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    CGPoint p = physicalView.center;
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
    fixtureDef.density = 2.0f;
    fixtureDef.friction = 0.3f;
    fixtureDef.restitution = 0.8f;
    body->CreateFixture(&fixtureDef);
    body->SetType(b2_dynamicBody);
    physicalView.tag = (int) body;
    
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
