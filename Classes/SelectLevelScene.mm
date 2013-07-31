//
//  SelectLevelScene.mm
//  LevelSVG
//
//  Created by Ricardo Quesada on 25/03/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION
//

#import "SelectLevelScene.h"
#import "Level0.h"
#import "Level1.h"
#import "Level2.h"
#import "Level3.h"
#import "Level4.h"
#import "MenuScene.h"
#import "SoundMenuItem.h"

@implementation SelectLevelScene
bool Locked[10];

+(id) scene
{
	CCScene *scene = [CCScene node];
	id child = [SelectLevelScene node];
	
	[scene addChild:child];
	return scene;
}

-(id) init
{
	if( (self=[super init]) )
	{
	
		Locked[0] = false;
		Locked[1] = false;
		Locked[2] = false;
		Locked[3] = false;
		Locked[4] = false;

		
		
		// --------------   Comment to give access to all (handy for debugging levels
		
		
		if([[CCDirector sharedDirector] getTriesForLevel:2]<=0)
			Locked[1] = true;
		if([[CCDirector sharedDirector] getTriesForLevel:3]<=0)
			Locked[2] = true;
		if([[CCDirector sharedDirector] getTriesForLevel:4]<=0)
			Locked[3] = true;
		if([[CCDirector sharedDirector] getTriesForLevel:5]<=0)
			Locked[4] = true;
		
		
		// --------------
		
		NSString *str1 = [NSString stringWithFormat:@"Level 1 "];
		NSString *str2 = [NSString stringWithFormat:@"Level 2: %d Tries Left", [[CCDirector sharedDirector] getTriesForLevel:2]];
		NSString *str3 = [NSString stringWithFormat:@"Level 3: %d Tries Left", [[CCDirector sharedDirector] getTriesForLevel:3]];
		NSString *str4 = [NSString stringWithFormat:@"Level 4: %d Tries Left", [[CCDirector sharedDirector] getTriesForLevel:4]];
		NSString *str5 = [NSString stringWithFormat:@"Level 5: %d Tries Left", [[CCDirector sharedDirector] getTriesForLevel:5]];
		
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		CCSprite *background = [CCSprite spriteWithFile:@"select-level.png"];
		background.position = ccp(s.width/2, s.height/2);
		[self addChild:background z:-10];
		
		
		CCMenuItem * item0 = [CCMenuItemFont itemFromString:str1 target:self selector:@selector(level0:)];
		CCMenuItem * item1 = [CCMenuItemFont itemFromString:str2 target:self selector:@selector(level1:)];
		CCMenuItem * item2 = [CCMenuItemFont itemFromString:str3 target:self selector:@selector(level2:)];
		CCMenuItem * item3 = [CCMenuItemFont itemFromString:str4 target:self selector:@selector(level3:)];
		CCMenuItem * item4 = [CCMenuItemFont itemFromString:str5 target:self selector:@selector(level4:)];
		//CCMenuItem * item5 = [CCMenuItemFont itemFromString:@"Playground 0" target:self selector:@selector(playground0:)];
		//CCMenuItem * item6 = [CCMenuItemFont itemFromString:@"Playground 1" target:self selector:@selector(playground1:)];
		
		CCMenu *menu = [CCMenu menuWithItems: item0, item1, item2, item3, item4 /*, item5, item6*/, nil];
		
		[menu alignItemsInColumns:
		 [NSNumber numberWithUnsignedInt:1],
		 [NSNumber numberWithUnsignedInt:1],
		 [NSNumber numberWithUnsignedInt:1],
		 [NSNumber numberWithUnsignedInt:1],
		 		 [NSNumber numberWithUnsignedInt:1],
		 nil
		 ]; // 2 + 2 + 1 + 2 = total count of 7
		
		[self addChild:menu];
		
		
		// back button
		SoundMenuItem *backButton = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-back-normal.png" selectedSpriteFrameName:@"btn-back-selected.png" target:self selector:@selector(backCallback:)];	
		backButton.position = ccp(5,s.height-5);
		backButton.anchorPoint = ccp(0,1);
		
		menu = [CCMenu menuWithItems:backButton, nil];
		menu.position = ccp(0,0);
		[self addChild: menu z:0];
		
	}
	
	return self;
}

-(void) setLevelScene:(Class)klass
{
	[[CCDirector sharedDirector] replaceScene: [CCFadeUpTransition transitionWithDuration:0 scene:[klass scene]]];
}

-(void) level0:(id)sender
{
	if (!Locked[0]) {
	[self setLevelScene:[Level0 class]];
	}
}

-(void) level1:(id)sender
{
		if (!Locked[1]) {
	[self setLevelScene:[Level1 class]];
		}
}

-(void) level2:(id)sender
{
		if (!Locked[2]) {
	[self setLevelScene:[Level2 class]];
		}
}

-(void) level3:(id)sender
{
		if (!Locked[3]) {
	[self setLevelScene:[Level3 class]];
		}
}

-(void) level4:(id)sender
{
		if (!Locked[4]) {
	[self setLevelScene:[Level4 class]];
		}
}


-(void) backCallback:(id)sender
{
	[[CCDirector sharedDirector] replaceScene: [CCRotoZoomTransition transitionWithDuration:1 scene:[MenuScene scene] ]];
}
@end
