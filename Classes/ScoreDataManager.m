//
//  ScoreDataManager.m
//  LevelSVG
//
//  Created by Keith Loughnane on 09/07/2010.
//  Copyright 2010 none. All rights reserved.
//

#import "ScoreDataManager.h"


@implementation ScoreDataManager

NSMutableArray *level1Scores_;
NSMutableArray *level2Scores_;
NSMutableArray *level3Scores_;
NSMutableArray *level4Scores_;
NSMutableArray *level5Scores_;
//@synthesize level1Scores = level1Scores_;
-(id) init
{
	//NSLog(@"ScoreDataManager has been init'd");
	
	level1Scores_ = [[NSMutableArray alloc] init];
	
	// TO change defaults to 0 for release version, sequental numbers are usefull for debugging
	
	
	NSNumber *tempNum;
	tempNum  = [NSNumber numberWithInt:0];
		[level1Scores_ addObject:tempNum];

		[level1Scores_ addObject:tempNum];
	
		[level1Scores_ addObject:tempNum];

		[level1Scores_ addObject:tempNum];

		[level1Scores_ addObject:tempNum];

		[level1Scores_ addObject:tempNum];
		[level1Scores_ addObject:tempNum];

	[level1Scores_ addObject:tempNum];
[level1Scores_ addObject:tempNum];
	
	level2Scores_ = [[NSMutableArray alloc] init];

	
	[level2Scores_ addObject:tempNum];
	[level2Scores_ addObject:tempNum];
	[level2Scores_ addObject:tempNum];
	
	[level2Scores_ addObject:tempNum];
	[level2Scores_ addObject:tempNum];
	[level2Scores_ addObject:tempNum];
	
	[level2Scores_ addObject:tempNum];
	[level2Scores_ addObject:tempNum];
	[level2Scores_ addObject:tempNum];
	
	level3Scores_ = [[NSMutableArray alloc] init];
	
	
	[level3Scores_ addObject:tempNum];
	[level3Scores_ addObject:tempNum];
	[level3Scores_ addObject:tempNum];
	[level3Scores_ addObject:tempNum];
	[level3Scores_ addObject:tempNum];
	[level3Scores_ addObject:tempNum];
	[level3Scores_ addObject:tempNum];
	[level3Scores_ addObject:tempNum];
	[level3Scores_ addObject:tempNum];
	
	level4Scores_ = [[NSMutableArray alloc] init];

	
	[level4Scores_ addObject:tempNum];
	[level4Scores_ addObject:tempNum];
	[level4Scores_ addObject:tempNum];
	[level4Scores_ addObject:tempNum];
	[level4Scores_ addObject:tempNum];
	[level4Scores_ addObject:tempNum];
	[level4Scores_ addObject:tempNum];
	[level4Scores_ addObject:tempNum];
	[level4Scores_ addObject:tempNum];
	
	level5Scores_ = [[NSMutableArray alloc] init];

	
	[level5Scores_ addObject:tempNum];
	[level5Scores_ addObject:tempNum];
	[level5Scores_ addObject:tempNum];
	[level5Scores_ addObject:tempNum];
	[level5Scores_ addObject:tempNum];
	[level5Scores_ addObject:tempNum];
	[level5Scores_ addObject:tempNum];
	[level5Scores_ addObject:tempNum];
	[level5Scores_ addObject:tempNum];
	
	
	
	
	
	
	
	
	//NSNumber *num = [[NSNumber alloc] init];
	//num = [level1Scores_ objectAtIndex:0];
	//int tempInt  = [num intValue];
	//NSLog(@"num:%d",tempInt);
	//NSLog(@"init done");
	return self;
}
-(int)insertScoreDetailsForLevel:(int) aLevel bananas:(int)aBanana grapes:(int)aGrapes yellowDiamond:(int)aYellowDia blueDiamond:(int)aBlueDia health:(int)aHealth time:(int)aTime score:(int)aScore
{
	switch (aLevel) {
		case 1:
		{
				NSNumber *tempNum;
			tempNum  = [NSNumber numberWithInt:aBanana];
			[level1Scores_ replaceObjectAtIndex:0 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aGrapes];
			[level1Scores_ replaceObjectAtIndex:1 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aYellowDia];
			[level1Scores_ replaceObjectAtIndex:2 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aBlueDia];
			[level1Scores_ replaceObjectAtIndex:3 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aHealth];
			[level1Scores_ replaceObjectAtIndex:4 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aTime];
			[level1Scores_ replaceObjectAtIndex:5 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aScore];
			[level1Scores_ replaceObjectAtIndex:6 withObject:tempNum];

		}
			break;
			
		case 2:
		{
			NSNumber *tempNum;
			tempNum  = [NSNumber numberWithInt:aBanana];
			[level2Scores_ replaceObjectAtIndex:0 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aGrapes];
			[level2Scores_ replaceObjectAtIndex:1 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aYellowDia];
			[level2Scores_ replaceObjectAtIndex:2 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aBlueDia];
			[level2Scores_ replaceObjectAtIndex:3 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aHealth];
			[level2Scores_ replaceObjectAtIndex:4 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aTime];
			[level2Scores_ replaceObjectAtIndex:5 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aScore];
			[level2Scores_ replaceObjectAtIndex:6 withObject:tempNum];			
		}
			break;
			
		case 3:
		{
			NSNumber *tempNum;
			tempNum  = [NSNumber numberWithInt:aBanana];
			[level3Scores_ replaceObjectAtIndex:0 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aGrapes];
			[level3Scores_ replaceObjectAtIndex:1 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aYellowDia];
			[level3Scores_ replaceObjectAtIndex:2 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aBlueDia];
			[level3Scores_ replaceObjectAtIndex:3 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aHealth];
			[level3Scores_ replaceObjectAtIndex:4 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aTime];
			[level3Scores_ replaceObjectAtIndex:5 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aScore];
			[level3Scores_ replaceObjectAtIndex:6 withObject:tempNum];
			
		}
			break;
			
		case 4:
		{
			NSNumber *tempNum;
			tempNum  = [NSNumber numberWithInt:aBanana];
			[level4Scores_ replaceObjectAtIndex:0 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aGrapes];
			[level4Scores_ replaceObjectAtIndex:1 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aYellowDia];
			[level4Scores_ replaceObjectAtIndex:2 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aBlueDia];
			[level4Scores_ replaceObjectAtIndex:3 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aHealth];
			[level4Scores_ replaceObjectAtIndex:4 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aTime];
			[level4Scores_ replaceObjectAtIndex:5 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aScore];
			[level4Scores_ replaceObjectAtIndex:6 withObject:tempNum];
			
		}
			break;
			
		case 5:
		{
			NSNumber *tempNum;
			tempNum  = [NSNumber numberWithInt:aBanana];
			[level5Scores_ replaceObjectAtIndex:0 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aGrapes];
			[level5Scores_ replaceObjectAtIndex:1 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aYellowDia];
			[level5Scores_ replaceObjectAtIndex:2 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aBlueDia];
			[level5Scores_ replaceObjectAtIndex:3 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aHealth];
			[level5Scores_ replaceObjectAtIndex:4 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aTime];
			[level5Scores_ replaceObjectAtIndex:5 withObject:tempNum];
			tempNum  = [NSNumber numberWithInt:aScore];
			[level5Scores_ replaceObjectAtIndex:6 withObject:tempNum];
			
		}
			break;
		default:
			break;
	}
	return 0;
}
			
