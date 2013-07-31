//
//  Enemy.h
//  LevelSVG
//
//  Created by Ricardo Quesada on 03/01/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION


#import "BadGuy.h"
typedef enum stateTypes
{
	PATROLLEFT,
	PATROLRIGHT,
	FIRING
} State;

@interface Enemy2 : BadGuy <BodyNodeBulletProtocol> {
	
	BOOL	removeMe_;
	bool dead;
	float deadFrame;
	BOOL	initiated;
	BOOL	patrolActivated_;
	BOOL	patrolDirectionLeft_;
	float	patrolTime_;
	float	patrolSpeed_;
	int		hitsLeft;
	float		originalY;
	struct timeval	lastFire_;
	stateTypes behaveState;
	ccTime	patrolDT_;
}

-(void) fire;
-(void) changeState:(stateTypes) newState;
-(void) updateFrames;
-(BOOL) isOnScreen;
@end