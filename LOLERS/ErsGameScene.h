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
	SEL computerFlipCardSelector;
	SEL royalCardCollectSelector;
	SEL compSlapCardSelector;
	SEL cleanUpNoticeSelector;
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
}
@property NSMutableArray *topDeck;
@property NSMutableArray *botDeck;
@property int topMaxHealth;
@property int botMaxHealth;
@property int topCurHealth;
@property int botCurHealth;
@property CCLabelTTF * topHealthLabel;
@property CCLabelTTF * botHealthLabel;
@property CCLabelTTF * topDeckLabel;
@property CCLabelTTF * botDeckLabel;
@property float topDamageModifier;
@property float botDamageModifier;
@property NSString * topName;
@property NSString * botName;


// returns a CCScene that contains the ErsGameScene as the only child
//+(CCScene *) scene;

@end


@interface ErsGameScene : CCScene {
	ErsGameLayer *_layer;
}
@property (nonatomic, retain) ErsGameLayer *layer;
@end


