//
//  Level0.h
//  LevelSVG
//
//  Created by Ricardo Quesada on 06/01/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION


#import "GameNode.h"
#import "cocos2d.h"


@interface Level1 : GameNode
{
	// SpriteSheets weak ref
	CCSpriteSheet	*spriteSheet_;
	CCSpriteSheet	*platformSheet_;
	CCSpriteSheet	*spriteSheet1_;
	CCSpriteSheet	*spriteSheet2_;
	CCSpriteSheet	*spriteSheet3_;

}

@end