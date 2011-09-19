    //
//  ResultVisitsViewController.m
//  ComicPolicy
//
//  Created by Tom Lodge on 06/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MonitorVisitsViewController.h"
#import "MonitorVisitsView.h"
#import "MonitorDataSource.h"
#import "JSON.h"

@interface MonitorVisitsViewController()
-(void) createPhysicsWorld;
-(void)addPhysicalBodyForView:(UIView *)aview;
-(void) reset;
-(void) createBoundaries;
-(void) removeOldSites;
@end

#define MAXSITES 5

static float XSTART = 200;
static float YSTART = 280;


static int siteindex;
static NSArray *labelArray = [[NSArray alloc] initWithObjects:@"news.bbc.co.uk", @"www.drupal.org", @"www.facebook.com", @"www.google.com", @"sport.bbc.co.uk", @"naughtygirls.xxx", nil];

@implementation MonitorVisitsViewController

@synthesize cloud;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
 * NB still need to resioze images at strat to correct proportions - the scale subviews only works
 * when the UIView is explicitly resized.
 */

- (void)loadView
{
    
    
    NSLog(@"in monitor view load view....");

    labelindex = 0;
    siteindex = 0;
    //self.testImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok.png"]];
    //[self.view addSubview:testImage];
    //currentMonitorScene = @"resultvisits.png";
    
    CGRect aframe = [[PositionManager sharedPositionManager] getPosition:@"resultmonitor"];
	UIView *rootView = [[UIView alloc] initWithFrame:aframe];		
    [rootView setAutoresizesSubviews:YES];
	self.view = rootView;
	self.view.backgroundColor = [UIColor blueColor];
    [rootView release];
    
    
    self.monitorView = [[MonitorVisitsView alloc] initWithFrame: CGRectMake(0,0,rootView.frame.size.width, rootView.frame.size.height)];
    [self.monitorView setAutoresizesSubviews:YES];
    
    UIImageView *tmpBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resultvisits.png"]];
    tmpBack.autoresizingMask = UIViewContentModeScaleAspectFit | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tmpBack.frame = CGRectMake(0, 0, monitorView.frame.size.width, monitorView.frame.size.height);
    
    UIImageView *tmpCloud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resultvisitscloud1.png"]];
    tmpCloud.frame = tmpBack.frame;
    tmpCloud.autoresizingMask = UIViewContentModeScaleAspectFit | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    

    UIImageView *tmpCloud2 =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resultvisitscloud2.png"]];
    tmpCloud2.frame = tmpBack.frame;
    tmpCloud2.autoresizingMask = UIViewContentModeScaleAspectFit | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    

    self.cloud = tmpCloud2;
    [tmpCloud2 release];
    
	
    
    
    [self.view addSubview:tmpBack];
    [self.view addSubview:tmpCloud];
    [self.view addSubview:cloud];
    
    [self.view addSubview: monitorView];
    
    
    [self createPhysicsWorld];
    
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0/60.0)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    
    tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/25.0 
                                                 target:self 
                                               selector:@selector(tick:) 
                                               userInfo:nil 
                                                repeats:YES];

    fakeDataTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 
                                                 target:self 
                                                   selector:@selector(requestData:) //addSite:
                                               userInfo:nil 
                                                repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectDeviceChange:) name:@"subjectDeviceChange" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newVisitsData:) name:@"newVisitsData" object:nil];
	
}

-(void) subjectDeviceChange:(NSNotification*)notification{
    [self reset];
}

-(void) reset{
    [tickTimer invalidate];
    tickTimer = nil;
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        if (b->GetUserData() != NULL){
            UIView *oneView = (UIView *) b->GetUserData();
            [oneView removeFromSuperview];
        }   
        world->DestroyBody(b);
    }
    
    [self createBoundaries];
    
    tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/25.0 
                                                 target:self 
                                               selector:@selector(tick:) 
                                               userInfo:nil 
                                                repeats:YES];
    
}


-(void) requestData:(NSTimer *) timer{
    NSString * subject = [[Catalogue sharedCatalogue] currentSubjectDevice];
    NSString *rootURL  = [[NetworkManager sharedManager] rootURL];
    int limit = 3;
    NSString *strurl = [NSString stringWithFormat:@"%@/monitor/web/%@?limit=%d", rootURL, subject, limit];
    [[MonitorDataSource sharedDatasource] requestURL: strurl callback:@"newVisitsData"];
}

-(void) newVisitsData:(NSNotification *) notification{
   
    NSDictionary *data = [notification userInfo];
    NSString *responseString = [data objectForKey:@"data"];    
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    
    
    NSArray *sites  = (NSArray *) [jsonParser objectWithString:responseString error:nil];
    [cloud removeFromSuperview];
    for (NSDictionary *site in sites){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,300,35)];
        label.tag = labelindex++;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = [site objectForKey:@"url"];
        label.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:35.0];
        [self.view addSubview:label];
        [self addPhysicalBodyForView:label];
        [label release];
    }
    [self.view addSubview:cloud];
    [self removeOldSites];
}


