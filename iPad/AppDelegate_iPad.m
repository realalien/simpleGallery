//
//  AppDelegate_iPad.m
//  SpicyhorseGallary
//
//  Created by realalien on 11/18/11.
//  Copyright 2011 Spicyhorse Studio. All rights reserved.
//

#import "AppDelegate_iPad.h"
#import "BookShelfViewController.h"
#import "BookShelfManager.h"



@implementation AppDelegate_iPad

@synthesize window;
@synthesize navController;
@synthesize viewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

// FAILED exp.
//	UIImage* image=[UIImage imageNamed:@"Default_1024X768.png"];
//	splashView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)]; // initWithImage:image];
//	splashView.image = image;			
				

	// SLN#1  just replacing a view, 
	//NOTE: remember to add navigation view controller(containing BookShelfViewController) to the MainWindows_iPad.xib
//	splash = [[SplashView alloc] initWithNibName:@"SplashView" bundle:nil ] ;
//	[window addSubview:splash.view];
//	
//	[window bringSubviewToFront:splash.view];
//	[window makeKeyAndVisible];
	
	// temp comment
	//[self performSelector:@selector(removeSplash) withObject:self afterDelay:2];
	
	
	// NOTE: Just one time loading, the following will be called in SplashViewController init.
//	[[ BookShelfManager sharedInstance] loadInventory ];
	
	
	// SLN#2  fading effect.
	viewController = [[SplashViewController alloc] init];
    // Override point for customization after app launch    
    [window addSubview:[viewController view]];
	
    [window makeKeyAndVisible];
	
	
	

	
	
	//[self animateSplashScreen];

	//self.window.rootViewController = self.navController;
	
//	[window addSubview:self.navController.view];
//	SplashView *splash = [[SplashView alloc] initWithNibName:@"SplashView" bundle:nil ] ;
//	[window addSubview:splash.view];
	
	//[self.window makeKeyAndVisible];
	//SwitchDefault *splash = [[[SwitchDefault alloc] init] autorelease];

	
	// NOTE: do NOT add following code, as in MainWindow.xib, the navigation view is created with an instance of BookShelfViewController.
	//	BookShelfViewController *bookShelf = [[BookShelfViewController alloc] initWithNibName:@"BookShelfViewController" bundle:nil ] ;
	//	[self.navController pushViewController:bookShelf animated:NO] ;
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Utilities

//- (void) animateSplashScreen
//{
//	
//	//fade time
//	CFTimeInterval animation_duration = 3;
//	
//	//SplashScreen 
//	UIImageView * splashView = [[[UIImageView alloc] initWithFrame:CGRectMake(0,0, 1024, 768)]autorelease];
//	splashView.image = [UIImage imageNamed:@"Default_1024x768.png"];
//	[window addSubview:splashView];
//	[window bringSubviewToFront:splashView];
//	
//	
//	
//	//Animation (fade away with zoom effect)
//	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDuration:animation_duration];
//	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.window cache:YES];
//	[UIView setAnimationDelegate:splashView]; 
//	[UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
//	splashView.alpha = 0.0;
//	splashView.frame = CGRectMake(-60, -60, 440, 600);
//	
//	[UIView commitAnimations];
//	
//}

@end
