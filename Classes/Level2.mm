//
//  Level0.mm
//  LevelSVG
//
//  Created by Ricardo Quesada on 06/01/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION


#import "Level2.h"
#import "BodyNode.h"
#import "SimpleAudioEngine.h"

// 
// Level4
//
// Details:
//
// Instead of rendering the platoforms using the "self-render" platform objects,
// it uses a TMX tiled map.
// Both approaches have the same speed since both renders the plaforms using a TextureAtlas
//
// Pros/Cons of using TMX tiles for platforms:
//   + platforms are visually richer
//   - platforms can only be aligned horzintally
//
// It also uses a Parallax with 3 children:
//  - background image
//  - TMX tiled map
//  - sprites (hero, fruits, princess, etc)
//
//
// How to create a similar level ?
//
//	1. Create a tile map using Tiled ( http://mapeditor.org ). Tiled is supported by cocos2d
//	2. Save the project as "level4.tmx". 
//	3. Save the project as an image: "level4.png". This image is not used in the game
//		-> Tiled -> File -> Save As Image
//	4. Open Inkscape and create a new document of 480x320. Actually it can be of any size, but 480x320 is useful as a reference.
//		-> Inkscape -> File -> Document Properties -> Custom size: width=480, height=320
//	5. Create 2 layers:
//		-> physics:objects
//		-> tmx map
//	6. Select the "tmx map" layer, and import the "level4.png" image.
//		-> Inkscape -> File -> Import -> Select "level4.png"
//	7. Place the image at (0,0)
//		-> Select the image and modify x=0, y=0
//	8. Select the "physics:object" layer and start placing your physics object!
//
//
// IMPORTANT: gravity and controls are read from the svg file
//

@implementation Level2

-(void) initGraphics
{		
	
	levelNumber_ = 3;
	time_  = 0;
	//
	// Parallax Layers
	//
	CCParallaxNode *parallax = [CCParallaxNode node];
	
	// Background
	// TIP: Use 16-bit texture in background. It consumes half the memory
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGB565];
	CCSprite *background = [CCSprite spriteWithFile:@"background3.png"];
	background.anchorPoint = ccp(0,0);
	// Restore 32-bit texture format
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_Default];
	[parallax addChild:background z:-10 parallaxRatio:ccp(0.08f, 0.08f) positionOffset:ccp(-50,-50)];
	
	// Box2d debug info: 
	// TIP: Disable this node in release mode
	// Box2dDebug draw in front of background
	//	Box2dDebugDrawNode *b2node = [Box2dDebugDrawNode nodeWithWorld:world_];	
	//	[parallax addChild:b2node z:0 parallaxRatio:ccp(1,1) positionOffset:ccp(0,0)];
	
	// tiled
	CCTMXTiledMap *tiled = [CCTMXTiledMap tiledMapWithTMXFile:@"level3.tmx"];

	// sprites
	spriteSheet1_ = [CCSpriteSheet spriteSheetWithFile:@"herosprite.png" capacity:20];
	//NSLog(@"setting enemy sheet .png");
	spriteSheet2_ = [CCSpriteSheet spriteSheetWithFile:@"enemyspritesheet.png" capacity:20];

	//NSLog(@"Done setting enemy sheet .png");
	spriteSheet3_ = [CCSpriteSheet spriteSheetWithFile:@"sprites.png" capacity:20];
	
	
	
	
	[parallax addChild:tiled z:8 parallaxRatio:ccp(1,1) positionOffset:ccp(0,0)];
	
	// sprites
	spriteSheet_ = [CCSpriteSheet spriteSheetWithFile:@"sprites.png" capacity:20];
	
	// Platforms spritesheet: weak ref
	platformSheet_ = [CCSpriteSheet spriteSheetWithFile:@"platforms.png" capacity:10];
	ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
	[platformSheet_.texture setTexParameters:&params];	
	
	// add spritesheets to parallax
	[parallax addChild:spriteSheet_ z:10 parallaxRatio:ccp(1,1) positionOffset:ccp(0,0)];
	
	[parallax addChild:spriteSheet1_ z:10 parallaxRatio:ccp(1,1) positionOffset:ccp(0,0)];
	[parallax addChild:spriteSheet2_ z:10 parallaxRatio:ccp(1,1) positionOffset:ccp(0,0)];
	[parallax addChild:spriteSheet3_ z:10 parallaxRatio:ccp(1,1) positionOffset:ccp(0,0)];
	
	[parallax addChild:platformSheet_ z:10 parallaxRatio:ccp(1,1) positionOffset:ccp(0,0)];	
	//NSLog(@"done setting up paralaxs, doing sound");
	[self addChild:parallax];
	float vol = [[CCDirector sharedDirector] getBGVolume];
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:vol];
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic: @"backgroundmusic.wav" loop:true];
	//NSLog(@"sound done, initing switch layers");
	
	[super initSwitchLayers:tiled];
	
	//NSLog(@"doing initing switch layers");
}

- (void) dealloc
{
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.0];
	[super dealloc];
}

//
// GameNode callbacks
//
-(NSString*) SVGFileName
{
	return @"level3.svg";
}

// This is the default behavior
-(void) addBodyNode:(BodyNode*)node
{
	switch ( node.preferredParent) {
		case BN_PREFERRED_PARENT_SPRITES_PNG:
			[spriteSheet_ addChild:node];
			break;
			
		case BN_PREFERRED_PARENT_PLATFORMS_PNG:
			// Only supported for platforms that will be invisble
			[platformSheet_ addChild:node];
			break;			
		case BN_PREFERRED_PARENT_SPRITES1_PNG:
			[spriteSheet1_ addChild:node];
			break;
		case BN_PREFERRED_PARENT_SPRITES2_PNG:
			[spriteSheet2_ addChild:node];
			break;
		case BN_PREFERRED_PARENT_SPRITES3_PNG:
			[spriteSheet3_ addChild:node];
			break;
			
		default:
			CCLOG(@"Unknown body class: %@", [node class]);
			break;
	}
}

@end