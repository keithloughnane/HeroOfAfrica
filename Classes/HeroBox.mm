//
//  HeroBox.mm
//  LevelSVG
//
//  Created by Ricardo Quesada on 12/02/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION


#import "SimpleAudioEngine.h"

#import "Herobox.h"
#import "GameConfiguration.h"
#import "GameConstants.h"
#import "GameNode.h"
#import "Bullet.h"


#define THROWFORCE_X 7;
#define THROWFORCE_Y_LOOKINGUP 7;
#define THROWFORCE_Y 5;

#define SPRITE_WIDTH 20
#define SPRITE_HEIGHT 44

// Forces & Impulses
#define	JUMP_IMPULSE (3.0f)
#define MOVE_FORCE (5.0f)

#define FIRE_FREQUENCY (0.2f)

//
// Hero: The main character of the game.
//
@implementation Herobox

-(id) initWithBody:(b2Body*)body game:(GameNode*)aGame
{
	//NSLog(@"Initing hero");
	if( (self=[super initWithBody:body game:aGame] ) ) {
		jumpingFrame = 0;
		//
		// Set up the right texture
		//
		
		// Set the default frame
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"running002.png"];
		[self setDisplayFrame:frame];
		
		
		preferredParent_ = BN_PREFERRED_PARENT_SPRITES1_PNG;
		
		//
		// box2d stuff: Create the "correct" fixture
		//
		// 1. destroy already created fixtures
		[self destroyAllFixturesFromBody:body];
		
		// 2. create new fixture
		b2FixtureDef	fd;
		
		b2PolygonShape shape;
		
		// Sprite size is SPRITE_WIDTH x SPRITE_HEIGHT
		float height = (SPRITE_HEIGHT / kPhysicsPTMRatio) / 2;
		float width = (SPRITE_WIDTH/ kPhysicsPTMRatio) / 2;
		
		// vertices should be in Counter Clock-Wise order, orderwise it will crash
		b2Vec2 vertices[4];
		vertices[0].Set(-width,-height);	// bottom-left
		vertices[1].Set(width,-height);		// bottom-right
		vertices[2].Set(width,height);		// top-right
		vertices[3].Set(-width,height);		// top-left
		shape.Set(vertices, 4);
		
		// TIP: friction should be 0 to avoid sticking into walls
		fd.friction		= 0.0f;
		fd.density		= 1.0f;
		fd.restitution	= 0.0f;
		
		
		// TIP: fixed rotation. The hero can't rotate. Very useful for Super Mario like games
		body->SetFixedRotation(true);
		
		fd.shape = &shape;
		
		// Collision filtering between Hero and Bullet
		// If the groupIndex is negative, then the fixtures NEVER collide.
		fd.filter.groupIndex = kCollisionFilterGroupIndexHero;
		
		body->CreateFixture(&fd);
		body->SetType(b2_dynamicBody);
		
		//
		// Setup physics forces & impulses
		//
		jumpImpulse = JUMP_IMPULSE;
		moveForce = MOVE_FORCE;
		
		
		// Setup custom HeroBox ivars
		facingRight_ = YES;
		facingUp_ = NO;
		throwingFrame= 1.0;
		throwing = false;
		gettimeofday( &lastFire_, NULL);	
		//NSLog(@"Hero init done");
	}
	return self;
}

#pragma mark HeroBox - Movements

-(void) move:(CGPoint)direction
{
	
	//
	// TIP:
	// HeroRound uses ApplyForce to move the hero.
	// HeroBox uses SetLinearVelocity (simpler to code, and probably more realistic)
	//
	
	// HeroBox is optimized for platform games, so it can only move right/left
	
	
	float xVel = moveForce *direction.x;
	
	
	b2Vec2 velocity = body_->GetLinearVelocity();
	
	//NSLog(@"Hero y velocity = %f",velocity.y);

	
	if(jumping_)
	{

	
	
	
	if(!(velocity.y < 0.001 && velocity.y> -0.001))
	{
		//if(jumping_)
		{
			velocity.x += xVel/30;
			
			if(velocity.x > xVel && velocity.x>0)
			{
				velocity.x = xVel;
			}
			else if(velocity.x < xVel && velocity.x<0)
			{
				velocity.x = xVel;
			}
		}
	}
	}
	else {
		velocity.x = xVel;
	}
	
	
	
	
	body_->SetLinearVelocity( velocity );
	
	
	
	// needed for bullets. Don't update if x==0
	if( xVel != 0 )
		facingRight_ = (xVel > 0);
	
	[self updateFrames:direction];
	b2Vec2 p = body_->GetPosition();
	
	//NSLog(@"Hero at X:%f,Y:%f",p.x,p.y);
	//[game_ initSwitchLayers:map
	[game_ switchLayers:(p.x/12.65)];
	
	//[game_ jumpMode:1];
	
}

