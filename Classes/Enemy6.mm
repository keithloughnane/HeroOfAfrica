
// TURRET ENEMEY




//  Enemy.m
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
#import "Enemy6.h"
#import "Bullet.h"

#import <Box2D/Box2D.h>
#include <Box2D/Common/b2Math.h>

#define FIRE_FREQUENCY (0.7f)
#define SPRITE_WIDTH 20
#define SPRITE_HEIGHT 44
//
// Enemy: An rounded enemy that is capable of killing the hero
//
// Supported parameters:
//	patrolTime (float): the time it takes to go from left to right. Default: 0 (no movement)
//  patrolSpeed (float): the speed of the patrol (the speed is in Box2d units). Default: 2
//

int const lives = 5;
@implementation Enemy6
-(id) initWithBody:(b2Body*)body game:(GameNode*)game
{
	//NSLog(@"Initing enemy 3");
	behaveState = WAITING;
	if( (self=[super initWithBody:body game:game]) ) {
		hitsLeft = lives;
				hitsLeft = lives;
		
				dead = false;
		deadFrame = 1;
		//NSLog(@"setting enemy1 image");
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"throwenemyfourth001.png"];
		[self setDisplayFrame:frame];
		
		// bodyNode properties
		reportContacts_ = BN_CONTACT_NONE;
		//preferredParent_ = BN_PREFERRED_PARENT_SPRITES_PNG;
		preferredParent_ = BN_PREFERRED_PARENT_SPRITES2_PNG;
		isTouchable_ = YES;
		
		// 1. destroy already created fixtures
		[self destroyAllFixturesFromBody:body];
		
		// 2. create new fixture
		b2FixtureDef	fd;
		b2PolygonShape	shape;
		//shape.m_radius = 0.5f;		// 1 meter of diameter (optimized size)
		// vertices should be in Counter Clock-Wise order, orderwise it will crash
		b2Vec2 vertices[4];
		
		
		// Sprite size is SPRITE_WIDTH x SPRITE_HEIGHT
		float height = (SPRITE_HEIGHT / kPhysicsPTMRatio) / 2;
		float width = (SPRITE_WIDTH/ kPhysicsPTMRatio) / 2;
		vertices[0].Set(-width,-height);	// bottom-left
		vertices[1].Set(width,-height);		// bottom-right
		vertices[2].Set(width,height);		// top-right
		vertices[3].Set(-width,height);		// top-left
		shape.Set(vertices, 4);
		
		fd.friction		= kPhysicsDefaultEnemyFriction;
		fd.density		= kPhysicsDefaultEnemyDensity;
		fd.restitution	= kPhysicsDefaultEnemyRestitution;
		fd.shape = &shape;
		
		// filtering... in case you want to avoid collisions between enemies
		//		fd.filter.groupIndex = - kCollisionFilterGroupIndexEnemy;
		
		body->CreateFixture(&fd);
		body->SetType(b2_dynamicBody);	
		
		removeMe_ = NO;
		patrolActivated_ = NO;
		
		fireFrames = 1;
		
		[self schedule:@selector(update:)];
	}
	return self;
}

