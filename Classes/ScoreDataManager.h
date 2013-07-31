//
//  ScoreDataManager.h
//  LevelSVG
//
//  Created by Keith Loughnane on 09/07/2010.
//  Copyright 2010 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ScoreDataManager : NSObject {

	
	//NSMutableArray *level1Scores_;
}
//@property (readonly,nonatomic) NSMutableArray *level1Scores;
-(id)getScoreDetails:(int) level;
-(int)insertScoreDetailsForLevel:(int) aLevel bananas:(int)aBanana grapes:(int)aGrapes yellowDiamond:(int)aYellowDia blueDiamond:(int)aBlueDia health:(int)aHealth time:(int)aTime score:(int)aScore;
-(id)init;
-(int)LoadScores:(int) llevel;
-(int)SaveScores:(int) llevel;

-(int)setTries:(int)lTries ForLevel:(int)llevel;
-(int)getTriesForLevel:(int)llevel;
-(int)getTriesForLevel:(int) llevel;
- (NSString *) scoreFilePath;
@end
