//
//  Box2dDebugDrawNode.h
//  LevelSVG
//
//  Created by Ricardo Quesada on 05/01/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION
//


#import "cocos2d.h"
class b2World;

@interface Box2dDebugDrawNode : CCNode {
	b2World	*world;
}

+(id) nodeWithWorld:(b2World*)world;
-(id) initWithWorld:(b2World*)world;

@end
