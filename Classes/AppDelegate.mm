//
//  AppDelegate.m
//  LevelSVG
//
//  Created by Ricardo Quesada on 12/09/09.
//  Copyright Sapus Media 2009. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION
//


// cocos2d and cocosdenshion imports
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

// local imports
#import "AppDelegate.h"
#import "IntroScene.h"


@interface AppDelegate (Sounds)
-(void) initSounds;
@end

@implementation AppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:YES];
	
	// must be called before any othe call to the director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeNSTimer];
	
	// Use RGB_565 buffers (default one)
	//[[CCDirector sharedDirector] setPixelFormat:kCCPixelFormatRGB565];
	
	// Create a depth buffer of 16 bits
	// Enable it if you are going to use 3D transitions or 3d objects
//	[[CCDirector sharedDirector] setDepthBufferFormat:kDepthBuffer16];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// before creating any layer, set the landscape mode
	[[CCDirector sharedDirector] setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
	[[CCDirector sharedDirector] setAnimationInterval:1.0/60];

	// You can turn on the FPS at runtime in the settings
	[[CCDirector sharedDirector] setDisplayFPS:NO];
	
	// create an openGL view inside a window
	[[CCDirector sharedDirector] attachInView:window];	
	[window makeKeyAndVisible];		

	// Init sounds
	[self initSounds];
	
	// Run
	[[CCDirector sharedDirector] runWithScene: [IntroScene scene]];
}

- (void)initSounds
{
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"pickup_coin.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"you_won.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"you_are_hit.wav"];

}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
