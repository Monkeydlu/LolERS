//
//  ErsGameScene.m
//  LOLERS
//
//  Created by MingYang Lu on 10/8/12.
//  Copyright Vanderbilt University 2012. All rights reserved.
//


// Import the interfaces
#import "ErsGameScene.h"
#import "CCTouchDispatcher.h"
#import "GameConfig.h"
#import "SimpleAudioEngine.h"
#import "CutScene.h"
#import "GameOverScene.h"


@implementation ErsGameScene
@synthesize layer = _layer;

- (id)init {
	
	if ((self = [super init])) {
		self.layer = [ErsGameLayer node];
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


@interface ErsGameLayer()

- (void)tapDownAt:(CGPoint)location;
- (void)tapMoveAt:(CGPoint)location;
- (void)tapUpAt:(CGPoint)location;
- (void)flipCard;
- (void)computerTurn;
- (void)computerFlipCard;
- (void)royalCardCollect;
- (void)compSlapCard;
- (void)cleanUpCardGraphics;
- (void)cleanUpNotice;
- (void)checkForGameOver;
- (void)setUpGame;
- (void) asheSelectedLoadCutScene;
- (void) malphiteSelectedLoadCutScene;

@end

// ErsGameScene implementation
@implementation ErsGameLayer

@synthesize loadingSplashScreen = loadingSplashScreen;
@synthesize characterSelected = characterSelected;
@synthesize currentStageLevel = currentStageLevel;

// on "init" you need to initialize your instance
-(id) init
{
	
	if( (self=[super initWithColor:ccc4(255, 255,0,255)] )) {
		///*
		myDeck = [NSMutableArray arrayWithObjects:	
				  @"S2.gif", @"S3.gif", @"S4.gif", @"S5.gif", @"S6.gif", @"S7.gif", @"S8.gif", @"S9.gif", @"ST.gif", @"SJ.gif", @"SQ.gif", @"SK.gif", @"SA.gif", 
				  @"D2.gif", @"D3.gif", @"D4.gif", @"D5.gif", @"D6.gif", @"D7.gif", @"D8.gif", @"D9.gif", @"DT.gif", @"DJ.gif", @"DQ.gif", @"DK.gif", @"DA.gif",
				  @"C2.gif", @"C3.gif", @"C4.gif", @"C5.gif", @"C6.gif", @"C7.gif", @"C8.gif", @"C9.gif", @"CT.gif", @"CJ.gif", @"CQ.gif", @"CK.gif", @"CA.gif", 
				  @"H2.gif", @"H3.gif", @"H4.gif", @"H5.gif", @"H6.gif", @"H7.gif", @"H8.gif", @"H9.gif", @"HT.gif", @"HJ.gif", @"HQ.gif", @"HK.gif", @"HA.gif", nil];
		
		int count = [myDeck count]; 
		
		for (int i = 1; i < count; ++i) {
			int j = arc4random() % i;
			[myDeck exchangeObjectAtIndex:j withObjectAtIndex:i];
		}
		
		for (int i = 1; i < count; ++i) {
			int j = arc4random() % i;
			[myDeck exchangeObjectAtIndex:j withObjectAtIndex:i];
		}

		topDeck = [[NSMutableArray alloc] init];
		botDeck = [[NSMutableArray alloc] init];
		cardStackGraphics = [[NSMutableArray alloc] init];
		
		for (int i = 0; i < count/2; ++i) {
			[topDeck addObject: [myDeck objectAtIndex:i]];
		}
		
		for (int i = count / 2; i < count; ++i) {
			[botDeck addObject: [myDeck objectAtIndex:i]];
		}
		
		[myDeck removeAllObjects];
		myDeck = [[NSMutableArray alloc] init];
		
		turnCount = 1;
		playerTurn = true;
		royalPlayed = false;
		playerSlapped = false;
		playerFlipButtonActive = true;
		gameNotSetUp = true;
		cardAngle = 0;
		delay = 0.9;
		
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"click.caf"];
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		topBustImage = [CCSprite spriteWithFile:@"MinionBust.png"];
		topBustImage.position = ccp(70, 170);
		[self addChild:topBustImage];
		botBustImage = [CCSprite spriteWithFile:@"MinionBust.png"];
		botBustImage.position = ccp(410, 170);
		[self addChild:botBustImage];
		
		flipButton = [CCSprite spriteWithFile:@"FlipUp.png"];
		flipButton.position = ccp(winSize.width - 70, 40);
		[self addChild:flipButton];
		
		slapButton = [CCSprite spriteWithFile:@"SlapUp.png"];
		slapButton.position = ccp(70, 40);
		[self addChild:slapButton];

		topDeckLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@: %u", topName, [topDeck count]] fontName:@"Arial" fontSize:20];
		topDeckLabel.color = ccc3(0, 0, 0);
		[topDeckLabel setPosition: ccp(70, 300)];
		[self addChild:topDeckLabel];
		
		botDeckLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@: %u", botName, [botDeck count]] fontName:@"Arial" fontSize:20];
		botDeckLabel.color = ccc3(0, 0, 0);
		[botDeckLabel setPosition: ccp(winSize.width - 70, 300)];
		[self addChild:botDeckLabel];
		
		turnLabel = [CCLabelTTF labelWithString:@"  turn >" fontName:@"Arial" fontSize:20];
		turnLabel.color = ccc3(0, 0, 0);
		[turnLabel setPosition: ccp(winSize.width/2, 300)];
		[self addChild:turnLabel];
		
		notificationLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:20];
		notificationLabel.color = ccc3(0, 0, 0);
		[notificationLabel setPosition: ccp(winSize.width/2, 50)];
		[self addChild:notificationLabel];
		
		topHealthLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"[%d / %d]", topCurHealth, topMaxHealth] fontName:@"Arial" fontSize:20];
		topHealthLabel.color = ccc3(0, 0, 0);
		[topHealthLabel setPosition: ccp(70, 275)];
		[self addChild:topHealthLabel];
		
		botHealthLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"[%d / %d]", botCurHealth, botMaxHealth] fontName:@"Arial" fontSize:20];
		botHealthLabel.color = ccc3(0, 0, 0);
		[botHealthLabel setPosition: ccp(winSize.width - 70, 275)];
		[self addChild:botHealthLabel];
		
		topHealth = [CCProgressTimer progressWithFile:@"healthBarGreen.png"];
		topHealth.type = kCCProgressTimerTypeHorizontalBarLR;
		topHealth.percentage = 100;
		topHealth.position = ccp(70, 250);
		[self addChild:topHealth];
		
		botHealth = [CCProgressTimer progressWithFile:@"healthBarGreen.png"];
		botHealth.type = kCCProgressTimerTypeHorizontalBarLR;
		botHealth.percentage = 100;
		botHealth.position = ccp(winSize.width - 70, 250);
		[self addChild:botHealth];
		
		
	}
	
	NSLog (@"myDeck : %u", [myDeck count]);
	NSLog (@"topDeck: %u", [topDeck count]);
	NSLog (@"botDeck: %u", [botDeck count]);
	
	self.isTouchEnabled = YES;	
	return self;
}


