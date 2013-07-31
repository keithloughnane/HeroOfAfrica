//
//  Princess.mm
//  LevelSVG
//
//  Created by Ricardo Quesada on 03/01/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION


#import <Box2d/Box2D.h>
#import "cocos2d.h"

#import "GameNode.h"
#import "GameConstants.h"
#import "Princess.h"
#import "SimpleAudioEngine.h"
#import "Level2.h"


@implementation Princess
-(id) initWithBody:(b2Body*)body game:(GameNode*)game
{
	if( (self=[super initWithBody:body game:game] ) ) {
		
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sprite_princess_01.png"];
		[self setDisplayFrame:frame];

		reportContacts_ = BN_CONTACT_NONE;
		preferredParent_ = BN_PREFERRED_PARENT_SPRITES_PNG;
		isTouchable_ = NO;
		
		// 1. destroy already created fixtures
		[self destroyAllFixturesFromBody:body];
		
		// 2. create new fixture
		b2FixtureDef	fd;
		b2CircleShape	shape;
		shape.m_radius = 0.5f;		// 1 meter of diameter (optimized size)
		fd.friction		= kPhysicsDefaultEnemyFriction;
		fd.friction = 100.0;
		fd.density		= kPhysicsDefaultEnemyDensity;
		fd.restitution	= kPhysicsDefaultEnemyRestitution;
		fd.shape = &shape;
		body->CreateFixture(&fd);
		body->SetType(b2_dynamicBody);	

	}
	return self;
}

-(void) touchedByHero
{

	if(![game_ haveKey])
	{
		[game_ showNoKeyMsg];
	}
	else if(![game_ haveMapPiece])
	{
		[game_ showNoMapPiece];
	}
	else
	{
		/* **************** Uncomment this for demo version ********************
		if(game_.levelNumber == 1)
		{
			[[SimpleAudioEngine sharedEngine] playEffect:@"you_won.wav"];
			//NSString *str = [NSString stringWithFormat:@"Level%dCompleteScreen", game_.levelNumber];
						[game_ gameOver];
			[[CCDirector sharedDirector] replaceScene:[CCSplitRowsTransition transitionWithDuration:5 scene:[NSClassFromString(@"BuyScene") scene]]];

		}
		************************************************************************/
		//else {
		
	[[SimpleAudioEngine sharedEngine] playEffect:@"you_won.wav"];
		NSString *str = [NSString stringWithFormat:@"Level%dCompleteScreen", game_.levelNumber];
		NSLog(@">>%@",str);
				[game_ gameOver];
		[[CCDirector sharedDirector] setTries:3 ForLevel:levelNumber_];
	[[CCDirector sharedDirector] replaceScene:[CCSplitRowsTransition transitionWithDuration:0 scene:[NSClassFromString(str) scene]]];

		//}
		
		
		
		
		
	}
}

@end