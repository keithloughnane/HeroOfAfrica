//
//  Bullet.h
//  LevelSVG
//
//  Created by Ricardo Quesada on 05/05/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION


#import <Box2D/Box2D.h>
#import "BodyNode.h"


@interface Bullet : BodyNode {

	ccTime	elapsedTime_;
	BOOL	removeMe_;
	b2World	*world_;	// weak reference
	BOOL	ownedByEnemy_;
	
		
}
@property (readwrite,nonatomic) BOOL ownedByEnemy;

-(bool) isOwnedByEnemy;
// postion of the bullet
// direction: -1 is left, 1 is right
-(id) initWithPosition:(b2Vec2)position directionX:(int)direction directionY:(int)directionY game:(GameNode*)game  ownedByEnemy:(BOOL)ownedByEnemy;

@end