-(void) setParameters:(NSDictionary *)params
{
	[super setParameters:params];
	
	NSString *patrolTime = [params objectForKey:@"patrolTime"];
	NSString *patrolSpeed = [params objectForKey:@"patrolSpeed"];
	
	if( patrolTime ) {
		patrolTime_ = [patrolTime floatValue];
		
		patrolSpeed_ = 2; // default value
		if( patrolSpeed )
			patrolSpeed_ = [patrolSpeed floatValue];
		
		patrolActivated_ = YES;
	}
}
-(BOOL) isOnScreen
{
	
	
	//Don't fire if off screen
	CGPoint pos = [self position];
	//NSLog(@"Enemy x pos %f",pos.x);
	int left, right;
	left = ((game_.currentLayerNumber-1) *512);
	right = ((game_.currentLayerNumber+2) *512);
	
	if(pos.x < right && pos.x > left)
	{
		
		//NSLog(@"3 is on screen");
		return true;
	}
	//NSLog(@"3 is off screen,Left:%d,Right%d,enemey,%f",left,right,pos.x);
	return false;
}
-(void) update:(ccTime)dt
{
	if([self isOnScreen])
	{
		CGPoint topLeft;
		CGPoint bottomRight;
		//
		// move the enemy if "patrol" is activated
		// In this example the enemy is moved using Box2d, and not cocos2d actions.
		//
		//NSLog(@"running update");
		switch (behaveState) {
			case WAITING:
			{
				//NSLog(@"WAITING");
				// **** Chech for top left  ********
				topLeft.x = self.position.x -100;
				topLeft.y = self.position.y +50;
				
				bottomRight.x  = self.position.x;
				bottomRight.y = self.position.y -10;
				if([game_ isHeroInBoxWithTopLeft:topLeft withBottomRight:bottomRight])
				{
					[self changeState:FIRE_UL];
				}
				
				
				// **** Chech for bottom left  ********
				topLeft.x = self.position.x -100;
				topLeft.y = self.position.y -10;
				
				bottomRight.x  = self.position.x;
				bottomRight.y = self.position.y -60;
				if([game_ isHeroInBoxWithTopLeft:topLeft withBottomRight:bottomRight])
				{
					[self changeState:FIRE_BL];
				}
				
				
				// **** Chech for top right  ********
				topLeft.x = self.position.x;
				topLeft.y = self.position.y +50;
				
				bottomRight.x  = self.position.x+100;
				bottomRight.y = self.position.y -10;
				if([game_ isHeroInBoxWithTopLeft:topLeft withBottomRight:bottomRight])
				{
					[self changeState:FIRE_UR];
				}
				
				// **** Chech for bottom right  ********
				topLeft.x = self.position.x;
				topLeft.y = self.position.y -10;
				
				bottomRight.x  = self.position.x+100;
				bottomRight.y = self.position.y -60;
				if([game_ isHeroInBoxWithTopLeft:topLeft withBottomRight:bottomRight])
				{
					[self changeState:FIRE_BR];
				}
				
				
			}
				break;
			case FIRE_UL:
			{
				//NSLog(@"FIRE_UL");
				//[self fireUL];
				struct timeval now;
				gettimeofday( &now, NULL);	
				ccTime dt = (now.tv_sec - lastFire_.tv_sec) + (now.tv_usec - lastFire_.tv_usec) / 1000000.0f;
				
				if( dt > FIRE_FREQUENCY ) {
					//lastFire_ = now;
					[self updateFramesUL];
					
				}
			}
				break;
			case FIRE_BL:
			{
				//NSLog(@"FIRE_BL");
				//[self fireBL];
				struct timeval now;
				gettimeofday( &now, NULL);	
				ccTime dt = (now.tv_sec - lastFire_.tv_sec) + (now.tv_usec - lastFire_.tv_usec) / 1000000.0f;
				
				if( dt > FIRE_FREQUENCY ) {
					//lastFire_ = now;
					[self updateFramesBL];
				}
			}
				break;
			case FIRE_UR:
			{
				//NSLog(@"FIRE_UL");
				//[self fireUL];
				struct timeval now;
				gettimeofday( &now, NULL);	
				ccTime dt = (now.tv_sec - lastFire_.tv_sec) + (now.tv_usec - lastFire_.tv_usec) / 1000000.0f;
				
				if( dt > FIRE_FREQUENCY ) {
					//lastFire_ = now;
					[self updateFramesUR];
					
				}
			}		
				break;
			case FIRE_BR:
			{
				//NSLog(@"FIRE_UL");
				//[self fireUL];
				struct timeval now;
				gettimeofday( &now, NULL);	
				ccTime dt = (now.tv_sec - lastFire_.tv_sec) + (now.tv_usec - lastFire_.tv_usec) / 1000000.0f;
				
				if( dt > FIRE_FREQUENCY ) {
					//lastFire_ = now;
					[self updateFramesBR];
					
				}
			}
				break;
				
				
			default:break;
		}
		
		if( removeMe_ ) {
			[game_ world]->DestroyBody(body_);
			[[self parent] removeChild:self cleanup:YES];
		}
		//NSLog(@"enimy1 calling fire in update");
		//[self fire];
		
		/*   This code is handy for changing states based on hero entering a box
		 topLeft.x = self.position.x -50;
		 topLeft.y = self.position.y +50;
		 
		 bottomRight.x  = self.position.x +50;
		 bottomRight.y = self.position.y -60;
		 if([game_ isHeroInBoxWithTopLeft:topLeft withBottomRight:bottomRight])
		 {
		 [self changeState:RUNLEFT];
		 }
		 */
		//[self changeState: WAITING];
	}
	if(dead)
	{
		
		
		deadFrame+=0.2;
		if(deadFrame>4.0)
		{
			removeMe_ = YES;
			
			[[SimpleAudioEngine sharedEngine] playEffect: @"enemy_killed.wav"];
			[game_ increaseScore:10];
			
		}
		else
		{
			NSString *str = [NSString stringWithFormat:@"enemyeliminated%d.png", (int)deadFrame];
			//NSLog(@"**************************************************************************************Death:%@",str);
			CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];
			
			[self setDisplayFrame:frame];		
		}
		
		
		
		return;
	}
}

