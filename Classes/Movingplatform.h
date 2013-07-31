//
//  Movingplatform.h
//  LevelSVG
//
//  Created by Ricardo Quesada on 05/01/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION


#import "KinematicNode.h"


enum{
	kPlatformDirectionHorizontal,
	kPlatformDirectionVertical,
};

@interface Movingplatform : KinematicNode {

	int direction;
}

-(CCAction*) getAction;
@end
