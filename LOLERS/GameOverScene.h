//
//  GameOverScene.h
//  spaceShooter
//
//  Created by MingYang Lu on 5/29/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor {
	CCLabelTTF *_label;
}
@property (nonatomic, retain) CCLabelTTF *label;
@end

@interface GameOverScene : CCScene {
	GameOverLayer *_layer;
}
@property (nonatomic, retain) GameOverLayer *layer;
@end