//
//  BodyNode.m
//  LevelSVG
//
//  Created by Ricardo Quesada on 19/12/09.
//  Copyright 2009 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION


#import <Box2D/Box2D.h>
#include <Box2D/Common/b2Math.h>
#import "BodyNode.h"
#import "GameConstants.h"
#import "GameNode.h"

@implementation BodyNode

@synthesize body = body_;
@synthesize reportContacts=reportContacts_;
@synthesize isTouchable=isTouchable_;
@synthesize preferredParent=preferredParent_;

-(id) initWithBody:(b2Body*)body game:(GameNode*)game
{
	//NSLog(@"inting body");
	if( (self=[super init]) ) {

		// XXX: this is not being called.
		// Think of a way to call this method from subclasses with the correct texture
		reportContacts_ = BN_CONTACT_NONE;
		body_ = body;
		isTouchable_ = NO;
		body->SetUserData(self);
		
		game_ = game;
		
		preferredParent_ = BN_PREFERRED_PARENT_IGNORE;
	} 
	//NSLog(@"finished initing body");
	return self;
}

#pragma mark BodyNode - Parameters
-(void) setParameters:(NSDictionary *)params
{
	// override me
}

// box2d contact protocol
#pragma mark BodyNode - Contact protocol

-(void) beginContact:(b2Contact*) contact
{
	// override me
}
-(void) endContact:(b2Contact*) contact
{
	// override me
}
-(void) preSolveContact:(b2Contact*)contact  manifold:(const b2Manifold*) oldManifold
{
	// override me
}
-(void) postSolveContact:(b2Contact*)contact impulse:(const b2ContactImpulse*) impulse
{
	// override me
}

// helper functions
-(void) destroyAllFixturesFromBody:(b2Body*)body
{
	b2Fixture *fixture = body->GetFixtureList();
	while( fixture != nil ) {
		b2Fixture *tmp = fixture;
		fixture = fixture->GetNext();
		body->DestroyFixture(tmp);
	}
}
@end
