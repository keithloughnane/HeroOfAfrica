//
//  Bullet.mm
//  LevelSVG
//
//  Created by Ricardo Quesada on 05/05/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION


#import "Bullet.h"
#import "GameNode.h"
#import "GameConstants.h"
#import "SimpleAudioEngine.h"
#import "BodyNode.h"

#define BULLET_LIFE_SECONDS (2)
#define FIRE_VELOCITY (7)

//
// Bullet can't be created from SVG.
// It is an special node that is created when the "fire" button is pressed,
// and the position and direction depends on the Hero's position & direction.
//

@implementation Bullet

@synthesize ownedByEnemy = ownedByEnemy_;

-(id) initWithPosition:(b2Vec2)position directionX:(int)directionX directionY:(int)directionY game:(GameNode*)game ownedByEnemy:(BOOL)ownedByEnemyPass
{	
	
	ownedByEnemy_ = ownedByEnemyPass;
	b2CircleShape shape;
	
	shape.m_radius = 7/kPhysicsPTMRatio; // 14 pixels wide
	
	b2FixtureDef fd;
	fd.shape = &shape;
	fd.density = 20.0f;
	fd.restitution = 0.05f;
	
	fd.filter.groupIndex = -kCollisionFilterGroupIndexHero; // bullets should never collide with the hero
	
	b2BodyDef bd;
	bd.type = b2_dynamicBody;
//	bd.type = b2_kinematicBody; // it's not affected by gravity
	bd.bullet = true;
	bd.position = position;
	
	// weak reference
	world_ = [game world];
	
	b2Body *body = world_->CreateBody(&bd);
	body->CreateFixture(&fd);
	
	if( (self=[super initWithBody:body game:game] ) ) {
		if (ownedByEnemy_)
		{
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Bullet2.png"];
					[self setDisplayFrame:frame];
		}
		else{
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bullet.png"];
					[self setDisplayFrame:frame];
		}

		
		reportContacts_ = BN_CONTACT_BEGIN;
		preferredParent_ = BN_PREFERRED_PARENT_SPRITES_PNG;
		isTouchable_ = NO;
		
		elapsedTime_ = 0;
		
		/* CHANGIN THIS TO ALLOW FOR LOBBING
		 
		float velX = FIRE_VELOCITY;
		float velY = FIRE_VELOCITY;
		if( direction < 0 )
			velX = -velX;
		 
		 */
		float velX = directionX;
		float velY = directionY;
		

		
		body->SetLinearVelocity(b2Vec2(velX, velY));
		
		if(!ownedByEnemy_)
		{
		[[SimpleAudioEngine sharedEngine] playEffect: @"shoot.wav"];
		}
		// bullet should be removed ?
		removeMe_ = NO;

		// TIP:
		// This update should be called before the box2d main loop,
		// otherwise the gravities won't be cancelled
		[self scheduleUpdateWithPriority:-10];
		
		
	}
	return self;
}

-(bool) isOwnedByEnemy
{
	return ownedByEnemy_;
}

-(void) update:(ccTime)dt
{
	// anti-gravity force
	b2Vec2 gravity = world_->GetGravity();
	b2Vec2 p = body_->GetLocalCenter();
//	self.mass
	
	body_->ApplyForce( /*body_->GetMass()*/3*gravity, p );
	
	elapsedTime_ += dt;
	if( elapsedTime_ > BULLET_LIFE_SECONDS ) {

		removeMe_ = YES;
	}
	
	if( removeMe_ ) {
		world_->DestroyBody(body_);
		[[self parent] removeChild:self cleanup:YES];		
	}
	
}

-(void) beginContact:(b2Contact*)contact
{
	b2Fixture* fixtureA = contact->GetFixtureA();
	b2Fixture* fixtureB = contact->GetFixtureB();
	NSAssert( fixtureA != fixtureB, @"Bullet: Box2d bug");
	
	b2Body *bodyA = fixtureA->GetBody();
	b2Body *bodyB = fixtureB->GetBody();
	
	NSAssert( bodyA != bodyB, @"Bullet: Box2d bug");
	
	// Box2d doesn't guarantees the order of the fixtures
	b2Body *otherBody = (bodyA == body_) ? bodyB : bodyA;
	b2Fixture *otherFixture = (bodyA == body_) ? fixtureB : fixtureA;
	
	// ignore sensonrs
	if( ! otherFixture->IsSensor() ) {

		// if a bullets collide with something, remove the bullet
		removeMe_ = YES;
				
		BodyNode *bNode = (BodyNode*) otherBody->GetUserData();
		if( bNode && [bNode conformsToProtocol:@protocol(BodyNodeBulletProtocol) ] )
			[(id<BodyNodeBulletProtocol>)bNode touchedByBullet:self];
	}
}
@end

