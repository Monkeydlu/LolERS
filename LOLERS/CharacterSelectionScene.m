//
//  CharacterSelectionScene.m
//  LOLERS
//
//  Created by MingYang Lu on 11/25/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "CharacterSelectionScene.h"
#import "ErsGameScene.h"

@interface CharacterSelectionScene()

- (void) ascheSelected: (CCMenuItem  *) menuItem;
- (void) malphiteSelected: (CCMenuItem  *) menuItem;

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
		
		CCMenuItemImage * asheSelect = [CCMenuItemImage itemFromNormalImage:@"AscheButton.png"
																   selectedImage: @"AscheButton_selected.png"
																		  target:self
																		selector:@selector(ascheSelected:)];
		
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

- (void) ascheSelected: (CCMenuItem  *) menuItem 
{
	NSLog(@"new game was selected");
	
	ErsGameScene *gameScene = [ErsGameScene node];
	
	gameScene.layer.topName = @"Minion";
	gameScene.layer.topMaxHealth = 50;
	gameScene.layer.topCurHealth = 50;
	gameScene.layer.topDamageModifier = 2;
	
	gameScene.layer.botName = @"Ashe";
	gameScene.layer.botMaxHealth = 40;
	gameScene.layer.botCurHealth = 40;
	gameScene.layer.botDamageModifier = 2.5;
	
	[gameScene.layer.topHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", gameScene.layer.topCurHealth, gameScene.layer.topMaxHealth]];
	[gameScene.layer.botHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", gameScene.layer.botCurHealth, gameScene.layer.botMaxHealth]];
	[gameScene.layer.topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", gameScene.layer.topName, [gameScene.layer.topDeck count]]];
	[gameScene.layer.botDeckLabel setString:[NSString stringWithFormat:@"%@: %u", gameScene.layer.botName, [gameScene.layer.botDeck count]]];
	
	[[CCDirector sharedDirector] replaceScene:gameScene];
	
}

- (void) malphiteSelected: (CCMenuItem  *) menuItem 
{
	NSLog(@"new game was selected");
	
	ErsGameScene *gameScene = [ErsGameScene node];
	
	gameScene.layer.topName = @"Minion";
	gameScene.layer.topMaxHealth = 50;
	gameScene.layer.topCurHealth = 50;
	gameScene.layer.topDamageModifier = 2;
	
	gameScene.layer.botName = @"Malphite";
	gameScene.layer.botMaxHealth = 65;
	gameScene.layer.botCurHealth = 65;
	gameScene.layer.botDamageModifier = 1.8;
	
	[gameScene.layer.topHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", gameScene.layer.topCurHealth, gameScene.layer.topMaxHealth]];
	[gameScene.layer.botHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", gameScene.layer.botCurHealth, gameScene.layer.botMaxHealth]];
	[gameScene.layer.topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", gameScene.layer.topName, [gameScene.layer.topDeck count]]];
	[gameScene.layer.botDeckLabel setString:[NSString stringWithFormat:@"%@: %u", gameScene.layer.botName, [gameScene.layer.botDeck count]]];
	
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