-(void) addSite:(NSTimer *) timer{

    
    [cloud removeFromSuperview];
   // CGPoint start = self.view.center;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(XSTART,YSTART,350,35)];
    label.tag = labelindex++;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    
    label.text = [labelArray objectAtIndex: (siteindex % [labelArray count])];
    label.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:45.0];
   
    [self.view addSubview:label];
    [self addPhysicalBodyForView:label];
    siteindex += 1;
    [self.view addSubview:cloud];
    [self removeOldSites];
}

-(void) removeOldSites{
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        if (b->GetUserData() != NULL){
            UIView *oneView = (UIView *) b->GetUserData();
            oneView.alpha -= 0.1;
            if ((oneView.tag + MAXSITES) < labelindex || oneView.alpha <= 0){
                [oneView removeFromSuperview];
                 world->DestroyBody(b);
            }
        }   
    }
}

- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[self addPhysicalBodyForView:currentLabel];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

-(void) createPhysicsWorld
{
  
    //CGRect aframe = self.monitorView.frame;
    
    b2Vec2 gravity;
    gravity.Set(0, -9.81f);
    bool doSleep = false;
    world = new b2World(gravity, doSleep);
    world->SetContinuousPhysics(true);
    
    [self createBoundaries];
}

-(void) createBoundaries{
    CGSize screenSize = self.monitorView.bounds.size;
    
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

-(void) addPivotJoint:(UIView *) pivotView{
        

}
/*
-(void) addPivotsToPhysicalWorld: (UIView *) apivot plank:(UIView*)aplank{
    b2BodyDef pivotBodyDef;
    pivotBodyDef.type = b2_staticBody;
    CGPoint boxDimensions = CGPointMake(apivot.bounds.size.width/PTM_RATIO/2.0, apivot.bounds.size.height/PTM_RATIO/2.0);
    //pivotBodyDef.position.Set( (210) / PTM_RATIO, (220) / PTM_RATIO);
    pivotBodyDef.userData = apivot;
    b2Body *pivotbody = world->CreateBody(&pivotBodyDef);
    b2PolygonShape dynamicPivotBox;
    dynamicPivotBox.SetAsBox(boxDimensions.x, boxDimensions.y);
    b2FixtureDef pivotfixtureDef;
    pivotfixtureDef.shape = &dynamicPivotBox;
    pivotbody->CreateFixture(&pivotfixtureDef);
    pivotbody->SetType(b2_staticBody);
   
    b2BodyDef plankBodyDef;
    plankBodyDef.type = b2_dynamicBody;
    CGPoint plankBoxDimensions = CGPointMake(aplank.bounds.size.width/PTM_RATIO/2.0, aplank.bounds.size.height/PTM_RATIO/2.0);
    plankBodyDef.position.Set( 210 / PTM_RATIO, (230) / PTM_RATIO);
    plankBodyDef.userData = aplank;
    b2Body *plankbody = world->CreateBody(&plankBodyDef);
    b2PolygonShape dynamicPlankBox;
    dynamicPlankBox.SetAsBox(plankBoxDimensions.x, plankBoxDimensions.y);
    b2FixtureDef plankfixtureDef;
    plankfixtureDef.shape = &dynamicPlankBox;
    
   
    plankfixtureDef.density = 10.0f;
    plankfixtureDef.friction = 0.3f;
    plankfixtureDef.restitution = 0.8f;
    plankbody->CreateFixture(&plankfixtureDef);
    plankbody->SetType(b2_dynamicBody);
    
    b2RevoluteJointDef jointDef;
    jointDef.lowerAngle = -0.10f * b2_pi; //-45 deg
    jointDef.upperAngle = 0.10f * b2_pi; //45 deg
    jointDef.enableLimit = true;
    b2Vec2 anchor(200 / PTM_RATIO, 40);
    jointDef.Initialize(pivotbody, plankbody,pivotbody->GetWorldCenter());
    world->CreateJoint(&jointDef);
}*/

-(void) addPhysicalBodyForView:(UIView *) physicalView
{
    //CGPoint start = CGPointMake(self.view.center.x-250, self.view.center.y+300);
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
    fixtureDef.density = 2.0f;
    fixtureDef.friction = 0.3f;
    fixtureDef.restitution = 0.8f;
    body->CreateFixture(&fixtureDef);
    body->SetType(b2_dynamicBody);
    //physicalView.tag = (int) body;
    
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
     [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    [tickTimer invalidate], tickTimer = nil;
    [fakeDataTimer invalidate], fakeDataTimer = nil;
     [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    NSLog(@"visits view deallocing");
    [super dealloc];
    
}


@end
