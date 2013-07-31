//
//  SettingsScene.m
//  LevelSVG
//
//  Created by Ricardo Quesada on 22/10/09.
//  Copyright 2009 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION
//


#import "SettingsScene.h"
#import "MenuScene.h"
#import "GameConfiguration.h"
#import "SoundMenuItem.h"

@implementation SettingsScene

+(id) scene
{
	CCScene *scene = [CCScene node];
	id child = [SettingsScene node];
	
	[scene addChild:child];
	return scene;
}

-(id) init
{
	volume = 10;
	effectsVolume = 10;
	if( (self=[super init]) )
	{
		[super init];
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		CCSprite *background = [CCSprite spriteWithFile:@"settingscreen.png"];
		background.position = ccp(s.width/2, s.height/2);
		[self addChild:background z:-10];
		
		
		
		[CCMenuItemFont setFontName: @"Marker Felt"];
		[CCMenuItemFont setFontSize:30];
		CCMenuItemToggle *item1 = [CCMenuItemToggle itemWithTarget:self selector:@selector(controlCallback:) items:
								 [CCMenuItemFont itemFromString: @"Control: Tilt"],
								 [CCMenuItemFont itemFromString: @"Control: D-Pad"],
								 nil];

		CCMenuItemToggle *item2 = [CCMenuItemToggle itemWithTarget:self selector:@selector(controlFPS:) items:
								   [CCMenuItemFont itemFromString: @"Show FPS: OFF"],
								   [CCMenuItemFont itemFromString: @"Show FPS: ON"],
								   nil];
		
		//CCMenuItemLabel *label = 

		
		GameConfiguration *config = [GameConfiguration sharedConfiguration];
		if( config.controlType == kControlTypePad )
			item1.selectedIndex = 1;
		
		CCMenu *menu = [CCMenu menuWithItems:
					  item1, item2,
						nil];
		[menu alignItemsVertically];
		
		[self addChild: menu];
		
		
		// back button
		//CGSize s = [[CCDirector sharedDirector] winSize];
		SoundMenuItem *backButton = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-back-normal.png" selectedSpriteFrameName:@"btn-back-selected.png" target:self selector:@selector(backCallback:)];	
		backButton.position = ccp(5,s.height-5);
		backButton.anchorPoint = ccp(0,1);
		
		menu = [CCMenu menuWithItems:backButton, nil];
		menu.position = ccp(0,0);
		[self addChild: menu z:0];
		
		
		
		
		//NSLog(@"1");
		SoundMenuItem *sndDownButton = [SoundMenuItem itemFromNormalSpriteFrameName:@"volumedown.png" selectedSpriteFrameName:@"volumedown.png" target:self selector:@selector(volDownCallback:)];	
		//NSLog(@"1A");
		sndDownButton.position = ccp(140,60);
		//NSLog(@"1B");
		sndDownButton.anchorPoint = ccp(0,1);
		//NSLog(@"1C");
		
		menu = [CCMenu menuWithItems:sndDownButton, nil];
		menu.position = ccp(0,0);
		[self addChild: menu z:2];
		
		//NSLog(@"2");
		SoundMenuItem *sndUpButton = [SoundMenuItem itemFromNormalSpriteFrameName:@"volumeup.png" selectedSpriteFrameName:@"volumeup.png" target:self selector:@selector(volUpCallback:)];	
		sndUpButton.position = ccp(300,60);
		sndUpButton.anchorPoint = ccp(0,1);
		
		menu = [CCMenu menuWithItems:sndUpButton, nil];
		menu.position = ccp(0,0);
		[self addChild: menu z:3];
		
		
		volume = [[CCDirector sharedDirector] getBGVolume]*10;
		effectsVolume = [[CCDirector sharedDirector] getEffectsVolume]*10;
		
		
		
		CCBitmapFontAtlas *scoreLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"Music Vol:" fntFile:@"font24.fnt"];
		[scoreLabel.texture setAliasTexParameters];
		[self addChild:scoreLabel z:1];
		[scoreLabel setPosition:ccp(170,70)];
		
		vol = [CCBitmapFontAtlas bitmapFontAtlasWithString:[NSString stringWithFormat:@"%d", (int)volume] fntFile:@"font24.fnt"];
		//		[score.texture setAliasTexParameters];
		[self addChild:vol z:1];
		[vol setPosition:ccp(350,70)];
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//NSLog(@"3");
		
		SoundMenuItem *effDownButton = [SoundMenuItem itemFromNormalSpriteFrameName:@"volumedown.png" selectedSpriteFrameName:@"volumedown.png" target:self selector:@selector(effectsVolDownCallback:)];	
		effDownButton.position = ccp(140,110);
		effDownButton.anchorPoint = ccp(0,1);
		
		menu = [CCMenu menuWithItems:effDownButton, nil];
		menu.position = ccp(0,0);
		[self addChild: menu z:2];
		
		//NSLog(@"4");
		
		SoundMenuItem *effUpButton = [SoundMenuItem itemFromNormalSpriteFrameName:@"volumeup.png" selectedSpriteFrameName:@"volumeup.png" target:self selector:@selector(effectsVolUpCallback:)];	
		effUpButton.position = ccp(300,110);
		effUpButton.anchorPoint = ccp(0,1);
		
		menu = [CCMenu menuWithItems:effUpButton, nil];
		menu.position = ccp(0,0);
		[self addChild: menu z:3];
		
		
		
		
		CCBitmapFontAtlas *effectsLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"Effects Vol:" fntFile:@"font24.fnt"];
		[effectsLabel.texture setAliasTexParameters];
		[self addChild:effectsLabel z:1];
		[effectsLabel setPosition:ccp(170,120)];
		
	//	float tvol = [[CCDirector sharedDirector] getBGVolume];
	//	NSString *tempstr;
		//[tempstr alloc];
	//[tempstr stringWithFormat:@"Layer %d",tvol];
		
		effectsVol = [CCBitmapFontAtlas bitmapFontAtlasWithString:[NSString stringWithFormat:@"%d", (int)effectsVolume] fntFile:@"font24.fnt"];
		//		[score.texture setAliasTexParameters];
		[self addChild:effectsVol z:1];
		[effectsVol setPosition:ccp(350,120)];		
		
		
		

		//[volDownCallback:(id)NULL];
		
		
		
		return self;
	}
	
	return self;
}


