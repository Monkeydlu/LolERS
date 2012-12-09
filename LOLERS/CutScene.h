//
//  CutScene.h
//  LOLERS
//
//  Created by MingYang Lu on 12/2/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "cocos2d.h"

@interface CutSceneLayer : CCLayerColor
{
	int characterSelected;
	int cutSceneStoryPage;
	CCSprite * loadingSplashScreen;
	bool displayingStory;
	CCLabelTTF * textWindowLabel;
}
@property int CutSceneNumber;
@property (retain)CCSprite * loadingSplashScreen;

@end

@interface CutSceneScene : CCScene{
	CutSceneLayer * _layer;
}
@property (nonatomic, retain) CutSceneLayer *layer;

@end
