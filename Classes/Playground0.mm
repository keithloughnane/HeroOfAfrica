//
//  Playground0.mm
//  LevelSVG
//
//  Created by Ricardo Quesada on 11/02/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION


//
// Playground0
//
// Details:
//
// This level tries to simulate a sort of Mario Bros-like game
// It uses a "boxed" hero:
//  - It doesn't bounce (resitution=0)
//  - It doens't get stick into the walls (friction=0)
//  - It doesn't fall (fixedRotation=1)
//  - It doesn't have innertia (movement is with SetLinearVelocity) 
//
// It uses 2 spritesheets:
//	- walkerSheet for the Penguing
//  - spritesSheet for the fruits
//
//
// IMPORTANT: gravity and controls are read from the svg file
//

#import "Playground0.h"
#import "Box2dDebugDrawNode.h"
#import "BodyNode.h"



@implementation Playground0

-(void) initGraphics
{	
	// TIP: Disable this node in release mode
	// Box2dDebug draw in front of background
	Box2dDebugDrawNode *b2node = [Box2dDebugDrawNode nodeWithWorld:world_];
	[self addChild:b2node z:0];
	
	// weak ref
	spritesSheet_ = [CCSpriteSheet spriteSheetWithFile:@"sprites.png" capacity:20];
	[self addChild:spritesSheet_ z:9];
}

-(NSString*) SVGFileName
{
	return @"playground0.svg";
}

// This is the default behavior
-(void) addBodyNode:(BodyNode*)node
{
	switch (node.preferredParent) {
		case BN_PREFERRED_PARENT_SPRITES_PNG:
			[spritesSheet_ addChild:node];
			break;
			
		default:
			CCLOG(@"Unknown preferred parent");
			break;
	}
}

@end
