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
	WAITING,
	FIRE_UL, FIRE_BL, FIRE_UR, FIRE_BR
	
} State;

@interface Enemy6 : BadGuy <BodyNodeBulletProtocol> {
	
	BOOL	removeMe_;
	BOOL	patrolActivated_;
	bool dead;
	float deadFrame;
	BOOL	patrolDirectionLeft_;
	float	patrolTime_;
	float	patrolSpeed_;
	int		hitsLeft;
	float		fireFrames;
	struct timeval	lastFire_;
	stateTypes behaveState;
	ccTime	patrolDT_;
}
-(void) updateFramesUL;
-(void) fireUL;
-(void) updateFramesBL;
-(void) fireBL;
-(void) updateFramesUR;
-(void) fireUR;
-(void) updateFramesBR;
-(void) fireBR;
-(void) changeState:(stateTypes) newState;
//-(void) updateFrames;
-(BOOL) isOnScreen;
@end