- (void)registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void)setUpGame{
	[self removeChild:loadingSplashScreen cleanup:YES];
	
	if (currentStageLevel == 1) {
		topName = @"Minion";
		topMaxHealth = 50;
		topCurHealth = 50;
		topDamageModifier = 2;
		delay = 0.9;
		[topBustImage setTexture:[[CCSprite spriteWithFile:@"MinionBust.png"]texture]];
		[topHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", topCurHealth, topMaxHealth]];
		[topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", topName, [topDeck count]]];
	}
	
	if (currentStageLevel == 2 && characterSelected == @"Ashe") {
		topName = @"Malphite";
		topMaxHealth = 70;
		topCurHealth = 70;
		topDamageModifier = 1.5;
		delay = 0.7;
		[topBustImage setTexture:[[CCSprite spriteWithFile:@"MalphiteBust.png"]texture]];
		[topHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", topCurHealth, topMaxHealth]];
		[topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", topName, [topDeck count]]];
	}
	
	if (currentStageLevel == 2 && characterSelected == @"Malphite") {
		topName = @"Malphite";
		topMaxHealth = 35;
		topCurHealth = 35;
		topDamageModifier = 2.5;
		delay = 0.7;
		[topBustImage setTexture:[[CCSprite spriteWithFile:@"AsheBust.png"]texture]];
		[topHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", topCurHealth, topMaxHealth]];
		[topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", topName, [topDeck count]]];
	}
	
	if (characterSelected == @"Ashe") {
		botName = @"Ashe";
		botMaxHealth = 35;
		botCurHealth = 35;
		botDamageModifier = 2.5;
		[botBustImage setTexture:[[CCSprite spriteWithFile:@"AsheBust.png"]texture]];
		[botHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", botCurHealth, botMaxHealth]];
		[botDeckLabel setString:[NSString stringWithFormat:@"%@: %u", botName, [botDeck count]]];
	}
	
	if (characterSelected == @"Malphite") {
		botName = @"Malphite";
		botMaxHealth = 70;
		botCurHealth = 70;
		botDamageModifier = 1.5;
		[botBustImage setTexture:[[CCSprite spriteWithFile:@"MalphiteBust.png"]texture]];
		[botHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", botCurHealth, botMaxHealth]];
		[botDeckLabel setString:[NSString stringWithFormat:@"%@: %u", botName, [botDeck count]]];
	}
	
}

- (void)tapDownAt:(CGPoint)location {
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	CGRect rect = CGRectMake(38, 8, 64, 64);
	if(CGRectContainsPoint(rect, location)) {
		
		NSLog (@"Pressed Slap");
		
		if([myDeck count] >= 2){
			NSString *topCard = [myDeck objectAtIndex:[myDeck count] - 1];
			NSString *secCard = [myDeck objectAtIndex:[myDeck count] - 2];
			
			
			
			if ([myDeck count] >= 3) {
				NSString *trdCard = [myDeck objectAtIndex:[myDeck count] - 3];
				if ([topCard characterAtIndex:1] == [secCard characterAtIndex:1]  || [topCard characterAtIndex:1] == [trdCard characterAtIndex:1]) {
					[self removeChild:slapButton cleanup:YES];
					slapButton = [CCSprite spriteWithFile:@"SlapDown.png"];
					slapButton.position = ccp(70, 40);
					[self addChild:slapButton];
					
					[self cleanUpCardGraphics];
					
					int damage = [myDeck count];
					
					for (int i = 0; i < [myDeck count]; i++) {
						[botDeck addObject:[myDeck objectAtIndex:i]];
					}
					
					[myDeck removeAllObjects];
					
					royalPlayed = false;
					turnCount = 1;
					playerTurn = true;
					[turnLabel setString:@"  turn >"];
					
					[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
					playerSlapped = true;
					
					damage = damage * botDamageModifier;
					topCurHealth = topCurHealth - damage;
					[topHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", topCurHealth, topMaxHealth]];
					[botHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", botCurHealth, botMaxHealth]];
					float temp = topCurHealth * 100/topMaxHealth;
					[topHealth setPercentage:temp];
					temp = botCurHealth * 100/botMaxHealth;
					[botHealth setPercentage:temp];
					
					NSLog (@"BOT SLAPS!");
					NSLog (@"myDeck : %u", [myDeck count]);
					NSLog (@"topDeck: %u", [topDeck count]);
					NSLog (@"botDeck: %u", [botDeck count]);
					
					[topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", topName, [topDeck count]]];
					[botDeckLabel setString:[NSString stringWithFormat:@"%@: %u", botName, [botDeck count]]];
					[notificationLabel setString:[NSString stringWithFormat:@"%@ Slaps!", botName]];
					[self performSelector:@selector(cleanUpNotice) withObject:nil afterDelay:.5];
					[self checkForGameOver];
				}else{
					
					[topDeck addObject:[botDeck objectAtIndex:0]];
					[botDeck removeObjectAtIndex:0];
					
					[topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", topName, [topDeck count]]];
					[botDeckLabel setString:[NSString stringWithFormat:@"%@: %u", botName, [botDeck count]]];
					[notificationLabel setString:[NSString stringWithFormat:@"%@ PENALTY!", botName]];
					[self performSelector:@selector(cleanUpNotice) withObject:nil afterDelay:.5];
					
					botCurHealth = botCurHealth - 5;
					[topHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", topCurHealth, topMaxHealth]];
					[botHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", botCurHealth, botMaxHealth]];
					float temp = topCurHealth * 100/topMaxHealth;
					[topHealth setPercentage:temp];
					temp = botCurHealth * 100/botMaxHealth;
					[botHealth setPercentage:temp];
					
					NSLog (@"BOT PENALTY!");
					NSLog (@"myDeck : %u", [myDeck count]);
					NSLog (@"topDeck: %u", [topDeck count]);
					NSLog (@"botDeck: %u", [botDeck count]);
					[self checkForGameOver];
				}
			}else{
				if ([topCard characterAtIndex:1] == [secCard characterAtIndex:1]) {
					[self removeChild:slapButton cleanup:YES];
					slapButton = [CCSprite spriteWithFile:@"SlapDown.png"];
					slapButton.position = ccp(70, 40);
					[self addChild:slapButton];
					
					[self cleanUpCardGraphics];
					
					int damage = [myDeck count];
					
					for (int i = 0; i < [myDeck count]; i++) {
						[botDeck addObject:[myDeck objectAtIndex:i]];
					}
					
					[myDeck removeAllObjects];
					
					royalPlayed = false;
					turnCount = 1;
					playerTurn = true;
					[turnLabel setString:@"  turn >"];
					
					[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
					playerSlapped = true;
					
					damage = damage * botDamageModifier; 
					topCurHealth = topCurHealth - damage;
					
					[topHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", topCurHealth, topMaxHealth]];
					[botHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", botCurHealth, botMaxHealth]];
					float temp = topCurHealth * 100/topMaxHealth;
					[topHealth setPercentage:temp];
					temp = botCurHealth * 100/botMaxHealth;
					[botHealth setPercentage:temp];
					
					NSLog (@"BOT SLAPS!");
					NSLog (@"myDeck : %u", [myDeck count]);
					NSLog (@"topDeck: %u", [topDeck count]);
					NSLog (@"botDeck: %u", [botDeck count]);
					[topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", topName, [topDeck count]]];
					[botDeckLabel setString:[NSString stringWithFormat:@"%@: %u", botName, [botDeck count]]];
					[notificationLabel setString:[NSString stringWithFormat:@"%@ Slaps!", botName]];
					[self performSelector:@selector(cleanUpNotice) withObject:nil afterDelay:.5];
					[self checkForGameOver];
				}else{
					
					[topDeck addObject:[botDeck objectAtIndex:0]];
					[botDeck removeObjectAtIndex:0];
					
					[topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", topName, [topDeck count]]];
					[botDeckLabel setString:[NSString stringWithFormat:@"%@: %u", botName, [botDeck count]]];
					[notificationLabel setString:[NSString stringWithFormat:@"%@ PENALTY!", botName]];
					[self performSelector:@selector(cleanUpNotice) withObject:nil afterDelay:.5];
					
					botCurHealth = botCurHealth - 5;
					
					[topHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", topCurHealth, topMaxHealth]];
					[botHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", botCurHealth, botMaxHealth]];
					float temp = topCurHealth * 100/topMaxHealth;
					[topHealth setPercentage:temp];
					temp = botCurHealth * 100/botMaxHealth;
					[botHealth setPercentage:temp];
					
					NSLog (@"BOT PENALTY!");
					NSLog (@"myDeck : %u", [myDeck count]);
					NSLog (@"topDeck: %u", [topDeck count]);
					NSLog (@"botDeck: %u", [botDeck count]);
					[self checkForGameOver];
				}
			}
			
		}
		
	}
	
	CGRect rect2 = CGRectMake(winSize.width - 102, 8, 64, 64);
	if(CGRectContainsPoint(rect2, location)) {
		
		NSLog (@"Pressed Flip");
		
		if (playerTurn == true && playerFlipButtonActive == true && gameNotSetUp == false) {
			//playerSlapped = true;
			CGSize winSize = [[CCDirector sharedDirector] winSize];
			[self removeChild:flipButton cleanup:YES];
			flipButton = [CCSprite spriteWithFile:@"FlipDown.png"];
			flipButton.position = ccp(winSize.width - 70, 40);
			[self addChild:flipButton];
			
			[self flipCard];
			if(playerTurn == false){
				[self computerTurn];
			}
		}
			
	}
	
	if (gameNotSetUp) {
		[self setUpGame];
		gameNotSetUp = false;
	}
	

}


- (void)tapMoveAt:(CGPoint)location {
	return;
}

- (void)tapUpAt:(CGPoint)location {
	[self removeChild:loadingSplashScreen cleanup:YES];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	[self removeChild:flipButton cleanup:YES];
	flipButton = [CCSprite spriteWithFile:@"FlipUp.png"];
	flipButton.position = ccp(winSize.width - 70, 40);
	[self addChild:flipButton];
	
	[self removeChild:slapButton cleanup:YES];
	slapButton = [CCSprite spriteWithFile:@"SlapUp.png"];
	slapButton.position = ccp(70, 40);
	[self addChild:slapButton];
	
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

- (void)checkForGameOver{
	if (topCurHealth <= 0 || [topDeck count] == 0) {
		//You Win.
		CutSceneScene *nextScene = [CutSceneScene node];
		if (characterSelected == @"Ashe") {
			CGSize winSize = [[CCDirector sharedDirector] winSize];
			
			CCSprite* SplashScreen = [CCSprite spriteWithFile:@"AsheSplash.png"];
			SplashScreen.position = ccp(winSize.width/2, winSize.height/2);
			[self addChild:SplashScreen];
			
			[self performSelector:@selector(asheSelectedLoadCutScene) withObject:nil afterDelay:0.1];

		}else{
			CGSize winSize = [[CCDirector sharedDirector] winSize];
			
			CCSprite* SplashScreen = [CCSprite spriteWithFile:@"malphiteSplash.png"];
			SplashScreen.position = ccp(winSize.width/2, winSize.height/2);
			[self addChild:SplashScreen];
			
			[self performSelector:@selector(malphiteSelectedLoadCutScene) withObject:nil afterDelay:0.1];

		}
		[[CCDirector sharedDirector] replaceScene:nextScene];
	}
	if (botCurHealth <= 0 || [botDeck count] == 0) {
		//You Lose.
		GameOverScene *gameOverScene = [GameOverScene node];
		[gameOverScene.layer.label setString:@"You Lose!"];
		[[CCDirector sharedDirector] replaceScene:gameOverScene];
	}
	
}

- (void) asheSelectedLoadCutScene{
	CutSceneScene *gameScene = [CutSceneScene node];
	
	gameScene.layer.loadingSplashScreen = [CCSprite spriteWithFile:@"AsheSplashFinished.png"];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	gameScene.layer.loadingSplashScreen.position = ccp(winSize.width/2, winSize.height/2);
	[gameScene.layer addChild:gameScene.layer.loadingSplashScreen];
	gameScene.layer.CutSceneNumber = currentStageLevel + 2;
	[[CCDirector sharedDirector] replaceScene:gameScene];
}

- (void) malphiteSelectedLoadCutScene{
	CutSceneScene *gameScene = [CutSceneScene node];
	
	gameScene.layer.loadingSplashScreen = [CCSprite spriteWithFile:@"malphiteSplashFinished.png"];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	gameScene.layer.loadingSplashScreen.position = ccp(winSize.width/2, winSize.height/2);
	[gameScene.layer addChild:gameScene.layer.loadingSplashScreen];
	gameScene.layer.CutSceneNumber = currentStageLevel + 3;
	[[CCDirector sharedDirector] replaceScene:gameScene];
}

- (void)cleanUpCardGraphics{
	for (CCSprite *target in cardStackGraphics) {
		[self removeChild:target cleanup:YES];
	}
	[cardStackGraphics removeAllObjects];
	cardAngle = 0;
}

- (void)cleanUpNotice{
	[notificationLabel setString:@""];
}

- (void)computerTurn{
	if (playerTurn == true) {
		return;
	}
	[self performSelector:@selector(computerFlipCard) withObject:nil afterDelay:delay];
	return;
}

- (void)computerFlipCard{
	if (playerTurn == true) {
		return;
	}
	playerSlapped = false;
	[self flipCard];
	if(playerTurn == false){
		[self computerTurn];
	}
	return;
}

- (void)royalCardCollect{
	//[self removeChild:cardBot cleanup:YES];
	//[self removeChild:cardTop cleanup:YES];
	[self cleanUpCardGraphics];
	
	if (turnCount == 0) {
		int damage = [myDeck count];
		
		for (int i = 0; i < [myDeck count]; i++) {
			[topDeck addObject:[myDeck objectAtIndex:i]];
		}
		
		damage = damage * topDamageModifier / 2;
		botCurHealth = botCurHealth - damage;
		
		[topHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", topCurHealth, topMaxHealth]];
		[botHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", botCurHealth, botMaxHealth]];
		float temp = topCurHealth * 100/topMaxHealth;
		[topHealth setPercentage:temp];
		temp = botCurHealth * 100/botMaxHealth;
		[botHealth setPercentage:temp];
		
		NSLog (@"TOP WINS!");
		[notificationLabel setString:[NSString stringWithFormat:@"%@ Wins!", topName]];
		[self performSelector:@selector(cleanUpNotice) withObject:nil afterDelay:.5];
		[self checkForGameOver];
	}else{
		int damage = [myDeck count];
		for (int i = 0; i < [myDeck count]; i++) {
			[botDeck addObject:[myDeck objectAtIndex:i]];
		}
		
		damage = damage * botDamageModifier / 2;
		topCurHealth = topCurHealth - damage;
		
		[topHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", topCurHealth, topMaxHealth]];
		[botHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", botCurHealth, botMaxHealth]];
		float temp = topCurHealth * 100/topMaxHealth;
		[topHealth setPercentage:temp];
		temp = botCurHealth * 100/botMaxHealth;
		[botHealth setPercentage:temp];
		
		NSLog (@"BOT WINS!");
		[notificationLabel setString:[NSString stringWithFormat:@"%@ Wins!", botName]];
		[self performSelector:@selector(cleanUpNotice) withObject:nil afterDelay:.5];
		[self checkForGameOver];
	}
	
	[myDeck removeAllObjects];
	
	royalPlayed = false;
	playerFlipButtonActive = true;
	
	NSLog (@"myDeck : %u", [myDeck count]);
	NSLog (@"topDeck: %u", [topDeck count]);
	NSLog (@"botDeck: %u", [botDeck count]);
	[topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", topName, [topDeck count]]];
	[botDeckLabel setString:[NSString stringWithFormat:@"%@: %u", botName, [botDeck count]]];

}

- (void)compSlapCard{
	bool goAhead = false;
	if([myDeck count] >= 2){
		NSString *topCard = [myDeck objectAtIndex:[myDeck count] - 1];
		NSString *secCard = [myDeck objectAtIndex:[myDeck count] - 2];
		
		if ([myDeck count] >= 3) {
			NSString *trdCard = [myDeck objectAtIndex:[myDeck count] - 3];
			if ([topCard characterAtIndex:1] == [secCard characterAtIndex:1]  || [topCard characterAtIndex:1] == [trdCard characterAtIndex:1]) {
				goAhead = true;
			}
		}else{
			if ([topCard characterAtIndex:1] == [secCard characterAtIndex:1]) {
				goAhead = true;
			}
		}
		
	}
	
	if(goAhead){
		if (playerSlapped == true) {
			playerSlapped = false;
			return;
		}
		//[self removeChild:cardBot cleanup:YES];
		//[self removeChild:cardTop cleanup:YES];
		[self cleanUpCardGraphics];
		
		int damage = [myDeck count];
		
		for (int i = 0; i < [myDeck count]; i++) {
			[topDeck addObject:[myDeck objectAtIndex:i]];
		}
		
		damage = damage * topDamageModifier;
		botCurHealth = botCurHealth - damage;
		
		[topHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", topCurHealth, topMaxHealth]];
		[botHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", botCurHealth, botMaxHealth]];
		float temp = topCurHealth * 100/topMaxHealth;
		[topHealth setPercentage:temp];
		temp = botCurHealth * 100/botMaxHealth;
		[botHealth setPercentage:temp];
		
		[myDeck removeAllObjects];
		NSLog (@"TOP SLAPS!");
		[notificationLabel setString:[NSString stringWithFormat:@"%@ Slaps!", topName]];
		[self performSelector:@selector(cleanUpNotice) withObject:nil afterDelay:.5];
		
		NSLog (@"myDeck : %u", [myDeck count]);
		NSLog (@"topDeck: %u", [topDeck count]);
		NSLog (@"botDeck: %u", [botDeck count]);
		[topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", topName, [topDeck count]]];
		[botDeckLabel setString:[NSString stringWithFormat:@"%@: %u", botName, [botDeck count]]];
		[self checkForGameOver];
		royalPlayed = false;
		turnCount = 0;
		
		playerTurn = false;
		[turnLabel setString:@"< turn  "];
		
		[self performSelector:@selector(computerTurn) withObject:nil afterDelay:.7];
	}
	
}

-(void)flipCard{
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	if(turnCount > 0){
		//[self removeChild:cardBot cleanup:YES];
		NSString *tempCard = [botDeck objectAtIndex:0];
		cardBot = [CCSprite spriteWithFile: [botDeck objectAtIndex:0]];
		[myDeck addObject:[botDeck objectAtIndex:0]];
		
		NSLog(@"Bot: %c", [tempCard characterAtIndex:1]);
		
		bool playedRoyal = false;
		
		if([tempCard characterAtIndex:1] == 'J'){
			turnCount = 0;
			royalPlayed = true;
			playedRoyal = true;
		}else if([tempCard characterAtIndex:1] == 'Q'){
			turnCount = -1;
			royalPlayed = true;
			playedRoyal = true;
		}else if([tempCard characterAtIndex:1] == 'K'){
			turnCount = -2;
			royalPlayed = true;
			playedRoyal = true;
		}else if([tempCard characterAtIndex:1] == 'A'){
			turnCount = -3;
			royalPlayed = true;
			playedRoyal = true;
		}else{
			turnCount--;
		}
		
		[botDeck removeObjectAtIndex:0];
		
		cardBot.position = ccp( winSize.width/2, winSize.height/2 );
		cardBot.rotation = cardAngle;
		cardAngle =  cardAngle + 60;
		if(cardAngle == 360){
			cardAngle = 0;
		}
		[cardStackGraphics addObject:cardBot];
		[self addChild:cardBot];
        //[cardsSpritesBatch addChild:cardBot];
		
		bool isSlapable = false;
		
		if([myDeck count] >= 2){
			NSString *topCard = [myDeck objectAtIndex:[myDeck count] - 1];
			NSString *secCard = [myDeck objectAtIndex:[myDeck count] - 2];
			
			if ([myDeck count] >= 3) {
				NSString *trdCard = [myDeck objectAtIndex:[myDeck count] - 3];
				if ([topCard characterAtIndex:1] == [secCard characterAtIndex:1]  || [topCard characterAtIndex:1] == [trdCard characterAtIndex:1]) {
					
					isSlapable = true;
					[self performSelector:@selector(compSlapCard) withObject:nil afterDelay:delay*0.7];
			
				}
			}else{
				if ([topCard characterAtIndex:1] == [secCard characterAtIndex:1]) {
					
					isSlapable = true;
					[self performSelector:@selector(compSlapCard) withObject:nil afterDelay:delay*0.7];
					
				}
			}
			
		}
		
		if (turnCount == 0 && royalPlayed == true && playedRoyal == false && isSlapable == false) {
			playerFlipButtonActive = false;
			[self performSelector:@selector(royalCardCollect) withObject:nil afterDelay:delay/2];
		}
		
	}else{
		//[self removeChild:cardTop cleanup:YES];
		NSString *tempCard = [topDeck objectAtIndex:0];
		cardTop = [CCSprite spriteWithFile: [topDeck objectAtIndex:0]];
		[myDeck addObject:[topDeck objectAtIndex:0]];
		
		NSLog(@"Top: %c", [tempCard characterAtIndex:1]);
		
		bool playedRoyal = false;
		
		if([tempCard characterAtIndex:1] == 'J'){
			turnCount = 1;
			royalPlayed = true;
			playedRoyal = true;
		}else if([tempCard characterAtIndex:1] == 'Q'){
			turnCount = 2;
			royalPlayed = true;
			playedRoyal = true;
		}else if([tempCard characterAtIndex:1] == 'K'){
			turnCount = 3;
			royalPlayed = true;
			playedRoyal = true;
		}else if([tempCard characterAtIndex:1] == 'A'){
			turnCount = 4;
			royalPlayed = true;
			playedRoyal = true;
		}else{
			turnCount++;
		}
		
		[topDeck removeObjectAtIndex:0];

		cardTop.position = ccp( winSize.width/2, winSize.height/2 );
		cardTop.rotation = cardAngle;
		cardAngle = cardAngle + 60;
		if(cardAngle == 360){
			cardAngle = 0;
		}
		[cardStackGraphics addObject:cardTop];
        [self addChild:cardTop];
		
		bool isSlapable = false;
		
		if([myDeck count] >= 2){
			NSString *topCard = [myDeck objectAtIndex:[myDeck count] - 1];
			NSString *secCard = [myDeck objectAtIndex:[myDeck count] - 2];
			
			if ([myDeck count] >= 3) {
				NSString *trdCard = [myDeck objectAtIndex:[myDeck count] - 3];
				if ([topCard characterAtIndex:1] == [secCard characterAtIndex:1]  || [topCard characterAtIndex:1] == [trdCard characterAtIndex:1]) {
					
					isSlapable = true;
					[self performSelector:@selector(compSlapCard) withObject:nil afterDelay:delay];
					
				}
			}else{
				if ([topCard characterAtIndex:1] == [secCard characterAtIndex:1]) {
					
					isSlapable = true;
					[self performSelector:@selector(compSlapCard) withObject:nil afterDelay:delay];
					
				}
			}
			
		}
		
		if (turnCount == 1 && royalPlayed == true && playedRoyal == false && isSlapable == false) {
			playerFlipButtonActive = false;
			[self performSelector:@selector(royalCardCollect) withObject:nil afterDelay:delay/2];
		}
		
	}
	
	if(turnCount > 0){
		playerTurn = true;
		[turnLabel setString:@"  turn >"];
	}else{
		playerTurn = false;
		[turnLabel setString:@"< turn  "];
	}
	
	NSLog (@"myDeck : %u", [myDeck count]);
	NSLog (@"topDeck: %u", [topDeck count]);
	NSLog (@"botDeck: %u", [botDeck count]);
	[topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", topName, [topDeck count]]];
	[botDeckLabel setString:[NSString stringWithFormat:@"%@: %u", botName, [botDeck count]]];
	[self checkForGameOver];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[myDeck release];
	[topDeck release];
	[botDeck release];
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
