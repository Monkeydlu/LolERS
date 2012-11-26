//
//  StartScreenSceen.m
//  LOLERS
//
//  Created by MingYang Lu on 11/25/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "StartScreenScene.h"
#import "CharacterSelectionScene.h"

@interface StartScreenScene()

- (void) newGameSelected: (CCMenuItem  *) menuItem;

@end

@implementation StartScreenScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StartScreenScene *layer = [StartScreenScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	
	if( (self=[super initWithColor:ccc4(255, 255,0,255)] )) {
		
		CCMenuItemImage * newGameMenuItem = [CCMenuItemImage itemFromNormalImage:@"NewGameButton.png"
															 selectedImage: @"NewGameButton_selected.png"
																	target:self
																  selector:@selector(newGameSelected:)];
		
		CCMenu * myMenu = [CCMenu menuWithItems:newGameMenuItem, nil];
		[myMenu alignItemsVertically];
		[self addChild:myMenu];
		
	}
	
	self.isTouchEnabled = YES;
	return self;
}

- (void) newGameSelected: (CCMenuItem  *) menuItem 
{
	NSLog(@"new game was selected");
	
	[[CCDirector sharedDirector] replaceScene:[CharacterSelectionScene scene]];

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
