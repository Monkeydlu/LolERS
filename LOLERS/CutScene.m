//
//  CutScene.m
//  LOLERS
//
//  Created by MingYang Lu on 12/2/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "CutScene.h"
#import "ErsGameScene.h"

@implementation CutSceneScene
@synthesize layer = _layer;

- (id)init {
	
	if ((self = [super init])) {
		self.layer = [CutSceneLayer node];
		[self addChild:_layer];
	}
	return self;
}

- (void)dealloc {
	[_layer release];
	_layer = nil;
	[super dealloc];
}

@end

@interface CutSceneLayer()

- (void) loadCutScene;
- (void) displayCutScene;
- (void) loadGameWithAshe;
- (void) loadGameWithMalphite;

@end

@implementation CutSceneLayer

@synthesize CutSceneNumber = CutSceneNumber;
@synthesize loadingSplashScreen = loadingSplashScreen;

-(id) init
{
	if( (self=[super initWithColor:ccc4(255, 255,0,255)] )) {
		displayingStory = false;
		cutSceneStoryPage = 1;
		
		textWindowLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(340, 100) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap fontName:@"Arial" fontSize:20];
		textWindowLabel.color = ccc3(0, 0, 0);
		[textWindowLabel setPosition: ccp(240, 50)];
		[self addChild:textWindowLabel];
	}
	
	self.isTouchEnabled = YES;
	return self;
}

- (void) loadCutScene{
	[self removeChild:loadingSplashScreen cleanup:YES];
	
	[self performSelector:@selector(displayCutScene) withObject:nil afterDelay:0.3];
	displayingStory = true;
}

/*
else if(cutSceneStoryPage == 2){
	cutSceneStoryPage++;
	[textWindowLabel setString:@""];
}
 
 
 
else if(CutSceneNumber == 2){
if (cutSceneStoryPage == 1) {
	cutSceneStoryPage++;
	[textWindowLabel setString:@""];
}else if(cutSceneStoryPage == 5){
	displayingStory = false;
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CCSprite* SplashScreen = [CCSprite spriteWithFile:@"MalphiteSplash.png"];
	SplashScreen.position = ccp(winSize.width/2, winSize.height/2);
	[self addChild:SplashScreen];
	[self performSelector:@selector(loadGameWithMalphite) withObject:nil afterDelay:0.1];
}
 }
*/

