//
//  AppDelegate_iPad.h
//  companyNameGallary
//
//  Created by anonymous on 11/18/11.
//  Copyright 2011 companyName Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewController.h"

@interface AppDelegate_iPad : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIImageView *splashView;

	SplashViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;

@property (nonatomic, retain) IBOutlet SplashViewController *viewController;

@end

