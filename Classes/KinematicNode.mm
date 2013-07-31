//
//  KinematicNode.m
//  LevelSVG
//
//  Created by Ricardo Quesada on 05/01/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION


#import <Box2d/Box2D.h>
#import "cocos2d.h"

#import "GameNode.h"
#import "GameConstants.h"
#import "KinematicNode.h"

//
// KinematicNode: Base class of the moving platforms like Elevator and MovingPlatform
//

@implementation KinematicNode
-(id) initWithBody:(b2Body*)body game:(GameNode*)game
{
	if( (self=[super initWithBody:body game:game]) ) {
		//
		// TIP:
		// Bodies that will be moved by cocos2d, should use a NULL user data
		//
		body->SetUserData(nil);
		
		//
		// TIP: Kinematic bodies won't collide with static and kinematic bodies
		//
		body->SetType(b2_kinematicBody);
//		body->SetType(b2_staticBody);
		
	}
	return self;
}

-(void) setPosition:(CGPoint)position
{
	[super setPosition:position];
	body_->SetTransform( b2Vec2( position_.x / kPhysicsPTMRatio, position_.y / kPhysicsPTMRatio),  - CC_DEGREES_TO_RADIANS(rotation_) );
}

-(void) setRotation:(float)angle
{
	[super setRotation:angle];
	body_->SetTransform( b2Vec2( position_.x / kPhysicsPTMRatio, position_.y / kPhysicsPTMRatio),  - CC_DEGREES_TO_RADIANS(rotation_) );
}
@end
