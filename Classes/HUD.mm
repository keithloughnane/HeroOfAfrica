//
//  HUD.m
//  LevelSVG
//
//  Created by Ricardo Quesada on 16/10/09.
//  Copyright 2009 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION
//

//
// HUD: Head Up Display
//
// - Display score
// - Display lives
// - Display joystick, but it is not responsible for reading it
// - Display the menu button
// - Register a touch events: drags the screen
//

#import "HUD.h"
#import "GameConfiguration.h"
#import "Joystick.h"
#import "GameNode.h"
#import "MenuScene.h"
#import "AboutScene.h"
#import "Level2.h"
#import "Hero.h"

@implementation HUD
//CCBitmapFontAtlas *msgLabel;
int MsgTime;
int oldTime;
+(id) HUDWithGameNode:(GameNode*)game
{
	return [[[self alloc] initWithGameNode:game] autorelease];
}
-(id) initWithGameNode:(GameNode*)aGame
{
	if( (self=[super init])) {
		oldTime = 0;		
		self.isTouchEnabled = YES;
		game = aGame;
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		
		// level control configuration:
		//  - 2-way or 4-way ?
		//  - d-pad or accelerometer ?
		//  - 0, 1 or 2 buttons ?
		
		GameConfiguration *config = [GameConfiguration sharedConfiguration];
		ControlType control = [config controlType];
		ControlButton button = [config controlButton];
		
		joystick = [Joystick joystick];
		[self addChild:joystick];
		
		switch (button) {
			case kControlButton0:
				[joystick setButton:BUTTON_A enabled:NO];
			case kControlButton1:
				[joystick setButton:BUTTON_B enabled:NO];
				break;
			case kControlButton2:
				// both buttons are enabled by default, no need to modify it
				break;
		}
		
		// The Hero is responsible for reading the joystick
		[[game hero] setJoystick:joystick];		
		
		// enable button left/right only if using "Pad" controls
		
		[joystick setPadEnabled: NO];
		// pad + 4 direction is not implemented yet
		if( control==kControlTypePad) {
			
			[joystick setPadEnabled: YES];
			[joystick setPadPosition:ccp(74,74)];
		}
		
		CCColorLayer *color = [CCColorLayer layerWithColor:ccc4(32,32,32,128) width:s.width height:40];
		[color setPosition:ccp(0,s.height-40)];
		[self addChild:color z:0];
		//[menu setPosition:ccp(20,s.height-20)];
		
		// Menu Button
		CCMenuItem *itemPause = [CCMenuItemImage itemFromNormalImage:@"btn-pause-normal.png" selectedImage:@"btn-pause-selected.png" target:self selector:@selector(buttonRestart:)];
		CCMenu *menu = [CCMenu menuWithItems:itemPause,nil];
		[self addChild:menu z:1];
		[menu setPosition:ccp(20,s.height-20)];
		
		
		
		//lifeBar = [CCColorLayer layerWithColor:ccc4(100,100,100,100) width:100 height:100];
		//[lifeBar setPosition:ccp(100,100)];
		
		CCColorLayer *lifeBarBG = [CCColorLayer layerWithColor:ccc4(255,0,0,100) width:102 height:22];
		[lifeBarBG setPosition:ccp(480-101,289)];
		[self addChild:lifeBarBG z:1];
		
		lifeBar = [CCColorLayer layerWithColor:ccc4(0,255,0,255) width:100 height:20];
		[lifeBar setPosition:ccp(480-100,290)];
		[self addChild:lifeBar z:2];
		
		
		//Message Label
		screenMsg = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"Message" fntFile:@"gas32.fnt"];
		[screenMsg.texture setAliasTexParameters];
		[self addChild:screenMsg z:1];
		[screenMsg setPosition:ccp(250, 150)];
		
		
		
		
		
		// Score Label
		CCBitmapFontAtlas *scoreLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"SCORE:" fntFile:@"gas32.fnt"];
		[scoreLabel.texture setAliasTexParameters];
		[self addChild:scoreLabel z:1];
		[scoreLabel setPosition:ccp(s.width/2+0.5f-45, s.height-20.5f)];
		
		// Score Points
		score = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"000" fntFile:@"gas32.fnt"];
		//		[score.texture setAliasTexParameters];
		[self addChild:score z:1];
		[score setPosition:ccp(s.width/2+0.5f+25, s.height-20.5f)];
		
		
		
		CCBitmapFontAtlas *timeLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"TIME:" fntFile:@"gas32.fnt"];
		[timeLabel.texture setAliasTexParameters];
		[self addChild:timeLabel z:1];
		[timeLabel setPosition:ccp(380, 20)];
		
		// Score Points
		time = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"0" fntFile:@"gas32.fnt"];
		//		[score.texture setAliasTexParameters];
		[self addChild:time z:1];
		[time setPosition:ccp(440, 20)];
		
		
		
		
		// Lives label
		CCBitmapFontAtlas *livesLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"APPLES:" fntFile:@"gas32.fnt"];
		[lives.texture setAliasTexParameters];
		[self addChild:livesLabel z:1];
		//[livesLabel setAnchorPoint:ccp(100,0.5f)];
		[livesLabel setPosition:ccp(60, 20)];		
		
		lives = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"3" fntFile:@"gas32.fnt"];
		[lives.texture setAliasTexParameters];
		[self addChild:lives z:1];
		//[lives setAnchorPoint:ccp(1,0.5f)];
		[lives setPosition:ccp(140, 20)];		
		
		[self onUpdateMsg:@" "];
		
	}
	
	return self;
}
-(void) onUpdateTime:(int)newTime
{
	//NSLog(@"HUD TIME UPDATED oldtime %d, newTime %d",oldTime,newTime);
	if(!(oldTime == newTime))
	{
		//TODO Optimise
		[time setString: [NSString stringWithFormat:@"%03d", newTime]];
		[time stopAllActions];
		id scaleTo = [CCScaleTo actionWithDuration:0.1f scale:1.2f];
		id scaleBack = [CCScaleTo actionWithDuration:0.1f scale:1];
		id seq = [CCSequence actions:scaleTo, scaleBack, nil];
		[time runAction:seq];
		//NSLog(@"MesgTime %d",MsgTime);
		if(MsgTime > 0)
		{
			MsgTime --;
		}
		else if(MsgTime == 0)
		{
			[self onUpdateMsg:@""];
		}
		
		oldTime = newTime;
	}
}
-(void) onUpdateMsg:(NSString*)newMsg
{
	
	 MsgTime = 3;
	//NSLog(@"HUD MSG SEtting string %@",newMsg);
	[screenMsg setString:[NSString stringWithFormat:@"%@",newMsg]];
	[screenMsg stopAllActions];
	id scaleTo = [CCScaleTo actionWithDuration:0.1f scale:1.2f];
	id scaleBack = [CCScaleTo actionWithDuration:0.1f scale:1];
	id seq = [CCSequence actions:scaleTo, scaleBack, nil];
	[time runAction:seq];
}
-(void) onUpdateScore:(int)newScore
{
	[score setString: [NSString stringWithFormat:@"%03d", newScore]];
	[score stopAllActions];
	id scaleTo = [CCScaleTo actionWithDuration:0.1f scale:1.2f];
	id scaleBack = [CCScaleTo actionWithDuration:0.1f scale:1];
	id seq = [CCSequence actions:scaleTo, scaleBack, nil];
	[score runAction:seq];
}
-(void) onUpdateAmmo:(int)newAmmo
{
	[lives setString: [NSString stringWithFormat:@"%d", newAmmo]];
	[lives runAction:[CCBlink actionWithDuration:0.5f blinks:5]];
	//NSLog(@"Ammo increased to %d",newAmmo);
}


