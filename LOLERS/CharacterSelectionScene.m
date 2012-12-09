//
//  CharacterSelectionScene.m
//  LOLERS
//
//  Created by MingYang Lu on 11/25/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "CharacterSelectionScene.h"
#import "ErsGameScene.h"
#import "CutScene.h"

@interface CharacterSelectionScene()

- (void) asheSelected: (CCMenuItem  *) menuItem;
- (void) malphiteSelected: (CCMenuItem  *) menuItem;
- (void) asheSelected2;
- (void) malphiteSelected2;


@end

@implementation CharacterSelectionScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CharacterSelectionScene *layer = [CharacterSelectionScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super initWithColor:ccc4(255, 255,0,255)] )) {
		
		CCMenuItemImage * asheSelect = [CCMenuItemImage itemFromNormalImage:@"AsheButton.png"
																   selectedImage: @"AsheButton_selected.png"
																		  target:self
																		selector:@selector(asheSelected:)];
		
		CCMenuItemImage * malphiteSelect = [CCMenuItemImage itemFromNormalImage:@"MalphiteButton.png"
																   selectedImage: @"MalphiteButton_selected.png"
																		  target:self
																		selector:@selector(malphiteSelected:)];
		
		CCMenu * myMenu = [CCMenu menuWithItems:asheSelect, malphiteSelect, nil];
		[myMenu alignItemsHorizontallyWithPadding:20];
		[self addChild:myMenu];
		
	}
	
	self.isTouchEnabled = YES;
	return self;
}

- (void) asheSelected: (CCMenuItem  *) menuItem 
{
	NSLog(@"new game was selected");
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	CCSprite* SplashScreen = [CCSprite spriteWithFile:@"AsheSplash.png"];
	SplashScreen.position = ccp(winSize.width/2, winSize.height/2);
	[self addChild:SplashScreen];
	
	[self performSelector:@selector(asheSelected2) withObject:nil afterDelay:0.1];

}

- (void) asheSelected2{
	CutSceneScene *gameScene = [CutSceneScene node];
	
	gameScene.layer.loadingSplashScreen = [CCSprite spriteWithFile:@"AsheSplashFinished.png"];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	gameScene.layer.loadingSplashScreen.position = ccp(winSize.width/2, winSize.height/2);
	[gameScene.layer addChild:gameScene.layer.loadingSplashScreen];
	gameScene.layer.CutSceneNumber = 1;
	[[CCDirector sharedDirector] replaceScene:gameScene];
}

- (void) malphiteSelected: (CCMenuItem  *) menuItem 
{
	NSLog(@"new game was selected");
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	CCSprite* SplashScreen = [CCSprite spriteWithFile:@"malphiteSplash.png"];
	SplashScreen.position = ccp(winSize.width/2, winSize.height/2);
	[self addChild:SplashScreen];
	
	[self performSelector:@selector(malphiteSelected2) withObject:nil afterDelay:0.1];

	
}

- (void) malphiteSelected2{
	CutSceneScene *gameScene = [CutSceneScene node];
	
	gameScene.layer.loadingSplashScreen = [CCSprite spriteWithFile:@"malphiteSplashFinished.png"];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	gameScene.layer.loadingSplashScreen.position = ccp(winSize.width/2, winSize.height/2);
	[gameScene.layer addChild:gameScene.layer.loadingSplashScreen];
	gameScene.layer.CutSceneNumber = 2;
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
	return;
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
