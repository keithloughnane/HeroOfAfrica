//
//  Movingplatform.mm
//  LevelSVG
//
//  Created by Ricardo Quesada on 05/01/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION


#import <Box2d/Box2D.h>
#import "cocos2d.h"

#import "GameConstants.h"
#import "Movingplatform.h"

//
// MovingPlatform: A Kinematic platfroms that uses cocos2d actions instead of box2d forces
//
// Supported parameters:
//	direction (string): "horizontal" is an horizontal movement. Else it will be a vertical movement
//

@implementation Movingplatform


-(id) initWithBody:(b2Body*)body game:(GameNode*)game
{
	if( (self=[super initWithBody:body game:game]) ) {
		
		
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btn-back-normal.png"];
		[self setDisplayFrame:frame];
		
		// bodyNode properties
		reportContacts_ = BN_CONTACT_NONE;
		preferredParent_ = BN_PREFERRED_PARENT_PLATFORMS_PNG;
		
		isTouchable_ = NO;
		
		// boxes (platforms) needs a 0,1 anchor point
		[self setAnchorPoint:ccp(0,1)];
		
		//
		// Position the platform
		b2Vec2 pos = body->GetPosition();
		[self setPosition: ccp(pos.x * kPhysicsPTMRatio, pos.y * kPhysicsPTMRatio)];
		
		CGSize size = CGSizeZero;
		
		b2Fixture *fixture = body->GetFixtureList();
		
		b2Shape::Type t = fixture->GetType();
		
		if( t ==  b2Shape::e_polygon ) {
			b2PolygonShape *box = dynamic_cast<b2PolygonShape*>(fixture->GetShape());
			if( box->GetVertexCount() == 4 ) {
				size.width = box->GetVertex(2).x * kPhysicsPTMRatio;
				size.height = -box->GetVertex(0).y * kPhysicsPTMRatio;
				
				[self setTextureRect:CGRectMake(rect_.origin.x, rect_.origin.y, size.width, size.height)];				 
				
			} else
				CCLOG(@"LevelSVG: Movingplatform with unsupported number of vertices: %d", box->GetVertexCount() );
		} else
			CCLOG(@"LevelSVG: Movingplatform with unsupported shape type");
	}
	return self;
}

-(void) setParameters:(NSDictionary*)dict
{
	[super setParameters:dict];

	NSString *dir = [dict objectForKey:@"direction"];
	//NSLog(@"dir = %@",dir);
	if( [dir isEqualToString:@"horizontal"] )
		direction = kPlatformDirectionHorizontal;
	else 
		direction = kPlatformDirectionVertical;
	
	// Move the plaform using actions
	[self runAction: [self getAction]];		
}

-(CCAction*) getAction
{	
	
	id forward;
	if(direction == kPlatformDirectionHorizontal)
		// Horizontal Movement
		forward = [CCEaseInOut actionWithAction:[CCMoveBy actionWithDuration:4 position:ccp(250,0)] rate:3];
	else 
		// Vertical Movement
		forward = [CCEaseInOut actionWithAction:[CCMoveBy actionWithDuration:1.5f position:ccp(0,150)] rate:3];
		
	
	id back = [forward reverse];
	id seq = [CCSequence actions:forward, back, nil];
	return [CCRepeatForever actionWithAction:seq];
}

@end