-(id)getScoreDetails:(int) level
{
	//NSNumber *num = [[NSNumber alloc] init];
	//num = [level1Scores_ objectAtIndex:0];
	
	//int tempInt  = [num intValue];
	
	//NSLog(@"num in get details:%d",tempInt);
	switch (level) {
		case 1:
				return (id)level1Scores_;
			break;
		case 2:
			return (id)level2Scores_;
			break;
		case 3:
			return (id)level3Scores_;
			break;
		case 4:
			return (id)level4Scores_;
			break;
		case 5:
			return (id)level5Scores_;
			break;
		default:
			break;
	}
	return (id)NULL;
	
	/* ----THIS CODE IS IMPORTANT, IT WORKS --------
	 scoreManager_ = [ScoreDataManager alloc];
	 [scoreManager_ init];
	 [scoreManager_ getScoreDetails:1];
	 
	 NSMutableArray *temparr = [[NSMutableArray alloc] init];
	 
	 
	 [temparr addObjectsFromArray:[scoreManager_ getScoreDetails:1]];
	 
	 
	 NSNumber *num = [[NSNumber alloc] init];
	 num = [temparr objectAtIndex:0];
	 
	 int tempInt  = [num intValue];
	 
	 NSLog(@"num in CCDirector :%d",tempInt);
	 ------------------------------------  */
	
}
- (NSString *) scoreFilePath
{	
	
	//Dont using new string add to existing string and send to lable, do not clear.
	//NSString *tempString;	
	/////
	//NSLog(@"score file path 1");
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//NSLog(@"2");
	NSString *documentsDirectory = [paths objectAtIndex:0];
	//NSLog(@"3");
	//tempString =[[NSString alloc] initWithCString: "\nSetting up path\n"];
	//newString = [newString stringByAppendingString:tempString];	
	
	//tempString =[[NSString alloc] initWithCString: documentsDirectory];
	//newString = [newString stringByAppendingString:documentsDirectory];	
	
	//NSLog(@"4");
	NSString *tempPath = [[NSString alloc] initWithCString: "scores.plist"];
	//NSLog(@"5");
	//[tempPath release];
	//[documentsDirectory release];
	return [documentsDirectory stringByAppendingPathComponent:tempPath];	
	
	
	
	//return documentsDirectory;
	
}