-(void) touchedByBullet:(id)bullet
{
	//[self changeState:RUNLEFT];
	if(hitsLeft <= 0)
	{
		dead = true;
		
	}
	else {
		hitsLeft--;
	}
	
	
	//NSLog(@"touched by bullet done");
	
}
-(void) fireUL
{
	
	
	//Don't fire if off screen
	CGPoint pos = [self position];
	//NSLog(@"Enemy x pos %f",pos.x);
	int left, right;
	left = game_.currentLayerNumber *400;
	right = (game_.currentLayerNumber+1) *400;
	//if(pos.x < right && pos.x > left)
	{
		//NSLog(@"enimy1 called fire");
		
		struct timeval now;
		gettimeofday( &now, NULL);	
		//ccTime dt = (now.tv_sec - lastFire_.tv_sec) + (now.tv_usec - lastFire_.tv_usec) / 1000000.0f;
		lastFire_ = now;
		
		
		
		//NSLog(@"Behavior state changed to %@",behaveState);
		
		
		//lastFire_ = now;
		
		//TODO stops enimy from killing itself
		//b2Vec2 offset = [[b2Vec2 alloc] init];
		
		b2Vec2 cLoc = body_->GetPosition();
		cLoc.x -= 0.7;
		//float32 cx;
		//float32 cy;
		//cx = cLoc.x;
		//cy = cLoc.y;
		
		//NSLog(@"Enemy Position X %f,Y %f",cLoc.x,cLoc.y);		
		//cx -= 0.7;
		//cy += 0.0;
		//NSLog(@"firing from X %f,Y %f",cx,cy);
		
		
		//cLoc.y = cy;
		//NSLog(@"firing from X %f,Y %f",cLoc.x,cLoc.y);
		Bullet *bullet = [[Bullet alloc] initWithPosition:cLoc directionX:(-7) directionY:7 game:game_  ownedByEnemy:true];
		[game_ addBodyNode:bullet];
		[bullet release];
		
		[self changeState: WAITING];
		
	}
	//NSLog(@"fire completed");
	
}
-(void) fireBL
{
	
	
	//Don't fire if off screen
	CGPoint pos = [self position];
	//NSLog(@"Enemy x pos %f",pos.x);
	int left, right;
	left = game_.currentLayerNumber *400;
	right = (game_.currentLayerNumber+1) *400;
	//if(pos.x < right && pos.x > left)
	{
		//NSLog(@"enimy1 called fire");
		
		struct timeval now;
		gettimeofday( &now, NULL);	
		//ccTime dt = (now.tv_sec - lastFire_.tv_sec) + (now.tv_usec - lastFire_.tv_usec) / 1000000.0f;
		lastFire_ = now;
		
		
		//NSLog(@"Behavior state changed to %@",behaveState);
		
		
		
		
		//TODO stops enimy from killing itself
		//b2Vec2 offset = [[b2Vec2 alloc] init];
		
		b2Vec2 cLoc = body_->GetPosition();
		cLoc.x -= 0.7;
		//float32 cx;
		//float32 cy;
		//cx = cLoc.x;
		//cy = cLoc.y;
		
		//NSLog(@"Enemy Position X %f,Y %f",cLoc.x,cLoc.y);		
		//cx -= 0.7;
		//cy += 0.0;
		//NSLog(@"firing from X %f,Y %f",cx,cy);
		
		
		//cLoc.y = cy;
		//NSLog(@"firing from X %f,Y %f",cLoc.x,cLoc.y);
		Bullet *bullet = [[Bullet alloc] initWithPosition:cLoc directionX:(-7) directionY:0 game:game_  ownedByEnemy:true];
		[game_ addBodyNode:bullet];
		[bullet release];
		[self changeState: WAITING];
		
	}
	//NSLog(@"fire completed");
	
}
-(void) fireUR
{
	
	
	//Don't fire if off screen
	CGPoint pos = [self position];
	//NSLog(@"Enemy x pos %f",pos.x);
	int left, right;
	left = game_.currentLayerNumber *400;
	right = (game_.currentLayerNumber+1) *400;
	//if(pos.x < right && pos.x > left)
	{
		//NSLog(@"enimy1 called fire");
		struct timeval now;
		gettimeofday( &now, NULL);	
		//ccTime dt = (now.tv_sec - lastFire_.tv_sec) + (now.tv_usec - lastFire_.tv_usec) / 1000000.0f;
		lastFire_ = now;
		
		//if( dt > FIRE_FREQUENCY ) {
		
		
		
		
		//NSLog(@"Behavior state changed to %@",behaveState);
		
		
		//lastFire_ = now;
		
		//TODO stops enimy from killing itself
		//b2Vec2 offset = [[b2Vec2 alloc] init];
		
		b2Vec2 cLoc = body_->GetPosition();
		cLoc.x += 0.7;
		//float32 cx;
		//float32 cy;
		//cx = cLoc.x;
		//cy = cLoc.y;
		
		//NSLog(@"Enemy Position X %f,Y %f",cLoc.x,cLoc.y);		
		//cx -= 0.7;
		//cy += 0.0;
		//NSLog(@"firing from X %f,Y %f",cx,cy);
		
		
		//cLoc.y = cy;
		//NSLog(@"firing from X %f,Y %f",cLoc.x,cLoc.y);
		Bullet *bullet = [[Bullet alloc] initWithPosition:cLoc directionX:(7) directionY:7 game:game_  ownedByEnemy:true];
		[game_ addBodyNode:bullet];
		[bullet release];
		[self changeState: WAITING];
		
	}
	//NSLog(@"fire completed");
	
}
-(void) fireBR
{
	
	
	//Don't fire if off screen
	CGPoint pos = [self position];
	//NSLog(@"Enemy x pos %f",pos.x);
	int left, right;
	left = game_.currentLayerNumber *400;
	right = (game_.currentLayerNumber+1) *400;
	//if(pos.x < right && pos.x > left)
	{
		//NSLog(@"enimy1 called fire");
		struct timeval now;
		gettimeofday( &now, NULL);	
		//	ccTime dt = (now.tv_sec - lastFire_.tv_sec) + (now.tv_usec - lastFire_.tv_usec) / 1000000.0f;
		lastFire_ = now;
		
		//TODO stops enimy from killing itself
		//b2Vec2 offset = [[b2Vec2 alloc] init];
		
		b2Vec2 cLoc = body_->GetPosition();
		cLoc.x += 0.7;
		//float32 cx;
		//float32 cy;
		//cx = cLoc.x;
		//cy = cLoc.y;
		
		//NSLog(@"Enemy Position X %f,Y %f",cLoc.x,cLoc.y);		
		//cx -= 0.7;
		//cy += 0.0;
		//NSLog(@"firing from X %f,Y %f",cx,cy);
		
		
		//cLoc.y = cy;
		//NSLog(@"firing from X %f,Y %f",cLoc.x,cLoc.y);
		Bullet *bullet = [[Bullet alloc] initWithPosition:cLoc directionX:(7) directionY:0 game:game_  ownedByEnemy:true];
		[game_ addBodyNode:bullet];
		[bullet release];
		[self changeState: WAITING];
		
	}
	//NSLog(@"fire completed");
	
}

