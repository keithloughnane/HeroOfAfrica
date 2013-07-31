//
//  GameNode.h
//  LevelSVG
//
//  Created by Ricardo Quesada on 12/08/09.
//  Copyright 2009 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Box2DCallbacks.h"

// forward declarations
@class Hero;
@class HUD;
@class BodyNode;
@class BonusNode;

// game state
typedef enum
{
	kGameStatePaused,
	kGameStatePlaying,
	kGameStateGameOver,
} GameState;


// HelloWorld Layer
@interface GameNode : CCLayer
{
	
	int ammo_;
	
	int bananas_;
	int grapes_;
	int yDiamonds_;
	int bDiamonds_;
	//int health_;
	
	CCTMXTiledMap *map_;
	// box2d world
	b2World		*world_;
	
	int currentLayerNumber_;
	
	int levelNumber_;
	
	float time_;
	
	// game state
	GameState		gameState_;
	
	// the camera will be centered on the Hero
	// If you want to move the camera, you should move this value
	CGPoint		cameraOffset_;
	
	// Where should the camera be placed ? center ?
	CGPoint		heroOffset_;
	
	// game scores
	unsigned int	score_;
	
	// game lives
	int	lives_;
	
	unsigned int	jumpType_;
	
	bool haveKey;
	bool haveMapPiece;
	
	// Hero weak ref
	Hero	*hero_;
	
	// HUD weak ref
	HUD		*hud_;
		
	// Box2d: debugDraw. needed when debugging
	GLESDebugDraw *m_debugDraw;
	
	// Box2d: Used when dragging objects
	b2MouseJoint	* m_mouseJoint;
	b2Body			* m_mouseStaticBody;
	
	// box2d callbacks
	// In order to compile on SDK 2.2.x or older, they have to be pointers
	MyContactFilter			*m_contactFilter;
	MyContactListener		*m_contactListener;
	MyDestructionListener	*m_destructionListener;		
}

/** Box2d World */
@property (readwrite,nonatomic) b2World *world;

@property (readwrite,nonatomic,assign) CCTMXTiledMap *map;

/** score of the game */
@property (readonly,nonatomic) unsigned int score;

//@property (readonly,nonatomic) unsigned bool  haveKey;

/** lives of the hero */
@property (readonly,nonatomic) int lives;

@property (readonly,nonatomic) int ammo;

@property (readonly,nonatomic) int bananas;
@property (readonly,nonatomic) int grapes;
@property (readonly,nonatomic) int yDiamonds;
@property (readonly,nonatomic) int bDiamonds;
//@property (readonly,nonatomic) int health;
//@property (readonly,nonatomic) int ammo;

@property (readonly,nonatomic) float time;

@property (readonly,nonatomic) unsigned int jumpType;

@property (readonly,nonatomic) int currentLayerNumber;

@property (readonly,nonatomic) int levelNumber;

/** game state */
@property (readonly,nonatomic) GameState gameState;

/** weak ref to hero */
@property (readwrite,nonatomic,assign) Hero *hero;

/** weak ref to HUD */
@property (readwrite, nonatomic, assign) HUD *hud;

/** offset of the camera */
@property (readwrite,nonatomic) CGPoint cameraOffset;

// returns a Scene that contains the GameLevel and a HUD
+(id) scene;

// initialize game with level
-(id) init;

-(void) death;

-(void) switchLayers:(int) newLayer;

/** returns the SVGFileName to be loaded */
-(NSString*) SVGFileName;

-(void) heroJump;
-(void) heroSuperJump;
// mouse (touches)
-(BOOL) mouseDown:(b2Vec2)p;
-(void) mouseMove:(b2Vec2)p;
-(void) mouseUp:(b2Vec2)p;
-(int) getScore;

-(void) initSwitchLayers:(CCTMXTiledMap *)pmap;

-(void) showNoKeyMsg;

-(void) showNoMapPiece;


// game events
-(void) gameOver;
-(void) increaseScore:(int)score;
-(bool) increaseLife:(int)lives;
-(void) increaseAmmo:(int)ammo;

-(void) heroSuperJump;
-(void) increaseBananas:(int)amm;
-(void) increaseGrapes:(int)amm;
-(void) increaseYDiamonds:(int)amm;
-(void) increaseBDiamonds:(int)amm;

-(void) jumpMode:(int)ajumpType;

-(void) getKey;
-(BOOL) haveKey;
-(void) getMapPiece;
-(BOOL) haveMapPiece;
-(BOOL) isHeroInBoxWithTopLeft:(CGPoint)topLeft withBottomRight:(CGPoint)bottomRight;


// creates the foreground and background graphics
-(void) initGraphics;

// adds the BodyNode to the scene graph
-(void) addBodyNode:(BodyNode*)node;
@end