-(int)getTriesForLevel:(int) llevel
{
		NSNumber *num = [[NSNumber alloc] init];
switch (llevel) {
	case 1:
	{
	
		num = [level1Scores_ objectAtIndex:8];
		
		int tempInt  = [num intValue];
		
		return tempInt;
	}
	case 2:
	{
		//NSNumber *num = [[NSNumber alloc] init];
		num = [level2Scores_ objectAtIndex:8];
		
		int tempInt  = [num intValue];
		
		return tempInt;
	}
	case 3:
	{
		//NSNumber *num = [[NSNumber alloc] init];
		num = [level3Scores_ objectAtIndex:8];
		
		int tempInt  = [num intValue];
		
		return tempInt;
	}
	case 4:
	{
		//NSNumber *num = [[NSNumber alloc] init];
		num = [level4Scores_ objectAtIndex:8];
		
		int tempInt  = [num intValue];
		
		return tempInt;
	}
	case 5:
	{
		//NSNumber *num = [[NSNumber alloc] init];
		num = [level5Scores_ objectAtIndex:8];
		
		int tempInt  = [num intValue];
		
		return tempInt;
	}
		break;
	default:
		break;
}
		
		return -999;
}



-(int)setTries:(int)lTries ForLevel:(int)alevel
{
	switch (alevel) {
		case 1:
		{
			NSNumber *tempNum;
			tempNum  = [NSNumber numberWithInt:lTries];
			[level1Scores_ replaceObjectAtIndex:8 withObject:tempNum];	
		}
			break;
			
		case 2:
		{
			NSNumber *tempNum;
			tempNum  = [NSNumber numberWithInt:lTries];
			[level2Scores_ replaceObjectAtIndex:8 withObject:tempNum];			
		}
			break;
			
		case 3:
		{
			NSNumber *tempNum;
			tempNum  = [NSNumber numberWithInt:lTries];
			[level3Scores_ replaceObjectAtIndex:8 withObject:tempNum];	
			
		}
			break;
			
		case 4:
		{
			NSNumber *tempNum;
			tempNum  = [NSNumber numberWithInt:lTries];
			[level4Scores_ replaceObjectAtIndex:8 withObject:tempNum];	
			
		}
			break;
			
		case 5:
		{
			NSNumber *tempNum;
			tempNum  = [NSNumber numberWithInt:lTries];
			[level5Scores_ replaceObjectAtIndex:8 withObject:tempNum];	
			
		}
			break;
		default:
			break;
	}
	return 0;
}
-(int)LoadScores:(int) llevel
{
	int lenghtForArrays = 9;
	// NB TODO This code has not been adapted yet and will surly fail.
	
	
	
	
	/////
	/*
	 NSString *filePath = [self dataFilePath];
	 if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
	 {
	 NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
	 field1.text = filePath;
	 field2.text = [array objectAtIndex:1];
	 field3.text = [array objectAtIndex:2];
	 field4.text = [array objectAtIndex:3];
	 [array release];
	 }
	 */
	
	/////
	
	//tempString =[[NSString alloc] initWithCString: "\nLoading State From => "];
	//newString = [newString stringByAppendingString:tempString];
	
	NSString *path = [self scoreFilePath];
	
	
	//tempString =[[NSString alloc] initWithCString:path];
	//newString = [newString stringByAppendingString:tempString];	
	
	//path = [path stringByAppendingString:kFilename];
	
	
	//NSLog(@"Loading Scores:");	
	
	if([[NSFileManager defaultManager] fileExistsAtPath:path])
	{
		//NSLog(@"File Existing Continueing");
		//NSNumber *myNo;
		NSMutableArray *array = [[NSArray alloc] initWithContentsOfFile:path];
		//NSLog(@"count = %i", [array count]);
		//NSNumber *numx = 		
	//	bodies = [array count]/14;
		//NSLog(@"bodies = %i", bodies);			//bodies = array size
		for(int i = 0; i <200;i++)
		{
			//NSLog(@"i = %i", i);
			//tempString = [NSString stringWithFormat:@"%i",i];	
			//newString = [newString stringByAppendingString:tempString];
			@try{		
				
				if(i< lenghtForArrays) //Level 1
				{
					//NSLog(@"Loading Level 1 %@",[[array objectAtIndex:i] stringValue]);
					[level1Scores_ replaceObjectAtIndex:i withObject:[array objectAtIndex:i]];
					//[level1Scores_ insertObject:[array objectAtIndex:i] atIndex:i];
				}
				else if(i< lenghtForArrays*2) //Level 2
				{
					//NSLog(@"Loading Level 2 %@",[[array objectAtIndex:i] stringValue]);
					[level2Scores_ replaceObjectAtIndex:i-(lenghtForArrays) withObject:[array objectAtIndex:i]];
					//[level2Scores_ insertObject:[array objectAtIndex:i] atIndex:i-(lenghtForArrays)];
				}
				else if(i< lenghtForArrays*3) //Level 3
				{
					//NSLog(@"Loading Level 3 %@",[[array objectAtIndex:i] stringValue]);
					[level3Scores_ replaceObjectAtIndex:i-(lenghtForArrays*2) withObject:[array objectAtIndex:i]];
					//[level2Scores_ insertObject:[array objectAtIndex:i] atIndex:i-(lenghtForArrays*2)];
				}
				else if(i< lenghtForArrays*4) //Level 4
				{
					//NSLog(@"Loading Level 4 %@",[[array objectAtIndex:i] stringValue]);
					[level4Scores_ replaceObjectAtIndex:i-(lenghtForArrays*3) withObject:[array objectAtIndex:i]];
					//[level2Scores_ insertObject:[array objectAtIndex:i] atIndex:i-(lenghtForArrays*3)];
				}
				else if(i< lenghtForArrays*5) //Level 5
				{
					//NSLog(@"Loading Level 5 %@",[[array objectAtIndex:i] stringValue]);
					[level5Scores_ replaceObjectAtIndex:i-(lenghtForArrays*4) withObject:[array objectAtIndex:i]];
					//[level2Scores_ insertObject:[array objectAtIndex:i] atIndex:i-(lenghtForArrays*4)];
				}
				
				
				
				
			}
			
			@catch (NSException *exception) {
				NSLog(@"This aint good %@: %@",[exception name],[exception reason]);
				//scores[i] = 0;
			}
			@finally {
				
			}
			
			
			//mass[i] = 500;
			
			
			//NSLog(@"loaded Score at %i (%i)",i,scores[i]);
			//y[i] = (int)[array objectAtIndex:i+bodies];
		}
		//bodies--; // BUGFIX TODO: understand, probable off by one in load/save process
		//tempString =[[NSString alloc] initWithCString: "\nRealeasing"];
		//newString = [newString stringByAppendingString:tempString];
		[array release];
	}
	
	
	//NSString *tempString =[[NSString alloc] initWithCString: "\nLoad failed"];
	//newString = [newString stringByAppendingString:tempString];	
	
	
	//[path release];
	return 0;
	
}



