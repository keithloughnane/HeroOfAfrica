//
//  GameNode.mm
//  LevelSVG
//
//  Created by Ricardo Quesada on 12/08/09.
//  Copyright 2009 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION
//

//
// This class implements the game logic like:
//
//	- scores
//	- lives
//	- updates the Box2d world
//  - object creation
//  - renders background and sprites
//  - register touch event: supports dragging box2d's objects
//

// sound imports
#import "SimpleAudioEngine.h"


// Import the interfaces
#import "GameNode.h"
#import "SVGParser.h"
#import "GameConstants.h"
#import "Box2DCallbacks.h"
#import "GameConfiguration.h"
#import "HUD.h"
#import "BodyNode.h"
#import "Hero.h"
#import "HeroRound.h"
#import "HeroBox.h"
#import "Box2dDebugDrawNode.h"
#import "BonusNode.h"
#import "Bullet.h"
#import "Level0.h"
#import "Level1.h"
#import "Level2.h"
#import "Level3.h"
#import "Level4.h"
#import "SelectLevelScene.h"



@interface GameNode (Private)
-(void) initPhysics;
-(void) initGraphics;
-(void) updateCollisions;
-(void) updateSprites;
-(void) updateCamera;

@end

// HelloWorld implementation
@implementation GameNode

@synthesize world=world_;
@synthesize time=time_;
@synthesize ammo=ammo_;
@synthesize bananas= bananas_;
@synthesize grapes=grapes_;
@synthesize yDiamonds = yDiamonds_;
@synthesize bDiamonds = bDiamonds_;

@synthesize map=map_;
@synthesize jumpType = jumpType_;
@synthesize score=score_, lives=lives_;
@synthesize gameState=gameState_;
@synthesize hero=hero_;
@synthesize hud=hud_;
@synthesize cameraOffset=cameraOffset_;
@synthesize currentLayerNumber=currentLayerNumber_;
@synthesize levelNumber=levelNumber_;
//@synthesize haveKey = haveKey_;

#pragma mark GameNode -Initialization

+(id) scene
{
	
	//NSLog(@"declaring game node scene");
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'game' is an autorelease object.
	GameNode *game = [self node];
	
	// HUD
	HUD *hud = [HUD HUDWithGameNode:game];
	[scene addChild:hud z:10];
	
	// link gameScene with HUD
	game.hud = hud;
	
	// add game as a child to scene
	[scene addChild: game];
	
	// return the scene
	return scene;
	//NSLog(@"declarED game node scene");
}


// initialize your instance here
-(id) init
{
	ammo_ = 3;
	//NSLog(@"initing game node scene");
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
		currentLayerNumber_ = -1; //Not initalised
		score_ = 0;
		lives_ = 100;
		hero_ = nil;
		haveKey = false;
		jumpType_ = 1;
		
		// game state
		gameState_ = kGameStatePaused;
		
		// camera
		cameraOffset_ = CGPointZero;
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		heroOffset_ = ccp( s.width/2, 50);
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		//NSLog(@"initng physics");
		// init box2d physics
		[self initPhysics];
		//NSLog(@"initing graphics");
		// Init graphics
		[self initGraphics];
		
		// default physics settings
		SVGParserSettings settings;
		settings.defaultDensity = kPhysicsDefaultDensity;
		settings.defaultFriction = kPhysicsDefaultFriction;
		settings.defaultRestitution = kPhysicsDefaultRestitution;
		settings.PTMratio = kPhysicsPTMRatio;
		settings.defaultGravity = ccp( kPhysicsWorldGravityX, kPhysicsWorldGravityY );
		settings.bezierSegments = kPhysicsDefaultBezierSegments;
		
		// create box2d objects from SVG file in world
		//NSLog(@"parsing SVG %@",[self SVGFileName]);
		[SVGParser parserWithSVGFilename:[self SVGFileName] b2World:world_ settings:&settings target:self selector:@selector(physicsCallbackWithBody:attribs:)];	
		
		
		[self scheduleUpdateWithPriority:0];
		
		
	}
	
	//NSLog(@"declarED game node scene");
	return self;
}

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
	gameState_ = kGameStatePlaying;
}

-(void) initGraphics
{
	CCLOG(@"LevelSVG: GameNode#initGraphics: override me");
}

