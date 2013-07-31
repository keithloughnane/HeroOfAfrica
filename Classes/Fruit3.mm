//
//  Fruit.mm
//  LevelSVG
//
//  Created by Ricardo Quesada on 03/01/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION


#import <Box2d/Box2D.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

#import "GameNode.h"
#import "GameConstants.h"
#import "Fruit3.h"


//
// Fruit: a sensor with the shape of an apple
// When touched, it will increase points in 1
//
//Yellow diamond
@implementation Yellowdiamond

-(id) initWithBody:(b2Body*)body game:(GameNode*)game
{
	if( (self=[super initWithBody:body game:game]) ) {

		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"diamond.png"];
		[self setDisplayFrame:frame];

	}
	return self;
}

-(void) touchedByHero
{
	[game_ increaseYDiamonds:1];
	[game_ increaseScore:180];
	[[SimpleAudioEngine sharedEngine] playEffect: @"pickup_coin.wav"];
		//[game_ jumpMode:2];
}
@end