-(void) onUpdateLives:(int)newLives
{
	//[lives setString: [NSString stringWithFormat:@"%d", newLives]];
	//[lives runAction:[CCBlink actionWithDuration:0.5f blinks:5]];
	
	//[self removeChild:itemPause cleanup:YES];
	//CCNode* tempNode = [CCNode alloc];
	
	
	
	//[self addChild:menu z:1];
	//[menu setPosition:ccp(newLives*10,20)];
	
	[self removeChild:lifeBar cleanup:YES];
	lifeBar = [CCColorLayer layerWithColor:ccc4(0,255,0,255) width:newLives height:20];
	[lifeBar setPosition:ccp(480-100,290)];
	[self addChild:lifeBar z:2];
}

-(void) displayMessage:(NSString*)message
{
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	CCLabel *label = [CCLabel labelWithString:message fontName:@"Marker Felt" fontSize:54];
	[self addChild:label];
	[label setPosition:ccp(s.width/2, s.height/2)];
	
	id sleep = [CCDelayTime actionWithDuration:3];
	id rot1 = [CCRotateBy actionWithDuration:0.025f angle:5];
	id rot2 = [CCRotateBy actionWithDuration:0.05f angle:-10];
	id rot3 = [rot2 reverse];
	id rot4 = [rot1 reverse];
	id seq = [CCSequence actions:rot1, rot2, rot3, rot4, nil];
	id repeat_rot = [CCRepeat actionWithAction:seq times:3];
	
	id big_seq = [CCSequence actions:sleep, repeat_rot, nil];
	id repeat_4ever = [CCRepeatForever actionWithAction:big_seq];
	[label runAction:repeat_4ever];
	
}

-(void) buttonRestart:(id)sender
{
	// HERE HERE TODO HERE!!
	[[CCDirector sharedDirector] replaceScene: [CCCrossFadeTransition transitionWithDuration:1 scene:[MenuScene scene]]];
}

- (void) dealloc
{
	[super dealloc];
}


#pragma mark Touch Handling

-(void) registerWithTouchDispatcher
{
	// Priorities: lower number, higher priority
	// Joystick: 10
	// GameNode (dragging objects): 50
	// HUD (dragging screen): 100
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:100 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

// drag the screen
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchLocation = [touch locationInView: [touch view]];	
	CGPoint prevLocation = [touch previousLocationInView: [touch view]];	
	
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
	
	CGPoint diff = ccpSub(touchLocation,prevLocation);
	game.cameraOffset = ccpAdd( game.cameraOffset, diff );
}

@end