-(NSString*) SVGFileName
{
	CCLOG(@"LevelSVG: GameNode:SVGFileName: override me");
	return nil;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	
	// physics stuff
	if( world_ )
		delete world_;
	
	// delete box2d callback objects
	if( m_debugDraw )
		delete m_debugDraw;
	if( m_contactListener )
		delete m_contactListener;
	if( m_contactFilter )
		delete m_contactFilter;
	if( m_destructionListener )
		delete m_destructionListener;
	
	// don't forget to call "super dealloc"
	[super dealloc];	
}

-(void) registerWithTouchDispatcher
{
	// Priorities: lower number, higher priority
	// Joystick: 10
	// GameNode (dragging objects): 50
	// HUD (dragging screen): 100
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:50 swallowsTouches:YES];
}

-(void) initPhysics
{
	// Define the gravity vector.
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	
	// Do we want to let bodies sleep?
	// This will speed up the physics simulation
	bool doSleep = true;
	
	// Construct a world object, which will hold and simulate the rigid bodies.
	world_ = new b2World(gravity, doSleep);
	
	world_->SetContinuousPhysics(true);
	
	// contact listener
	m_contactListener = new MyContactListener();
	world_->SetContactListener( m_contactListener );
	
	// contact filter
	//	m_contactFilter = new MyContactFilter();
	//	world_->SetContactFilter( m_contactFilter );
	
	// destruction listener
	m_destructionListener = new MyDestructionListener();
	world_->SetDestructionListener( m_destructionListener );
	
	// Debug Draw functions
	m_debugDraw = new GLESDebugDraw( kPhysicsPTMRatio );
	world_->SetDebugDraw(m_debugDraw);
	
	// init mouse stuff
	m_mouseJoint = NULL;
	b2BodyDef	bodyDef;
	m_mouseStaticBody = world_->CreateBody(&bodyDef);
	
	uint32 flags = 0;
	flags += b2DebugDraw::e_shapeBit;
	//	flags += b2DebugDraw::e_jointBit;
	//	flags += b2DebugDraw::e_aabbBit;
	//	flags += b2DebugDraw::e_pairBit;
	//	flags += b2DebugDraw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);			
}


#pragma mark GameNode - MainLoop

-(void) update: (ccTime) dt
{
	// Only step the world if status is Playing or GameOver
	if( gameState_ != kGameStatePaused ) {
		
		//It is recommended that a fixed time step is used with Box2D for stability
		//of the simulation, however, we are using a variable time step here.
		//You need to make an informed choice, the following URL is useful
		//http://gafferongames.com/game-physics/fix-your-timestep/
		
		int32 velocityIterations = 6;
		int32 positionIterations = 1;
		
		// Instruct the world to perform a single step of simulation. It is
		// generally best to keep the time step and iterations fixed.
		world_->Step(dt, velocityIterations, positionIterations);
		
		
		time_+= dt;
		[hud_ onUpdateTime:(int)time_];
		
		
	}
	
	// update cocos2d sprites from box2d world
	[self updateSprites];
	
	
	// update camera
	[self updateCamera];
	
	
	
}

-(void) updateCamera
{
	
	// THIS CODE MAKES THE CAMERA FOLLOW THE HERO
	if( hero_ ) {
		CGPoint pos = [hero_ position];
		
		[self setPosition:ccp(-pos.x+heroOffset_.x+cameraOffset_.x,-pos.y+heroOffset_.y+cameraOffset_.y)];
	}
	
	/*
	 // THIS CODE (SHOULD) MAKE THE CAMERA MOVE SCREEN BY SCREEN
	 if( hero_ ) {
	 
	 int layerLocation = (-currentLayerNumber_*520);
	 //int drawlocation;
	 CGPoint pos = [hero_ position];
	 
	 [self setPosition:ccp(layerLocation,   -pos.y +heroOffset_.y+cameraOffset_.y-100)];
	 }
	 */
	
}

-(void) updateSprites
{
	for (b2Body* b = world_->GetBodyList(); b; b = b->GetNext())
	{
		BodyNode *node = (BodyNode*) b->GetUserData();
		if( node ) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			node.position = ccp( b->GetPosition().x * kPhysicsPTMRatio, b->GetPosition().y * kPhysicsPTMRatio);
			node.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}	
}
-(void) showNoKeyMsg
{
	[hud_ onUpdateMsg:@"find the Key"];
}