-(void) fire
{
	//throwing = true;
	struct timeval now;
	gettimeofday( &now, NULL);	
	ccTime dt = (now.tv_sec - lastFire_.tv_sec) + (now.tv_usec - lastFire_.tv_usec) / 1000000.0f;
	
	if( dt > FIRE_FREQUENCY ) {
		if (game_.ammo>0) {
			
			[game_ increaseAmmo:-1];
			lastFire_ = now;
			
			b2Vec2 cLoc = body_->GetPosition();
			cLoc.y+=0.5;
			
			Bullet *bullet;
			if(!facingUp_)
			{
				if(facingRight_)
				{
					cLoc.x += 0.7;		
					bullet = [[Bullet alloc] initWithPosition:cLoc directionX:(facingRight_ ? 20 : -20) directionY:3 game:game_ ownedByEnemy:false];
				}
				else if(!facingRight_)
				{
					cLoc.x -= 0.7;		
					bullet = [[Bullet alloc] initWithPosition:cLoc directionX:(facingRight_ ? 20 : -20) directionY:3 game:game_  ownedByEnemy:false];
				}
			}
			else {
				if(facingRight_)
				{
					cLoc.x += 1.0;		
					bullet = [[Bullet alloc] initWithPosition:cLoc directionX:(facingRight_ ? 10 : -10) directionY:11 game:game_  ownedByEnemy:false];
				}
				else if(!facingRight_)
				{
					cLoc.x -= 1.0;		
					bullet = [[Bullet alloc] initWithPosition:cLoc directionX:(facingRight_ ? 10 : -10) directionY:11 game:game_  ownedByEnemy:false];
				}
			}
			[game_ addBodyNode:bullet];
			[bullet release];
		}
	}
	
	//[super switchLayers:tiled];
}

