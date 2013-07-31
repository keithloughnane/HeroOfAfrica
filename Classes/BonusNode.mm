//
//  BonusNode.mm
//  LevelSVG
//
//  Created by Ricardo Quesada on 24/03/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION

#import <Box2d/Box2D.h>
#import "cocos2d.h"

#import "GameNode.h"
#import "GameConstants.h"
#import "BonusNode.h"

//
// BonusNode: base class of all the "sensor" nodes
// When the hero touches the sensor, the method "touchedByHero" will be called.
//   -> Override "touchedByHero" method so customize your own sensor
//

@implementation BonusNode

-(id) initWithBody:(b2Body*)body game:(GameNode*)game
{
	if( (self=[super initWithBody:body game:game] ) ) {

		reportContacts_ = BN_CONTACT_NONE;
		preferredParent_ = BN_PREFERRED_PARENT_SPRITES_PNG;
		//preferredParent_ = BN_PREFERRED_PARENT_PLATFORMS_PNG;
		isTouchable_ = NO;
		
		// 1. destroy already created fixtures
		[self destroyAllFixturesFromBody:body];
		
		// 2. create new fixture
		b2CircleShape	shape;
		shape.m_radius = 0.25f;		// 0.5 meter of diameter
		b2FixtureDef	fd;
		fd.shape = &shape;
		fd.isSensor = true;			// it is a sensor
		body->CreateFixture(&fd);
		
		
	}
	return self;
}

-(void) touchedByHero
{
	// override me
	
	NSAssert(NO, @"BonusNode: override me");
}
@end