-(void) showNoMapPiece
{
	[hud_ onUpdateMsg:@"find the map piece"];
}



-(void) gameOver
{
	
	//NSLog(@"************* CALLING GAME OVER *******************");
	
	
	[[CCDirector sharedDirector] insertScoreDetailsForLevel:levelNumber_ bananas:bananas_ grapes:grapes_ yellowDiamond:yDiamonds_ blueDiamond:bDiamonds_ health:0 time:(int)time score:score_];
	//int triesLeft = [[CCDirector sharedDirector] getTriesForLevel:levelNumber_];
	
	[[CCDirector sharedDirector] setTries:3 ForLevel:levelNumber_+1];
	
	
	
	NSMutableArray *temparr = [[NSMutableArray alloc] init];
	
	[temparr addObjectsFromArray:[[CCDirector sharedDirector] getScoreDetails:levelNumber_]];
	//NSLog(@"GO temparr filled");
	NSNumber *num = [[NSNumber alloc] init];
	//NSLog(@"GO about to get number at index 6");
	num = [temparr objectAtIndex:8];
	//NSLog(@"GO got at index 6");
	
	//int tempInt  = [num intValue];
	//tempInt++;
	
	//NSLog(@"**************************************gameOver triesLeft ugly code:%d  niceCode:%d*****************************",tempInt,triesLeft);
	
	
	gameState_ = kGameStateGameOver;
	[hud_ displayMessage:@"You Won! :)"];
}
-(void) jumpMode:(int)ajumpType
{
	// 0 no jump, 1= normal, 2 = super jump;
	jumpType_ = ajumpType;
	//[hero_ jump];
}
-(bool) increaseLife:(int)lives
{
	//NSLog(@"running increaselife lives_=%d,lives=%d",lives_,lives);
	lives_ += lives;
	
	
	
	[hud_ onUpdateLives:lives_];
	
	
	if(lives_ < 0)
	{
		lives_ =0;
		//NSLog(@"if lives <0 true lives_=%d",lives_);
	}
	if(lives_ > 100)
	{
		lives_ = 100;
	}
	//if( lives < 0 && lives_ == 0 )
	if(lives_ == 0)
	{
		[hero_ setDead:true];
		//[self death];
	}
	return false;
	
	
	
}
-(void) death
{
	//[[CCDirector sharedDirector] reduceTries:levelNumber_ by:1];
	
	[hud_ onUpdateLives:lives_];
	//NSLog(@"trying to end game lives_=%d",lives_);
	//pause();
	
	int triesLeft = [[CCDirector sharedDirector] getTriesForLevel:levelNumber_];
	
	[[CCDirector sharedDirector] setTries:triesLeft-1 ForLevel:levelNumber_];
	
	//NSLog(@"****************** DEATH ON LEVEL %d, getting tries>> %d, setting to >> %d *************************",levelNumber_,triesLeft,triesLeft-1);
	
	
	
	
	
	NSString *str = @"SelectLevelScene";   //[NSString stringWithFormat:@"Level%d", self.levelNumber-1];
	//[game_ gameOver];
	
	gameState_ = kGameStateGameOver;
	[hud_ displayMessage:@"Game Over :)"];
	
	//[[CCDirector sharedDirector] replaceScene: [CCCrossFadeTransition transitionWithDuration:1 scene:[SelectLevelScene scene]]];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:3 scene:[NSClassFromString(str) scene]]];
	
}

-(void) increaseScore:(int)score
{
	//CCTMXLayer layer = [
	score_ += score;
	[hud_ onUpdateScore:score_];
}
-(void) increaseAmmo:(int)ammo
{
	//CCTMXLayer layer = [
	ammo_ += ammo;
	[hud_ onUpdateAmmo:ammo_];
}
-(void) initSwitchLayers:(CCTMXTiledMap *)pmap
{
	self.map = pmap;
}