-(void) updateFramesUL
{
	[self setFlipX:true];
	fireFrames+=.3;
	if(fireFrames >=10)
	{
		fireFrames = 1;
		[self fireUL];
		return;
	}
	
	NSString *str = [NSString stringWithFormat:@"throwenemyfourth0%02d.png", (int)fireFrames];
	//NSLog(@">>%@",str);
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];
	[self setDisplayFrame:frame];
	
}

-(void) updateFramesBL
{
	[self setFlipX:true];
	fireFrames+=.3;
	if(fireFrames >=10)
	{
		fireFrames = 1;
		[self fireUL];
		return;
	}
	
	NSString *str = [NSString stringWithFormat:@"throwenemyfourth0%02d.png", (int)fireFrames];
	//NSLog(@">>%@",str);
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];
	[self setDisplayFrame:frame];
	
}
-(void) updateFramesUR
{
	[self setFlipX:false];
	fireFrames+=.3;
	if(fireFrames >=10)
	{
		fireFrames = 1;
		[self fireUR];
		return;
	}
	
	NSString *str = [NSString stringWithFormat:@"throwenemyfourth0%02d.png", (int)fireFrames];
	//NSLog(@">>%@",str);
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];
	[self setDisplayFrame:frame];
	
}

-(void) updateFramesBR
{
	[self setFlipX:false];
	fireFrames+=.3;
	if(fireFrames >=10)
	{
		fireFrames = 1;
		[self fireBR];
		return;
	}
	
	NSString *str = [NSString stringWithFormat:@"throwenemyfourth0%02d.png", (int)fireFrames];
	//NSLog(@">>%@",str);
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];
	[self setDisplayFrame:frame];
	
}
-(void) changeState:(stateTypes) newState
{
	behaveState = newState;
}
@end