- (void) displayCutScene{
	
	if (CutSceneNumber == 1) {
		if (cutSceneStoryPage == 1) {
			cutSceneStoryPage++;
			[textWindowLabel setString:@"This is a wonderful story about Ashe the archer."];
		}else if(cutSceneStoryPage == 2){
			cutSceneStoryPage++;
			[textWindowLabel setString:@"At least... it's kinda an awesome story. I mean, it's the kind of story that I'm sure you'll enjoy."];
		}else if(cutSceneStoryPage == 3){
			cutSceneStoryPage++;
			[textWindowLabel setString:@"Ok, well, whatever. You're GOING TO ENJOY IT OK."];
		}else if(cutSceneStoryPage == 4){
			cutSceneStoryPage++;
			[textWindowLabel setString:@"But yeah, basically, you're Ashe, an archer, and you're going to play a children's card game to save to world."];
		}else if(cutSceneStoryPage == 5){
			cutSceneStoryPage++;
			[textWindowLabel setString:@"Now shut up and go beat the minion."];
		}else if(cutSceneStoryPage == 6){
			displayingStory = false;
			
			CGSize winSize = [[CCDirector sharedDirector] winSize];
			
			CCSprite* SplashScreen = [CCSprite spriteWithFile:@"AsheSplash.png"];
			SplashScreen.position = ccp(winSize.width/2, winSize.height/2);
			[self addChild:SplashScreen];
			
			[self performSelector:@selector(loadGameWithAshe) withObject:nil afterDelay:0.1];
		}
	}else if(CutSceneNumber == 2){
		if (cutSceneStoryPage == 1) {
			cutSceneStoryPage++;
			[textWindowLabel setString:@"You are Malphite, and YOU, are ROCK SOLID."];
		}else if(cutSceneStoryPage == 2){
			cutSceneStoryPage++;
			[textWindowLabel setString:@"You are on a journy to defeat your eternal rival, Ashe, the bitch with the gay slowing ice arrows."];
		}else if(cutSceneStoryPage == 3){
			cutSceneStoryPage++;
			[textWindowLabel setString:@"Go, play a children's card game in order to save the world, and make Tryndamere never insta-lock again."];
		}else if(cutSceneStoryPage == 4){
			cutSceneStoryPage++;
			[textWindowLabel setString:@"But first, go beat a minion."];
		}else if(cutSceneStoryPage == 5){
			displayingStory = false;
			
			CGSize winSize = [[CCDirector sharedDirector] winSize];
			
			CCSprite* SplashScreen = [CCSprite spriteWithFile:@"MalphiteSplash.png"];
			SplashScreen.position = ccp(winSize.width/2, winSize.height/2);
			[self addChild:SplashScreen];
			
			[self performSelector:@selector(loadGameWithMalphite) withObject:nil afterDelay:0.1];
		}
	}else if(CutSceneNumber == 3){
		if (cutSceneStoryPage == 1) {
			cutSceneStoryPage++;
			[textWindowLabel setString:@"Congratulations, you've managed to beat the minion."];
		}else if(cutSceneStoryPage == 2){
			cutSceneStoryPage++;
			[textWindowLabel setString:@"It is definetly debatable if you should feel of that acomplishment or not, but hey, don't let that stop you from doing so."];
		}else if(cutSceneStoryPage == 3){
			cutSceneStoryPage++;
			[textWindowLabel setString:@"Anyways, you're next fight shall determine the fate of the world. You are about to face you're life long rival..."];
		}else if(cutSceneStoryPage == 4){
			cutSceneStoryPage++;
			[textWindowLabel setString:@"MALPHITE!"];
		}else if(cutSceneStoryPage == 5){
			displayingStory = false;
			CGSize winSize = [[CCDirector sharedDirector] winSize];
			CCSprite* SplashScreen = [CCSprite spriteWithFile:@"AsheSplash.png"];
			SplashScreen.position = ccp(winSize.width/2, winSize.height/2);
			[self addChild:SplashScreen];
			[self performSelector:@selector(loadGameWithAshe) withObject:nil afterDelay:0.1];
		}
	}else if(CutSceneNumber == 4){
		if (cutSceneStoryPage == 1) {
			cutSceneStoryPage++;
			[textWindowLabel setString:@"ROCK SOLID!"];
		}else if(cutSceneStoryPage == 2){
			cutSceneStoryPage++;
			[textWindowLabel setString:@"You have defeated the minion as one would expect from ROCK SOLID."];
		}else if(cutSceneStoryPage == 3){
			cutSceneStoryPage++;
			[textWindowLabel setString:@"But now, it is time to finally defeat who you REALLY came for..."];
		}else if(cutSceneStoryPage == 4){
			cutSceneStoryPage++;
			[textWindowLabel setString:@"ASHE!"];
		}else if(cutSceneStoryPage == 5){
			displayingStory = false;
			CGSize winSize = [[CCDirector sharedDirector] winSize];
			CCSprite* SplashScreen = [CCSprite spriteWithFile:@"MalphiteSplash.png"];
			SplashScreen.position = ccp(winSize.width/2, winSize.height/2);
			[self addChild:SplashScreen];
			[self performSelector:@selector(loadGameWithMalphite) withObject:nil afterDelay:0.1];
		}
	}
	
}

- (void) loadGameWithAshe{
	ErsGameScene *gameScene = [ErsGameScene node];
	
	gameScene.layer.loadingSplashScreen = [CCSprite spriteWithFile:@"AsheSplashFinished.png"];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	gameScene.layer.loadingSplashScreen.position = ccp(winSize.width/2, winSize.height/2);
	[gameScene.layer addChild:gameScene.layer.loadingSplashScreen];
	gameScene.layer.characterSelected = @"Ashe";
	int stageNumber = 1;
	if (CutSceneNumber <=2) {
		stageNumber = 1;
	}else if(CutSceneNumber <= 4){
		stageNumber = 2;
	}
	gameScene.layer.currentStageLevel = stageNumber;
	[[CCDirector sharedDirector] replaceScene:gameScene];
}

- (void) loadGameWithMalphite{
	ErsGameScene *gameScene = [ErsGameScene node];
	
	gameScene.layer.loadingSplashScreen = [CCSprite spriteWithFile:@"MalphiteSplashFinished.png"];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	gameScene.layer.loadingSplashScreen.position = ccp(winSize.width/2, winSize.height/2);
	[gameScene.layer addChild:gameScene.layer.loadingSplashScreen];
	gameScene.layer.characterSelected = @"Malphite";
	int stageNumber = 1;
	if (CutSceneNumber <=2) {
		stageNumber = 1;
	}else if(CutSceneNumber <= 4){
		stageNumber = 2;
	}
	gameScene.layer.currentStageLevel = stageNumber;
	[[CCDirector sharedDirector] replaceScene:gameScene];
}

- (void)registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void)tapDownAt:(CGPoint)location {
	return;
}

- (void)tapMoveAt:(CGPoint)location {
	return;
}

- (void)tapUpAt:(CGPoint)location {
	if (displayingStory == false) {
		[self loadCutScene];
	}else{
		[self displayCutScene];
		return;
	}
	
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	[self tapDownAt:location];
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	[self tapMoveAt:location];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	[self tapUpAt:location];
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	[self tapUpAt:location];
}


- (void) dealloc
{
	[super dealloc];
}

@end
