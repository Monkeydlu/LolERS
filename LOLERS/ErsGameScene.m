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

@end

// ErsGameScene implementation
@implementation ErsGameLayer

@synthesize topDeck = topDeck;
@synthesize botDeck = botDeck;
@synthesize topMaxHealth = topMaxHealth;
@synthesize botMaxHealth = botMaxHealth;
@synthesize topCurHealth = topCurHealth;
@synthesize botCurHealth = botCurHealth;
@synthesize topHealthLabel = topHealthLabel;
@synthesize botHealthLabel = botHealthLabel;
@synthesize topDeckLabel = topDeckLabel;
@synthesize botDeckLabel = botDeckLabel;
@synthesize topDamageModifier = topDamageModifier;
@synthesize botDamageModifier = botDamageModifier;
@synthesize topName = topName;
@synthesize botName = botName;


/*
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ErsGameScene *layer = [ErsGameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
 */

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
		//*/
		/*
		myDeck = [NSMutableArray arrayWithObjects:	
				  @"S2.gif", @"S2.gif", @"S2.gif", @"S5.gif", @"S6.gif", @"S7.gif", @"S8.gif", @"S9.gif", @"ST.gif", @"SJ.gif", @"SQ.gif", @"SK.gif", @"SA.gif", 
				  @"D2.gif", @"D3.gif", @"D4.gif", @"D5.gif", @"D6.gif", @"D7.gif", @"D8.gif", @"D9.gif", @"DT.gif", @"DJ.gif", @"DQ.gif", @"DK.gif", @"DA.gif",
				  @"C4.gif", @"C6.gif", @"C3.gif", @"CJ.gif", @"C6.gif", @"C7.gif", @"C8.gif", @"C9.gif", @"CT.gif", @"CJ.gif", @"CQ.gif", @"CK.gif", @"CA.gif", 
				  @"H2.gif", @"H3.gif", @"H4.gif", @"H5.gif", @"H6.gif", @"H7.gif", @"H8.gif", @"H9.gif", @"HT.gif", @"HJ.gif", @"HQ.gif", @"HK.gif", @"HA.gif", nil];
		int count = [myDeck count]; 
		*/
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
		cardAngle = 0;
		delay = 0.9;
		
		/*
		topMaxHealth = 0;
		topCurHealth = topMaxHealth;
		botMaxHealth = 0;
		botCurHealth = botMaxHealth;
		topDamageModifier = 2;
		botDamageModifier = 2;
		*/
		
		computerFlipCardSelector = @selector(computerFlipCard);
		royalCardCollectSelector = @selector(royalCardCollect);
		compSlapCardSelector = @selector(compSlapCard);
		cleanUpNoticeSelector = @selector(cleanUpNotice);
		
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"click.caf"];
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		flipButton = [CCSprite spriteWithFile:@"FlipUp.png"];
		flipButton.position = ccp(winSize.width - 70, 40);
		[self addChild:flipButton];
		
		slapButton = [CCSprite spriteWithFile:@"SlapUp.png"];
		slapButton.position = ccp(70, 40);
		[self addChild:slapButton];
		/*
		flipButtonTop = [CCSprite spriteWithFile:@"flip.jpeg"];
		flipButtonTop.position = ccp(70, winSize.height - 40);
		[self addChild:flipButtonTop];
		
		slapButtonTop = [CCSprite spriteWithFile:@"slap.jpeg"];
		slapButtonTop.position = ccp(winSize.width - 70, winSize.height - 40);
		[self addChild:slapButtonTop];
		*/
		
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
					
					//[self removeChild:cardBot cleanup:YES];
					//[self removeChild:cardTop cleanup:YES];
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
					
					NSLog (@"BOT SLAPS!");
					NSLog (@"myDeck : %u", [myDeck count]);
					NSLog (@"topDeck: %u", [topDeck count]);
					NSLog (@"botDeck: %u", [botDeck count]);
					
					[topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", topName, [topDeck count]]];
					[botDeckLabel setString:[NSString stringWithFormat:@"%@: %u", botName, [botDeck count]]];
					[notificationLabel setString:[NSString stringWithFormat:@"%@ Slaps!", botName]];
					[self performSelector:cleanUpNoticeSelector withObject:nil afterDelay:.5];
					[self checkForGameOver];
				}else{
					
					[topDeck addObject:[botDeck objectAtIndex:0]];
					[botDeck removeObjectAtIndex:0];
					
					[topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", topName, [topDeck count]]];
					[botDeckLabel setString:[NSString stringWithFormat:@"%@: %u", botName, [botDeck count]]];
					[notificationLabel setString:[NSString stringWithFormat:@"%@ PENALTY!", botName]];
					[self performSelector:cleanUpNoticeSelector withObject:nil afterDelay:.5];
					
					botCurHealth = botCurHealth - 5;
					[topHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", topCurHealth, topMaxHealth]];
					[botHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", botCurHealth, botMaxHealth]];
					
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
					
					//[self removeChild:cardBot cleanup:YES];
					//[self removeChild:cardTop cleanup:YES];
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
					
					
					NSLog (@"BOT SLAPS!");
					NSLog (@"myDeck : %u", [myDeck count]);
					NSLog (@"topDeck: %u", [topDeck count]);
					NSLog (@"botDeck: %u", [botDeck count]);
					[topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", topName, [topDeck count]]];
					[botDeckLabel setString:[NSString stringWithFormat:@"%@: %u", botName, [botDeck count]]];
					[notificationLabel setString:[NSString stringWithFormat:@"%@ Slaps!", botName]];
					[self performSelector:cleanUpNoticeSelector withObject:nil afterDelay:.5];
					[self checkForGameOver];
				}else{
					
					[topDeck addObject:[botDeck objectAtIndex:0]];
					[botDeck removeObjectAtIndex:0];
					
					[topDeckLabel setString:[NSString stringWithFormat:@"%@: %u", topName, [topDeck count]]];
					[botDeckLabel setString:[NSString stringWithFormat:@"%@: %u", botName, [botDeck count]]];
					[notificationLabel setString:[NSString stringWithFormat:@"%@ PENALTY!", botName]];
					[self performSelector:cleanUpNoticeSelector withObject:nil afterDelay:.5];
					
					botCurHealth = botCurHealth - 5;
					
					[topHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", topCurHealth, topMaxHealth]];
					[botHealthLabel setString:[NSString stringWithFormat:@"[%d / %d]", botCurHealth, botMaxHealth]];
					
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
		
		if (playerTurn == true && playerFlipButtonActive == true) {
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
	

}


- (void)tapMoveAt:(CGPoint)location {
	return;
}

- (void)tapUpAt:(CGPoint)location {
	
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
		GameOverScene *gameOverScene = [GameOverScene node];
		[gameOverScene.layer.label setString:@"You Win!"];
		[[CCDirector sharedDirector] replaceScene:gameOverScene];
	}
	if (botCurHealth <= 0 || [botDeck count] == 0) {
		//You Lose.
		GameOverScene *gameOverScene = [GameOverScene node];
		[gameOverScene.layer.label setString:@"You Lose!"];
		[[CCDirector sharedDirector] replaceScene:gameOverScene];
	}
	
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
	[self performSelector:computerFlipCardSelector withObject:nil afterDelay:delay];
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
		
		NSLog (@"TOP WINS!");
		[notificationLabel setString:[NSString stringWithFormat:@"%@ Wins!", topName]];
		[self performSelector:cleanUpNoticeSelector withObject:nil afterDelay:.5];
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
		
		NSLog (@"BOT WINS!");
		[notificationLabel setString:[NSString stringWithFormat:@"%@ Wins!", botName]];
		[self performSelector:cleanUpNoticeSelector withObject:nil afterDelay:.5];
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
		
		[myDeck removeAllObjects];
		NSLog (@"TOP SLAPS!");
		[notificationLabel setString:[NSString stringWithFormat:@"%@ Slaps!", topName]];
		[self performSelector:cleanUpNoticeSelector withObject:nil afterDelay:.5];
		
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
		
		[self computerTurn];
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
		if(cardAngle == 180){
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
					[self performSelector:compSlapCardSelector withObject:nil afterDelay:delay*0.7];
			
				}
			}else{
				if ([topCard characterAtIndex:1] == [secCard characterAtIndex:1]) {
					
					isSlapable = true;
					[self performSelector:compSlapCardSelector withObject:nil afterDelay:delay*0.7];
					
				}
			}
			
		}
		
		if (turnCount == 0 && royalPlayed == true && playedRoyal == false && isSlapable == false) {
			playerFlipButtonActive = false;
			[self performSelector:royalCardCollectSelector withObject:nil afterDelay:delay/2];
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
		if(cardAngle == 180){
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
					[self performSelector:compSlapCardSelector withObject:nil afterDelay:delay];
					
				}
			}else{
				if ([topCard characterAtIndex:1] == [secCard characterAtIndex:1]) {
					
					isSlapable = true;
					[self performSelector:compSlapCardSelector withObject:nil afterDelay:delay];
					
				}
			}
			
		}
		
		if (turnCount == 1 && royalPlayed == true && playedRoyal == false && isSlapable == false) {
			playerFlipButtonActive = false;
			[self performSelector:royalCardCollectSelector withObject:nil afterDelay:delay/2];
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