-(void) superJump
{
	//BOOL touchingGround = NO;
	
	float impulseYFactor = 1;
	
	/*
	 if( contactPointCount > 0 ) {
	 
	 int foundContacts=0;
	 
	 //
	 // TIP:
	 // only take into account the normals that have a Y component greater that 0.3
	 // You might want to customize this value for your game.
	 //
	 // Explanation:
	 // If the hero is on top of 100% horizontal platform, then Y==1
	 // If it is on top of platform rotate 45 degrees, then Y==0.5
	 // If it is touching a wall Y==0
	 // If it is touching a ceiling then, Y== -1
	 //
	 
	 for( int i=0; i<kMaxContactPoints && foundContacts < contactPointCount;i++ ) {
	 ContactPoint* point = contactPoints + i;
	 if( point->otherFixture ) {
	 foundContacts++;
	 
	 //
	 // Use the greater Y normal
	 //
	 if( point->normal.y > 0.3f) {
	 touchingGround = YES;
	 */
	jumping_ = YES;
	
	b2Vec2 p = body_->GetWorldPoint(b2Vec2(0.0f, 0.0f));
	
	//
	// It's possible that while touching ground, the Hero already started to jump
	// so, the 2nd time, the impulse should be lower
	//		
	
	//	b2Vec2 vel = body_->GetLinearVelocity();
	//	if( vel.y > 0 )
	//	impulseYFactor = vel.y / 40;
	
	
	//
	// TIP:
	// The impulse always is "up". To simulate a more realistic
	// jump, see HeroRound.mm, since it uses the normal, but it this realism is not
	// needed in Mario-like games
	//
	
	//High jump
	body_->ApplyLinearImpulse( b2Vec2(0, (jumpImpulse * impulseYFactor)*0), p );
	//[game_ jumpMode:1];
	
	/*					
	 //
	 // TIP:
	 // Another way (less realistic) to simulate a jump, is by
	 // using SetLinearVelocity()
	 // eg:
	 //
	 //		b2Vec2 vel = body_->GetLinearVelocity();
	 //		body_->SetLinearVelocity( b2Vec2(vel.x, 6) );

	 
	 if( ! touchingGround ) {
	 
	 //
	 // TIP:
	 // Reduce the impulse if the jump button is still pressed, and the Hero is in the air
	 //		
	 b2Vec2 vel = body_->GetLinearVelocity();
	 
	 // going up ? so apply little impulses
	 if( vel.y > 0 ) {
	 b2Vec2 p = body_->GetWorldPoint(b2Vec2(0.0f, 0.0f));
	 
	 // 160 is just a constant to get the impulse a N times lower
	 float impY = jumpImpulse * vel.y/160;
	 body_->ApplyLinearImpulse( b2Vec2(0,impY), p);
	 }
	 }*/
}
-(void) jump
{
	BOOL touchingGround = NO;
	
	jumping_ = NO;
	
	if( contactPointCount > 0 ) {
		
		int foundContacts=0;
		
		
		//
		// TIP:
		// only take into account the normals that have a Y component greater that 0.3
		// You might want to customize this value for your game.
		//
		// Explanation:
		// If the hero is on top of 100% horizontal platform, then Y==1
		// If it is on top of platform rotate 45 degrees, then Y==0.5
		// If it is touching a wall Y==0
		// If it is touching a ceiling then, Y== -1
		//
		
		for( int i=0; i<kMaxContactPoints && foundContacts < contactPointCount;i++ ) {
			ContactPoint* point = contactPoints + i;
			if( point->otherFixture ) {
				foundContacts++;
				
				//
				// Use the greater Y normal
				//
				if( point->normal.y > 0.3f) {
					touchingGround = YES;
					jumping_ = NO;
					
					b2Vec2 p = body_->GetWorldPoint(b2Vec2(0.0f, 0.0f));
					
					//
					// It's possible that while touching ground, the Hero already started to jump
					// so, the 2nd time, the impulse should be lower
					//					
					float impulseYFactor = 1;
					b2Vec2 vel = body_->GetLinearVelocity();
					if( vel.y > 0 )
						impulseYFactor = vel.y / 40;
					
					
					//
					// TIP:
					// The impulse always is "up". To simulate a more realistic
					// jump, see HeroRound.mm, since it uses the normal, but it this realism is not
					// needed in Mario-like games
					//
					
					
					//Normal jump
					body_->ApplyLinearImpulse( b2Vec2(0, jumpImpulse * impulseYFactor), p );
					
					
					
					
					//
					// TIP:
					// Another way (less realistic) to simulate a jump, is by
					// using SetLinearVelocity()
					// eg:
					//
					//		b2Vec2 vel = body_->GetLinearVelocity();
					//		body_->SetLinearVelocity( b2Vec2(vel.x, 6) );
					
					
					break;
				}
			}
		}
		
	}
	
	if( ! touchingGround ) {
		
		jumping_ = YES;
		//
		// TIP:
		// Reduce the impulse if the jump button is still pressed, and the Hero is in the air
		//		
		b2Vec2 vel = body_->GetLinearVelocity();
		
		// going up ? so apply little impulses
		if( vel.y > 0 ) {
			b2Vec2 p = body_->GetWorldPoint(b2Vec2(0.0f, 0.0f));
			
			// 160 is just a constant to get the impulse a N times lower
			float impY = jumpImpulse * vel.y/160;
			body_->ApplyLinearImpulse( b2Vec2(0,impY), p);
		}
	}
	else {
		//jumping_=NO;
		//NSLog(@"Not jumping");
	}
	
}

