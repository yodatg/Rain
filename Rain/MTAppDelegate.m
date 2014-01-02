//
//  MTAppDelegate.m
//  Rain
//
//  Created by Thomas Grant on 20/12/2013.
//  Copyright (c) 2013 Thomas Grant. All rights reserved.
//

#import "MTAppDelegate.h"
#import "MTWeatherViewController.h"
#import "MTForecastViewController.h"
#import "MTLocationsViewController.h"

@interface MTAppDelegate()

@property (strong, nonatomic) IIViewDeckController *viewDeckController;

@end

@implementation MTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    MTLocationsViewController *leftViewController = [[MTLocationsViewController alloc] initWithNibName:@"MTLocationsViewController" bundle:nil];
    MTForecastViewController *rightViewController = [[MTForecastViewController alloc] initWithNibName:@"MTForecastViewController" bundle:nil];
    MTWeatherViewController *centerViewController = [[MTWeatherViewController alloc] initWithNibName:@"MTWeatherViewController" bundle:nil];
    // configure locations view controller
    [leftViewController setDelegate:centerViewController];
    
    // initialise View Deck Controller
    self.viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:centerViewController leftViewController:leftViewController rightViewController:rightViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = self.viewDeckController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
