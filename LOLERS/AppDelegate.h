//
//  AppDelegate.h
//  LOLERS
//
//  Created by MingYang Lu on 10/8/12.
//  Copyright Vanderbilt University 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
