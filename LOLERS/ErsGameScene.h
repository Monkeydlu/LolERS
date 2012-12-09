//
//  ErsGameScene.h
//  LOLERS
//
//  Created by MingYang Lu on 10/8/12.
//  Copyright Vanderbilt University 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// ErsGameScene
@interface ErsGameLayer : CCLayerColor
{
	NSMutableArray *myDeck;
	NSMutableArray *topDeck;
	NSMutableArray *botDeck;
	NSMutableArray *cardStackGraphics;
	CCSprite * cardBot;
	CCSprite * cardTop;
	CCSprite *flipButton;
	CCSprite *slapButton;
	CCSprite *flipButtonTop;
	CCSprite *slapButtonTop;
	CCSprite *loadingSplashScreen;
	CCSprite *topBustImage;
	CCSprite *botBustImage;
	CCLabelTTF * topDeckLabel;
	CCLabelTTF * botDeckLabel;
	CCLabelTTF * turnLabel;
	CCLabelTTF * notificationLabel;
	CCLabelTTF * topHealthLabel;
	CCLabelTTF * botHealthLabel;
	int turnCount;
	bool playerTurn;
	bool royalPlayed;
	bool playerSlapped;
	bool playerFlipButtonActive;
	bool gameNotSetUp;
	float cardAngle;
	double delay;
	int topMaxHealth;
	int botMaxHealth;
	int topCurHealth;
	int botCurHealth;
	float topDamageModifier;
	float botDamageModifier;
	NSString * topName;
	NSString * botName;
	CCProgressTimer *botHealth;
	CCProgressTimer *topHealth;
	NSString * characterSelected;
	int currentStageLevel;
}
@property (retain) CCSprite * loadingSplashScreen;
@property (retain) NSString * characterSelected;
@property int currentStageLevel;
@end


@interface ErsGameScene : CCScene {
	ErsGameLayer *_layer;
}
@property (nonatomic, retain) ErsGameLayer *layer;
@end