-(void) backCallback:(id)sender
{
	[[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:1 scene:[MenuScene scene] withColor:ccWHITE]];
}

-(void) volUpCallback:(id)sender
{
	if(volume < 30)
	{
	volume++;
		//	vol = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"001" fntFile:@"font24.fnt"];
	
	[vol setString: [NSString stringWithFormat:@"%03d", (int)volume]];
	[vol stopAllActions];
	id scaleTo = [CCScaleTo actionWithDuration:0.1f scale:1.2f];
	id scaleBack = [CCScaleTo actionWithDuration:0.1f scale:1];
	id seq = [CCSequence actions:scaleTo, scaleBack, nil];
	[vol runAction:seq];
	
	[[CCDirector sharedDirector] setBGVolume:volume];
	}
}

-(void) volDownCallback:(id)sender
{
	if(volume >0)
	{
	volume--;
		
	[vol setString: [NSString stringWithFormat:@"%03d", (int)volume]];
	[vol stopAllActions];
	id scaleTo = [CCScaleTo actionWithDuration:0.1f scale:1.2f];
	id scaleBack = [CCScaleTo actionWithDuration:0.1f scale:1];
	id seq = [CCSequence actions:scaleTo, scaleBack, nil];
	[vol runAction:seq];	
		[[CCDirector sharedDirector] setBGVolume:(int)volume];
	
	}
}



-(void) effectsVolUpCallback:(id)sender
{
	if(effectsVolume < 30)
	{
		effectsVolume++;
		//	vol = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"001" fntFile:@"font24.fnt"];
		
		[effectsVol setString: [NSString stringWithFormat:@"%03d", (int)effectsVolume]];
		[effectsVol stopAllActions];
		id scaleTo = [CCScaleTo actionWithDuration:0.1f scale:1.2f];
		id scaleBack = [CCScaleTo actionWithDuration:0.1f scale:1];
		id seq = [CCSequence actions:scaleTo, scaleBack, nil];
		[effectsVol runAction:seq];
		
		[[CCDirector sharedDirector] setEffectsVolume:(int)effectsVolume];
	}
}


-(void) effectsVolDownCallback:(id)sender
{
	if(effectsVolume >0)
	{
		effectsVolume--;
		[effectsVol setString: [NSString stringWithFormat:@"%03d", (int)effectsVolume]];
		[effectsVol stopAllActions];
		id scaleTo = [CCScaleTo actionWithDuration:0.1f scale:1.2f];
		id scaleBack = [CCScaleTo actionWithDuration:0.1f scale:1];
		id seq = [CCSequence actions:scaleTo, scaleBack, nil];
		[effectsVol runAction:seq];	
		[[CCDirector sharedDirector] setEffectsVolume:effectsVolume];
		
	}
}
		

-(void) controlFPS:(id)sender
{
	CCMenuItemToggle *item = (CCMenuItemToggle*) sender;	
	if( item.selectedIndex == 0 )
		[[CCDirector sharedDirector] setDisplayFPS:NO];
	else
		[[CCDirector sharedDirector] setDisplayFPS:YES];
}

-(void) controlCallback:(id)sender
{
	CCMenuItemToggle *item = (CCMenuItemToggle*) sender;	
	GameConfiguration *config = [GameConfiguration sharedConfiguration];
	if( item.selectedIndex == 0 )
		config.controlType = kControlTypeTilt;
	else
		config.controlType = kControlTypePad;
}
@end
