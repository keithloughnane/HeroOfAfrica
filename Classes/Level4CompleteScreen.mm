//
//  SelectLevelScene.mm
//  LevelSVG
//
//  Created by Ricardo Quesada on 25/03/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION
//

#import "Level4CompleteScreen.h"
#import "Level0.h"
#import "Level1.h"
#import "Level2.h"
#import "Level3.h"
#import "Level4.h"
#import "SelectLevelScene.h"

#import "MenuScene.h"
#import "SoundMenuItem.h"

@implementation Level4CompleteScreen

+(id) scene
{
	CCScene *scene = [CCScene node];
	id child = [Level4CompleteScreen node];
	
	[scene addChild:child];
	return scene;
}

-(id) init
{
	if( (self=[super init]) )
	{
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		CCSprite *background = [CCSprite spriteWithFile:@"level4complete.png"];
		background.position = ccp(s.width/2, s.height/2);
		[self addChild:background z:-10];
		
		
		
		
		
		CCMenuItem * item0 = [CCMenuItemFont itemFromString:@"To Level 5" target:self selector:@selector(level4:)];
		//CCMenuItem * item1 = [CCMenuItemFont itemFromString:@"Level 2" target:self selector:@selector(level1:)];
		//CCMenuItem * item2 = [CCMenuItemFont itemFromString:@"Level 3" target:self selector:@selector(level2:)];
		//CCMenuItem * item3 = [CCMenuItemFont itemFromString:@"Level 4" target:self selector:@selector(level3:)];
		CCMenuItem * item4 = [CCMenuItemFont itemFromString:@"Main Menu" target:self selector:@selector(SelectLevelScene:)];
		//CCMenuItem * item5 = [CCMenuItemFont itemFromString:@"Playground 0" target:self selector:@selector(playground0:)];
		//CCMenuItem * item6 = [CCMenuItemFont itemFromString:@"Playground 1" target:self selector:@selector(playground1:)];
		
		CCMenu *menu = [CCMenu menuWithItems: item0, /*item1, item2, item3,*/ item4 /*, item5, item6*/, nil];
		
		[menu alignItemsInColumns:
		 [NSNumber numberWithUnsignedInt:1],
		 [NSNumber numberWithUnsignedInt:1],
		 // [NSNumber numberWithUnsignedInt:1],
		 //[NSNumber numberWithUnsignedInt:2],
		 nil
		 ]; // 2 + 2 + 1 + 2 = total count of 7
		menu.position = ccp(400,175);
		[self addChild:menu];
		
		
		// back button
		SoundMenuItem *backButton = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-back-normal.png" selectedSpriteFrameName:@"btn-back-selected.png" target:self selector:@selector(backCallback:)];	
		backButton.position = ccp(5,s.height-5);
		backButton.anchorPoint = ccp(0,1);
		
		menu = [CCMenu menuWithItems:backButton, nil];
		menu.position = ccp(0,0);
		[self addChild: menu z:0];
		
		
		
		
		NSMutableArray *temparr = [[NSMutableArray alloc] init];
		
		[temparr addObjectsFromArray:[[CCDirector sharedDirector] getScoreDetails:4]];
		//NSLog(@"LCS temparr filled");
		NSNumber *num = [[NSNumber alloc] init];
		//NSLog(@"LCS about to get number at index 6");
		
		
		//Score
		num = [temparr objectAtIndex:6];
		//NSLog(@"LCS got at index 6");
		int tempInt  = [num intValue];
		//tempInt++;
		//NSLog(@"num in CompleteScene :%d",tempInt);
		NSString *str = [NSString stringWithFormat:@"SCORE %d", tempInt];
		CCBitmapFontAtlas *scoreLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:str fntFile:@"gas32.fnt"];
		[scoreLabel.texture setAliasTexParameters];
		[self addChild:scoreLabel z:1];
		[scoreLabel setPosition:ccp(100,80)];
		
		
		
		/*
		 // Time
		 num = [temparr objectAtIndex:5];
		 NSLog(@"LCS got at index 6");
		 tempInt  = [num intValue];
		 //tempInt++;
		 NSLog(@"num in CompleteScene :%d",tempInt);
		 str = [NSString stringWithFormat:@"Time %f", tempInt];
		 CCBitmapFontAtlas *timeLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:str fntFile:@"gas32.fnt"];
		 NSLog(@"1");
		 [timeLabel.texture setAliasTexParameters];
		 NSLog(@"2");
		 [self addChild:timeLabel z:1];
		 NSLog(@"3");
		 [timeLabel setPosition:ccp(100, 110)];
		 NSLog(@"4");
		 
		 */
		
		// Health
		num = [temparr objectAtIndex:4];
		//NSLog(@"LCS got at index 6");
		tempInt  = [num intValue];
		//tempInt++;
		//NSLog(@"num in CompleteScene :%d",tempInt);
		str = [NSString stringWithFormat:@"Health %d", tempInt];
		CCBitmapFontAtlas *healthLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:str fntFile:@"gas32.fnt"];
		//NSLog(@"1");
		[healthLabel.texture setAliasTexParameters];
		//NSLog(@"2");
		[self addChild:healthLabel z:1];
		//NSLog(@"3");
		[healthLabel setPosition:ccp(100, 140)];
		//NSLog(@"4");
		
		
		
		// BDiamonds
		num = [temparr objectAtIndex:3];
		//NSLog(@"LCS got at index 6");
		tempInt  = [num intValue];
		//tempInt++;
		//NSLog(@"num in CompleteScene :%d",tempInt);
		str = [NSString stringWithFormat:@"Blue Gems %d", tempInt];
		CCBitmapFontAtlas *BDiamondsLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:str fntFile:@"gas32.fnt"];
		//NSLog(@"1");
		[BDiamondsLabel.texture setAliasTexParameters];
		//NSLog(@"2");
		[self addChild:BDiamondsLabel z:1];
		//NSLog(@"3");
		[BDiamondsLabel setPosition:ccp(100, 170)];
		//NSLog(@"4");
		
		
		
		// YDiamonds
		num = [temparr objectAtIndex:2];
		//NSLog(@"LCS got at index 6");
		tempInt  = [num intValue];
		//tempInt++;
		//NSLog(@"num in CompleteScene :%d",tempInt);
		str = [NSString stringWithFormat:@"Yellow Gems %d", tempInt];
		CCBitmapFontAtlas *YDiamondsLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:str fntFile:@"gas32.fnt"];
		//NSLog(@"1");
		[YDiamondsLabel.texture setAliasTexParameters];
		//NSLog(@"2");
		[self addChild:YDiamondsLabel z:1];
		//NSLog(@"3");
		[YDiamondsLabel setPosition:ccp(100, 200)];
		//NSLog(@"4");
		
		
		
		// Grapes
		num = [temparr objectAtIndex:1];
		//NSLog(@"LCS got at index 6");
		tempInt  = [num intValue];
		//tempInt++;
		//NSLog(@"num in CompleteScene :%d",tempInt);
		str = [NSString stringWithFormat:@"Grapes %d", tempInt];
		CCBitmapFontAtlas *grapesLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:str fntFile:@"gas32.fnt"];
		//NSLog(@"1");
		[grapesLabel.texture setAliasTexParameters];
		//NSLog(@"2");
		[self addChild:grapesLabel z:1];
		//NSLog(@"3");
		[grapesLabel setPosition:ccp(100, 230)];
		//NSLog(@"4");
		
		
		
		// Bananas
		num = [temparr objectAtIndex:0];
		//NSLog(@"LCS got at index 6");
		tempInt  = [num intValue];
		//tempInt++;
		//NSLog(@"num in CompleteScene :%d",tempInt);
		str = [NSString stringWithFormat:@"Bananas %d", tempInt];
		CCBitmapFontAtlas *bananasLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:str fntFile:@"gas32.fnt"];
		//NSLog(@"1");
		[bananasLabel.texture setAliasTexParameters];
		//NSLog(@"2");
		[self addChild:bananasLabel z:1];
		//NSLog(@"3");
		[bananasLabel setPosition:ccp(100, 260)];
		//NSLog(@"4");
		
		
		
		
		
		[[CCDirector sharedDirector] saveScores];
		
	}
	
	return self;
}

-(void) setLevelScene:(Class)klass
{
	[[CCDirector sharedDirector] replaceScene: [CCSplitRowsTransition transitionWithDuration:1 scene:[klass scene]]];
}

-(void) level0:(id)sender
{
	[self setLevelScene:[Level0 class]];
}

-(void) level1:(id)sender
{
	[self setLevelScene:[Level1 class]];
}

-(void) level2:(id)sender
{
	[self setLevelScene:[Level2 class]];
}

-(void) level3:(id)sender
{
	[self setLevelScene:[Level3 class]];
}

-(void) level4:(id)sender
{
	[self setLevelScene:[Level4 class]];
}
-(void) SelectLevelScene:(id)sender
{
	[self setLevelScene:[MenuScene class]];
}



-(void) backCallback:(id)sender
{
	[[CCDirector sharedDirector] replaceScene: [CCRotoZoomTransition transitionWithDuration:1 scene:[MenuScene scene] ]];
}
@end
