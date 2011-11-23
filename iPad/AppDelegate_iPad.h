//
//  AppDelegate_iPad.h
//  SpicyhorseGallary
//
//  Created by realalien on 11/18/11.
//  Copyright 2011 Spicyhorse Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate_iPad : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;

@end

