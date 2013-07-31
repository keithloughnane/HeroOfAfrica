// FLYING ENEMY

//
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
#import "Enemy7.h"
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

@implementation Enemy7

-(id) initWithBody:(b2Body*)body game:(GameNode*)game
{
	//NSLog(@"Initing enemy 2");
	initiated = false;
	behaveState = PATROLLEFT;
	if( (self=[super initWithBody:body game:game]) ) {
		hitsLeft = lives;
		dead = false;
		deadFrame = 1;
		//NSLog(@"setting enemy1 image");
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walkingenemyfirst001.png"];
		[self setDisplayFrame:frame];
		
		// bodyNode properties
		reportContacts_ = BN_CONTACT_NONE;
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
		
		[self schedule:@selector(update:)];
	}
	originalY = -1;
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

-(void) update:(ccTime)dt
{
	if([self isOnScreen])
	{
		
		if(!initiated)
		{
			//originalY = self.position.y;
			originalY = body_->GetPosition().y;
			initiated = true;
		}
		//CGPoint temp;
		//temp.y = originalY;
		//temp.x = self.position.x;
		//[self setPosition:temp];
		
		CGPoint topLeft;
		CGPoint bottomRight;
		//
		// move the enemy if "patrol" is activated
		// In this example the enemy is moved using Box2d, and not cocos2d actions.
		//
		//NSLog(@"running update");
		switch (behaveState) {
			case PATROLLEFT:
			{
				
				body_->SetLinearVelocity( b2Vec2(-patrolSpeed_,-.5) );
				
				topLeft.x = self.position.x -50;
				topLeft.y = self.position.y;
				
				bottomRight.x  = self.position.x +50;
				bottomRight.y = self.position.y -240;
				if([game_ isHeroInBoxWithTopLeft:topLeft withBottomRight:bottomRight])
				{
					[self changeState:FIRING];
				}
				
				
				if( patrolActivated_ ) {
					patrolDT_ += dt;
					if( patrolDT_ >= patrolTime_ ) {
						patrolDT_ = 0;
						
						[self changeState: PATROLRIGHT];
					}
				}
				
			}
				break;
			case PATROLRIGHT:
			{
				
				body_->SetLinearVelocity( b2Vec2(patrolSpeed_,-.5) );
				
				topLeft.x = self.position.x -50;
				topLeft.y = self.position.y;
				
				bottomRight.x  = self.position.x +50;
				bottomRight.y = self.position.y -240;
				if([game_ isHeroInBoxWithTopLeft:topLeft withBottomRight:bottomRight])
				{
					[self changeState:FIRING];
				}
				//NSLog(@"patrolright");
				if( patrolActivated_ ) {
					patrolDT_ += dt;
					if( patrolDT_ >= patrolTime_ ) {
						patrolDT_ = 0;
						
						[self changeState: PATROLLEFT];
					}
					
				}
				/*
				 if( removeMe_ ) {
				 [game_ world]->DestroyBody(body_);
				 [[self parent] removeChild:self cleanup:YES];
				 }
				 */
			}
				
				break;
			case FIRING:
			{
				[self fire];
				
				if (patrolDirectionLeft_) {
					[self changeState:PATROLLEFT];
				}
				else {
					[self changeState:PATROLRIGHT];
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
		//TODO Clean up
		//CGPoint temp;
		
		//temp.y = originalY;
		//temp.x = self.position.x;
		//[self setPosition:temp];
		
		b2Vec2 tv =  body_->GetPosition();
		tv.y = originalY;
		//tv.x = temp.x;
		
		body_->SetTransform(tv,0);
		
		//SetTransform(const b2Vec2& position, float32 angle);
		
		
		//body_.position.m_xf.position.x = 10;
		
		//NSLog(@"Enemy 2 position X:%f Y:%f   body_ X:%f  Y%f",self.position.x,self.position.y,body_->GetPosition().x,body_->GetPosition().y);
		//body_.position.y
	}
	[self updateFrames];
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
		
		//NSLog(@"2 is on screen");
		return true;
	}
	//NSLog(@"2 is off screen,Left:%d,Right%d,enemey,%f",left,right,pos.x);
	return false;
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
-(void) fire
{
	/* ***********This code moved to own method so entire update can be skiped
	 
	 //Don't fire if off screen
	 CGPoint pos = [self position];
	 //NSLog(@"Enemy x pos %f",pos.x);
	 int left, right;
	 left = game_.currentLayerNumber *400;
	 right = (game_.currentLayerNumber+1) *400;
	 if(pos.x < right && pos.x > left)
	 {
	 
	 ***************** */
	
	if([self isOnScreen])
	{
		
		//NSLog(@"enimy1 called fire");
		struct timeval now;
		gettimeofday( &now, NULL);	
		ccTime dt = (now.tv_sec - lastFire_.tv_sec) + (now.tv_usec - lastFire_.tv_usec) / 1000000.0f;
		
		if( dt > FIRE_FREQUENCY ) {
			//NSLog(@"##################make it through dt > firefreq####################");
			//[self changeState:PATROLLEFT];
			
			
			//NSLog(@"Behavior state changed to %@",behaveState);
			
			
			lastFire_ = now;
			
			//TODO stops enimy from killing itself
			//b2Vec2 offset = [[b2Vec2 alloc] init];
			
			b2Vec2 cLoc = body_->GetPosition();
			
			cLoc.y -= 1.0;
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
			Bullet *bullet = [[Bullet alloc] initWithPosition:cLoc directionX:(0) directionY:-2 game:game_  ownedByEnemy:true];
			[game_ addBodyNode:bullet];
			[bullet release];
			
		}
	}
	
}
-(void) touchedByHero
{
	//NSLog(@"Enemy-Hero Collition HeroX:%d Y:%d EnemyX:%d Y:%d",Hero.position_.x,Hero.position_.y,self.position.x,self.position.y);
	[[SimpleAudioEngine sharedEngine] playEffect:@"you_are_hit.wav"];
	[game_ increaseLife:-20];
}
-(void) changeState:(stateTypes) newState
{
	behaveState = newState;
	//NSLog(@"changed state %@",behaveState);
	
	
	//patrolDirectionLeft_ = ! patrolDirectionLeft_;
	
	switch (newState) {
		case PATROLLEFT:
		{
			//NSLog(@"State: Patrolleft");
			
			body_->SetAngularVelocity(0);
			
			patrolDirectionLeft_ = true;
			/*
			NSString *str = [NSString stringWithFormat:@"sprite_hero_01.png"];
			CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];
			[self setDisplayFrame:frame];*/
			
		}
			break;
			
		case PATROLRIGHT:
		{
			//NSLog(@"State: Patrolright");
			body_->SetAngularVelocity(0);
			
			patrolDirectionLeft_ = false;
			
			/*
			NSString *str = [NSString stringWithFormat:@"sprite_hero_01.png"];
			CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];
			[self setDisplayFrame:frame];*/
		}	
			break;
			
		case FIRING:
		{
			//NSLog(@"State: firing");
		}
			
		default:
			break;
			
	}
	
	//NSLog(@"change state done");
	
	
}

-(void) updateFrames
{
	
	
	//Copy me
	
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
	/*
	 // rect is the texture rect of the sprite
	 CGRect r = rect_;
	 
	 if( force.x == 0 )
	 return;
	 */
	//const char *dir = "left";
	
	//if( force.x > 0 )
	// dir = "right";
	
	
	// There are 8 frames
	// And every 20 pixels a new frame should be displayed
	unsigned int x = (((unsigned int)position_.x /10) % 15)+1;
	
	// increase frame index, since frame names go from 1 to 8 and not from 0 to 7.
	
	// x++;
	//flyenemyfirst001.png

	
	NSString *str = [NSString stringWithFormat:@"flyenemysecond00%02d.png", x];
	//NSLog(@"flaying from >> %@",str);
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];
	[self setDisplayFrame:frame];
}
@end