-(void) updateFrames:(CGPoint)force
{
	if(dead)
	{
		
		
		deadFrame+=0.2;
		if(deadFrame>4.0)
		{
			[game_ death];

		}
		else
		{
			NSString *str = [NSString stringWithFormat:@"heroeliminated%d.png", (int)deadFrame];
			//NSLog(@"**************************************************************************************Death:%@",str);
			CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];
			
			[self setDisplayFrame:frame];		
		}
		
		
		
		return;
	}

	if( force.x > 0 )
	{
		[self setFlipX:false];
		
	}
	else if (force.x < 0)
	{
		[self setFlipX:true];
	}

	
	
	
	// rect is the texture rect of the sprite
	CGRect r = rect_;

	if(throwing&&!facingUp_)
	{
		throwingFrame+=0.4;
		if(throwingFrame>10)
		{
			[self fire];
			throwingFrame = 1;
			throwing = false;
		}
		else
		{
		NSString *str = [NSString stringWithFormat:@"throw0%02d.png", (int)throwingFrame];
		//NSLog(@"THROWING:%@",str);
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];
		
		[self setDisplayFrame:frame];		
		}
		return;
		
	}
	
	if(throwing&&facingUp_)
	{
		throwingFrame+=0.4;
		if(throwingFrame>14)
		{
			[self fire];
			throwingFrame = 1;
			throwing = false;
		}
		else
		{
			NSString *str = [NSString stringWithFormat:@"throwabove0%02d.png", (int)throwingFrame];
			//NSLog(@"THROWING:%@",str);
			CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];
			
			[self setDisplayFrame:frame];		
		}
		return;
		
	}
	
	if( jumping_)  //jumping
	{
		/*if(force.y>0.0)//On the way up
		 {*/
		
		//unsigned int y = ((unsigned int)position_.y /10) % 20;
		jumpingFrame+=.30;
		if(jumpingFrame>20)
			jumpingFrame= 20;
		
		NSString *str = [NSString stringWithFormat:@"jumping0%02d.png", (int)jumpingFrame];
		//NSLog(@"JUMPING:%@",str);
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];

		[self setDisplayFrame:frame];

		return;
		
		
		/* }
		 else {

		 unsigned int y = ((unsigned int)position_.y /10) % 10;
		 y*=-1;
		 y+=10;
		 if(y>20)
		 y= 20;
		 
		 NSString *str = [NSString stringWithFormat:@"jumping0%02d.png", y];
		 NSLog(@"JUMPING:%@",str);
		 CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];
		 [self setDisplayFrame:frame];
		 
		 return;
		 }*/
		
	}
	else {  //Not jumping
		
		jumpingFrame= 1;
		
		//const char *dir = "left";
		
		/*if( force.x > 0 )
		 dir = "right";*/
		
		// There are 8 frames
		// And every 20 pixels a new frame should be displayed
		unsigned int x = ((unsigned int)position_.x /20) % 14;
		
		
		if( force.x == 0 )   //Standing
		{
			NSString *str = [NSString stringWithFormat:@"startrunning002.png"];
			//NSLog(@"calling frame %@",str);
			CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];
			[self setDisplayFrame:frame];
		/*	if( force.x > 0 )
			{
				[self setFlipX:false];
			}
			else {
				[self setFlipX:true];
			}*/
			return;
			
		}
		
		else {      //Running

		// increase frame index, since frame names go from 1 to 8 and not from 0 to 7.
		x++;
		//walk-left_02.png
		//running014.png
		NSString *str = [NSString stringWithFormat:@"running0%02d.png", x];
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];
		[self setDisplayFrame:frame];
			
		}

	}
	/*
	if( force.x > 0 )
	 {
	 [self setFlipX:false];
	 }
	 else {
	 [self setFlipX:true];
	 }
*/
	
	//NSLog(@"calling frame %@",str);

	
}
-(void) touchedByBullet:(id)bullet
{
	//if(hitsLeft <= 0)
	//{
	//removeMe_ = YES;
	
	//NSLog(@"Hero hit by bullet %d",[bullet isOwnedByEnemy]);
	
	if([bullet isOwnedByEnemy])
	{
		[[SimpleAudioEngine sharedEngine] playEffect:@"you_are_hit.wav"];
		[game_ increaseLife:-20];
		if(game_.lives == 0)
		{//NSLog(@"***************************Hero dead*************************");
			dead = true;}
		
	}
	
	//}
	/*else {
	 hitsLeft--;
	 }*/
	
	
}
@end