-(void) switchLayers:(int) newLayer
{
	
	//NSLog(@"calling switch layers");
	if(currentLayerNumber_ == newLayer)
	{
		return; 
		//nothing needs to be done
	}
	
	
	
	//NSLog(@"Switching to layer %d",newLayer);
	/*
	 CCTMXLayer *PreviousLayer = [self.map layerNamed:@"Layer 2"];
	 PreviousLayer.visible = YES;
	 
	 CCTMXLayer *NextLayer = [self.map layerNamed:@"Layer 3"];
	 NextLayer.visible = YES;
	 */
	
	//TODO add int layernumber to layer for effency
	
	
	
	if(currentLayerNumber_ == -1) //Needs to be initalised
	{
		//NSLog(@"Calling switchLayers init loop");
		for (int i = 0; i<=15; i++)
		{
			
			
			CCTMXLayer *CurrentLayer = [self.map layerNamed:[NSString stringWithFormat:@"Layer %d",i]];

				//NSLog(@"Layer %@ found",CurrentLayer.layerName);
			CurrentLayer.visible = NO;
			//[CurrentLayer release];
			
		}
	}
	
	
	//----------------- SINGLE LAYER VERSION OF CODE, COMMENT OUT DON'T DELETE ----------------------------------
	
	//NSLog(@"Calling switchLayers");
	
	
	CCTMXLayer *CurrentLayer1 = [self.map layerNamed:[NSString stringWithFormat:@"Layer %d",currentLayerNumber_]];
	CurrentLayer1.visible = NO;  //Unshow the current layer
	//[CurrentLayer1 release];
	
	CCTMXLayer *CurrentLayer2 = [self.map layerNamed:[NSString stringWithFormat:@"Layer %d",currentLayerNumber_+1]];
	CurrentLayer2.visible = NO;  //Unshow the current layer
	//[CurrentLayer2 release];
	
	CCTMXLayer *CurrentLayer3 = [self.map layerNamed:[NSString stringWithFormat:@"Layer %d",currentLayerNumber_-1]];
	CurrentLayer3.visible = NO;  //Unshow the current layer
	//[CurrentLayer3 release];
	
	
	
	
	CCTMXLayer *CurrentLayer4 = [self.map layerNamed:[NSString stringWithFormat:@"Layer %d",newLayer]];
	CurrentLayer4.visible = YES;  //Show the new layer
	//[CurrentLayer4 release];
	
	CCTMXLayer *CurrentLayer5 = [self.map layerNamed:[NSString stringWithFormat:@"Layer %d",newLayer-1]];
	CurrentLayer5.visible = YES;  //Show the new layer
	//[CurrentLayer5 release];
	
	CCTMXLayer *CurrentLayer6 = [self.map layerNamed:[NSString stringWithFormat:@"Layer %d",newLayer+1]];
	CurrentLayer6.visible = YES;  //Show the new layer
	//[CurrentLayer6 release];
	
	 
	
	//----------------- THREE LAYER VERSION OF CODE, COMMENT OUT DON'T DELETE ----------------------------------
	/* Not working yet
	 else //Take a short cut
	 {
	 NSLog(@"Calling switchLayers");
	 
	 CCTMXLayer *CurrentLayer = [self.map layerNamed:[NSString stringWithFormat:@"Layer %d",currentLayerNumber_]];
	 CurrentLayer.visible = NO;  //Unshow the current layer
	 //[CurrentLayer release];
	 
	 CCTMXLayer *CurrentLayer1 = [self.map layerNamed:[NSString stringWithFormat:@"Layer %d",newLayer]];
	 CurrentLayer1.visible = YES;  //Show the new layer
	 //[CurrentLayer1 release];
	 
	 CCTMXLayer *PreviousLayer = [self.map layerNamed:[NSString stringWithFormat:@"Layer %d",currentLayerNumber_-1]];
	 PreviousLayer.visible = NO;  //Unshow the current layer
	 //[CurrentLayer release];file://localhost/Users/keithloughnane/Desktop/LevelSVG/LevelSVG-2010-06-01/Classes/Hero.mm
	 
	 CCTMXLayer *PreviousLayer1 = [self.map layerNamed:[NSString stringWithFormat:@"Layer %d",newLayer-1]];
	 PreviousLayer1.visible = YES;  //Show the new layer
	 //[CurrentLayer1 release];
	 
	 CCTMXLayer *NextLayer = [self.map layerNamed:[NSString stringWithFormat:@"Layer %d",currentLayerNumber_+1]];
	 NextLayer.visible = NO;  //Unshow the current layer
	 //[CurrentLayer release];
	 
	 CCTMXLayer *NextLayer1 = [self.map layerNamed:[NSString stringWithFormat:@"Layer %d",newLayer+1]];
	 NextLayer1.visible = YES;  //Show the new layer
	 //[CurrentLayer1 release];
	 }
	 */
	
	
	
	
	currentLayerNumber_ = newLayer;
	/*
	 
	 CCTMXLayer *layer4 = [map layerNamed:@"Layer 4"];
	 layer4.visible = NO;
	 
	 CCTMXLayer *layer5 = [map layerNamed:@"Layer 5"];
	 layer5.visible = NO;
	 
	 CCTMXLayer *layer6 = [map layerNamed:@"Layer 6"];
	 layer6.visible = NO;
	 
	 
	 CCTMXLayer *layer7 = [map layerNamed:@"Layer 7"];
	 layer7.visible = NO;
	 
	 CCTMXLayer *layer8 = [map layerNamed:@"Layer 8"];
	 layer8.visible = NO;
	 
	 CCTMXLayer *layer9 = [map layerNamed:@"Layer 9"];
	 layer9.visible = NO;
	 
	 CCTMXLayer *layer10 = [map layerNamed:@"Layer 10"];
	 layer10.visible = NO;
	 
	 
	 CCTMXLayer *layer11 = [map layerNamed:@"Layer 12"];
	 layer11.visible = NO;
	 
	 
	 CCTMXLayer *layer12 = [map layerNamed:@"Layer 11"];
	 layer12.visible = NO;
	 
	 CCTMXLayer *layer13 = [map layerNamed:@"Layer 13"];
	 layer13.visible = NO;
	 
	 CCTMXLayer *layer14 = [map layerNamed:@"Layer 14"];
	 layer14.visible = NO;
	 
	 CCTMXLayer *layer15 = [map layerNamed:@"Layer 15"];
	 layer15.visible = NO;
	 */
	//NSLog(@"finished switch layers");
	
}