-(int)SaveScores:(int) llevel
{
	
	// NB TODO: This code has not been adapted yet and will surly fail
	
	int lenghtForArrays = 9;
	
	
	//NSLog(@"Saving Scores:");
	NSString *spath = [self scoreFilePath];
	NSString *tmpPath = [spath stringByAppendingString:@".tmp"];
	//path = [path stringByAppendingString:kFilename];
	//NSLog(@"decraring number");
	NSNumber *myNo;
	//NSLog(@"declaring array");
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	
	//NSLog(@"array size:%i",[array count]);	
	//for(int j = [array count]-1; j < 100; j++)
	
	for(int i = 0; i < 200; i++)
	{
		//NSLog(@"i = %i",i);
		//NSLog(@"inserting object at %i (%i)",(level*10)+i,scores[i]);
		//scores[i] = i;
		
		
		
		
		if(i< lenghtForArrays)
		{
		
			//NSLog(@"Saving level 1");

			myNo = [level1Scores_ objectAtIndex:i];
		
					//NSLog(@"Saving score %@",[myNo stringValue]);
		
		
		
		
		
		
		//myNo = [NSNumber numberWithDouble:(double)i];
		//tempString = [NSString stringWithFormat:@"%i",x[i]];	
		//newString = [newString stringByAppendingString:tempString];	
		//[array addObject:myNo];
		//NSLog(@"inserting object at %i (%i)",i,scores[i]);
		[array insertObject:myNo atIndex:i];
		}
		else if(i< lenghtForArrays*2)
		{
			
			//NSLog(@"Saving level 2");
			
			myNo = [level2Scores_ objectAtIndex:i-(lenghtForArrays)];
			
			//NSLog(@"Saving score %@",[myNo stringValue]);
			
			
			
			
			
			
			//myNo = [NSNumber numberWithDouble:(double)i];
			//tempString = [NSString stringWithFormat:@"%i",x[i]];	
			//newString = [newString stringByAppendingString:tempString];	
			//[array addObject:myNo];
			//NSLog(@"inserting object at %i (%i)",i,scores[i]);
			[array insertObject:myNo atIndex:i];
		}
		else if(i< lenghtForArrays*3)
		{
			
			//NSLog(@"Saving level 3");
			
			myNo = [level3Scores_ objectAtIndex:i-(lenghtForArrays*2)];
			
			//NSLog(@"Saving score %@",[myNo stringValue]);
			
			
			
			
			
			
			//myNo = [NSNumber numberWithDouble:(double)i];
			//tempString = [NSString stringWithFormat:@"%i",x[i]];	
			//newString = [newString stringByAppendingString:tempString];	
			//[array addObject:myNo];
			//NSLog(@"inserting object at %i (%i)",i,scores[i]);
			[array insertObject:myNo atIndex:i];
		}
		else if(i< lenghtForArrays*4)
		{
			
			//NSLog(@"Saving level 4");
			
			myNo = [level4Scores_ objectAtIndex:i-(lenghtForArrays*3)];
			
			//NSLog(@"Saving score %@",[myNo stringValue]);
			
			
			
			
			
			
			//myNo = [NSNumber numberWithDouble:(double)i];
			//tempString = [NSString stringWithFormat:@"%i",x[i]];	
			//newString = [newString stringByAppendingString:tempString];	
			//[array addObject:myNo];
			//NSLog(@"inserting object at %i (%i)",i,scores[i]);
			[array insertObject:myNo atIndex:i];
		}
		else if(i< lenghtForArrays*5)
		{
			
			//NSLog(@"Saving level 5");
			
			myNo = [level5Scores_ objectAtIndex:i-(lenghtForArrays*4)];
			
			//NSLog(@"Saving score %@",[myNo stringValue]);
			
			
			
			
			
			
			//myNo = [NSNumber numberWithDouble:(double)i];
			//tempString = [NSString stringWithFormat:@"%i",x[i]];	
			//newString = [newString stringByAppendingString:tempString];	
			//[array addObject:myNo];
			//NSLog(@"inserting object at %i (%i)",i,scores[i]);
			[array insertObject:myNo atIndex:i];
		}

	}
	
	
	//NSLog(@"array size:%i",[array count]);
	
	//NSString *tempString =[[NSString alloc] initWithCString: "\nSaving State"];
	//newString = [newString stringByAppendingString:tempString];		
	//debugText.text = newString;	
	//NSLog(@"writing");
	
	
	//[array writeToFile:path atomically:YES];
	
	
	//NSLog(@"Releasing");
	[array writeToFile:tmpPath atomically:YES];
	[array release];
	
	[[NSFileManager defaultManager] removeItemAtPath:spath  error:nil];
	[[NSFileManager defaultManager] moveItemAtPath:tmpPath toPath:spath error:nil];
	//[spath release];
	 
	//NSLog(@"Saving done");
	return 0;
	
}

@end
