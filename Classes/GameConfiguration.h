//
//  GameConfiguration.h
//  LevelSVG
//
//  Created by Ricardo Quesada on 13/10/09.
//  Copyright 2009 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION
//


#import <Foundation/Foundation.h>

typedef enum
{
	kControlTypePad,
	kControlTypeTilt,
	
	kControlTypeDefault = kControlTypeTilt,

} ControlType;

typedef enum
{
	kControlButton0,
	kControlButton1,
	kControlButton2,
	
	kControlButtonDefault = kControlButton1,
} ControlButton;

typedef enum {
	kControlDirection2Way,
	kControlDirection4Way,	
	
	kControlDirectionDefault = kControlDirection4Way,
} ControlDirection;

@interface GameConfiguration : NSObject
{
	ControlType			controlType_;
	ControlDirection	controlDirection_;
	ControlButton		controlButton_;
	CGPoint				gravity_;
};

@property (nonatomic,readwrite)	ControlType			controlType;
@property (nonatomic,readwrite)	ControlDirection	controlDirection;
@property (nonatomic,readwrite)	ControlButton		controlButton;
@property (nonatomic,readwrite) CGPoint				gravity;

// returns the singleton
+(id) sharedConfiguration;

@end