//
//  AboutNode.m
//  LevelSVG
//
//  Created by Ricardo Quesada on 25/03/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION
//

#import "BuyScene.h"
#import "MenuScene.h"
#import "SoundMenuItem.h"


@implementation BuyScene

+(id) scene {
	CCScene *s = [CCScene node];
	id node = [BuyScene node];
	[s addChild:node];
	return s;
}

-(id) init {
	if( (self=[super init])) {
		
		CGSize size = [[CCDirector sharedDirector] winSize];
		CCSprite *background = [CCSprite spriteWithFile:@"about-background.png"];
		background.position = ccp(size.width/2, size.height/2);
		[self addChild:background];
		
		// Menu: Back and Visit
		CGSize s = [[CCDirector sharedDirector] winSize];

		SoundMenuItem *visitButton = [SoundMenuItem itemFromNormalSpriteFrameName:@"visit-levelsvg-homepage-normal.png" selectedSpriteFrameName:@"visit-levelsvg-homepage-selected.png" target:self selector:@selector(visitHomepageCallback:)];	
		visitButton.position = ccp(s.width/2,30);

		SoundMenuItem *backButton = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-back-normal.png" selectedSpriteFrameName:@"btn-back-selected.png" target:self selector:@selector(backCallback:)];	
		backButton.position = ccp(5,s.height-5);
		backButton.anchorPoint = ccp(0,1);

		CCMenu *menu = [CCMenu menuWithItems:visitButton, backButton, nil];
		menu.position = ccp(0,0);
		[self addChild: menu z:0];
		
		
		
		
		NSMutableArray *temparr = [[NSMutableArray alloc] init];

		[temparr addObjectsFromArray:[[CCDirector sharedDirector] getScoreDetails:5]];
		//NSLog(@"LCS temparr filled");
		NSNumber *num = [[NSNumber alloc] init];
		//NSLog(@"LCS about to get number at index 6");
		num = [temparr objectAtIndex:6];
		//NSLog(@"LCS got at index 6");
		
		int tempInt  = [num intValue];
		//tempInt++;
		
		//NSLog(@"num in CompleteScene :%d",tempInt);
		
		
		NSString *str = [NSString stringWithFormat:@"SCORE %d", tempInt];
		
		CCBitmapFontAtlas *scoreLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:str fntFile:@"gas32.fnt"];
		[scoreLabel.texture setAliasTexParameters];
		[self addChild:scoreLabel z:1];
		[scoreLabel setPosition:ccp(s.width/2+0.5f-45, s.height-20.5f)];
		
		[[CCDirector sharedDirector] saveScores];
		
	}
	return self;
}

-(void) visitHomepageCallback: (id) sender {
	// Launches Safari and opens the requested web page
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
}

-(void) backCallback:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene: [CCRadialCWTransition transitionWithDuration:1.0f scene:[MenuScene scene]]];
}
@end