-(void) getKey
{
	haveKey = true;
}
-(void) getMapPiece
{
	haveMapPiece = true;
}
-(BOOL) haveMapPiece
{
	return haveMapPiece;
}
-(int) getScore
{
	return score_;
}

-(void) heroJump
{
	[hero_ jump];
}

-(void) heroSuperJump
{
	[hero_ jump];
}
-(void) increaseBananas:(int)amm
{
	bananas_++;
}
-(void) increaseGrapes:(int)amm
{
	grapes_++;
}
-(void) increaseYDiamonds:(int)amm
{
	yDiamonds_++;
}
-(void) increaseBDiamonds:(int)amm
{
	bDiamonds_++;
}
-(BOOL) haveKey
{
	return haveKey;
}
-(BOOL) isHeroInBoxWithTopLeft:(CGPoint)topLeft withBottomRight:(CGPoint)bottomRight
{
	CGPoint p = hero_.position;
	//NSLog(@"box1 X:%f Y: %f. box2 X:%f Y:%f .hero X:%f Y:%f",topLeft.x,topLeft.y,bottomRight.x,bottomRight.y, p.x,p.y);
	
	if((p.x > topLeft.x && p.x < bottomRight.x)
	   &&
	   (p.y > bottomRight.y && p.y < topLeft.y))
	{
		//NSLog(@"***********Hero is in box*************");
		return true;
	}
	
	return false;
}

#pragma mark GameNode - Touch Events Handler

- (BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
	CGPoint touchLocation=[touch locationInView:[touch view]];
	touchLocation=[[CCDirector sharedDirector] convertToGL:touchLocation];
	CGPoint nodePosition = [self convertToNodeSpace: touchLocation];
	//	NSLog(@"pos: %f,%f -> %f,%f", touchLocation.x, touchLocation.y, nodePosition.x, nodePosition.y);
	
	return [self mouseDown: b2Vec2(nodePosition.x / kPhysicsPTMRatio ,nodePosition.y / kPhysicsPTMRatio)];	
}

- (void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent*)event
{
	CGPoint touchLocation=[touch locationInView:[touch view]];
	touchLocation=[[CCDirector sharedDirector] convertToGL:touchLocation];
	CGPoint nodePosition = [self convertToNodeSpace: touchLocation];
	
	[self mouseMove: b2Vec2(nodePosition.x/kPhysicsPTMRatio,nodePosition.y/kPhysicsPTMRatio)];
}

- (void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent*)event
{
	CGPoint touchLocation=[touch locationInView:[touch view]];
	touchLocation=[[CCDirector sharedDirector] convertToGL:touchLocation];
	CGPoint nodePosition = [self convertToNodeSpace: touchLocation];
	
	[self mouseUp: b2Vec2(nodePosition.x/kPhysicsPTMRatio,nodePosition.y/kPhysicsPTMRatio)];
}

#pragma mark GameNode - Collision Detection


#pragma mark GameNode - Box2d Callbacks

// will be called for each created body in the parser
-(void) physicsCallbackWithBody:(b2Body*)body attribs:(NSString*)gameAttribs
{
	
	//TODO LOOK HERE This is where parsing of objects begins
	
	NSArray *values = [gameAttribs componentsSeparatedByString:@","];
	NSEnumerator *nse = [values objectEnumerator];
	
	
	BodyNode *node = nil;
	
	for( NSString *propertyValue in nse ) {
		NSArray *arr = [propertyValue componentsSeparatedByString:@"="];
		NSString *key = [arr objectAtIndex:0];
		NSString *value = [arr objectAtIndex:1];
		
		key = [key lowercaseString];
		
		if( [key isEqualToString:@"object"] ) {
			
			value = [value capitalizedString];
			Class klass = NSClassFromString( value ); //TODO << this is the tricky unsearchable bit
			
			if( klass ) {
				// The BodyNode will be added to the scene graph at init time
				node = [[klass alloc] initWithBody:body game:self];
				
				[self addBodyNode:node];
				[node release];					
			} else {
				CCLOG(@"GameNode: WARNING: Don't know how to create class: %@", value);
			}
			
		} else if( [key isEqualToString:@"objectparams"] ) {
			// Format of parameters:
			// objectParams=direction:vertical;target:1;visible:NO;
			NSDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:10];
			NSArray *params = [value componentsSeparatedByString:@";"];
			for( NSString *param in params) {
				NSArray *keyVal = [param componentsSeparatedByString:@":"];
				[dict setValue:[keyVal objectAtIndex:1] forKey:[keyVal objectAtIndex:0]];
			}
			[node setParameters:dict];
			[dict release];
			
		} else
			NSLog(@"Game Scene callback: unrecognized key: %@", key);
	}
}

// This is the default behavior
-(void) addBodyNode:(BodyNode*)node
{
	CCLOG(@"LevelSVG: GameNode#addBodyNode override me");
}

#pragma mark GameNode - Mouse (Touches)

//
// mouse code based on Box2d TestBed example: http://www.box2d.org
//

// 'button' is being pressed.
// Attach a mouseJoint if we are touching a box2d body
-(BOOL) mouseDown:(b2Vec2) p
{
	bool ret = false;
	
	if (m_mouseJoint != NULL)
	{
		return false;
	}
	
	// Make a small box.
	b2AABB aabb;
	b2Vec2 d;
	d.Set(0.001f, 0.001f);
	aabb.lowerBound = p - d;
	aabb.upperBound = p + d;
	
	// Query the world for overlapping shapes.
	MyQueryCallback callback(p);
	world_->QueryAABB(&callback, aabb);
	
	// only return yes if the fixture is touchable.
	if (callback.m_fixture )
	{
		b2Body *body = callback.m_fixture->GetBody();
		BodyNode *node = (BodyNode*) body->GetUserData();
		if( node && node.isTouchable ) {
			//
			// Attach touched body to static body with a mouse joint
			//
			body = callback.m_fixture->GetBody();
			b2MouseJointDef md;
			md.bodyA = m_mouseStaticBody;
			md.bodyB = body;
			md.target = p;
			md.maxForce = 1000.0f * body->GetMass();
			m_mouseJoint = (b2MouseJoint*) world_->CreateJoint(&md);
			body->SetAwake(true);
			
			ret = true;
		}
	}
	
	return ret;
}

//
// 'button' is not being pressed any more. Destroy the mouseJoint
//
-(void) mouseUp:(b2Vec2)p
{
	if (m_mouseJoint)
	{
		world_->DestroyJoint(m_mouseJoint);
		m_mouseJoint = NULL;
	}	
}

//
// The mouse is moving: drag the mouseJoint
-(void) mouseMove:(b2Vec2)p
{	
	if (m_mouseJoint)
	{
		m_mouseJoint->SetTarget(p);
	}
}
@end
