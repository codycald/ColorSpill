//
//  FLTAppDelegate.m
//  FilterLab
//
//  Created by Cody Caldwell on 6/13/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "FLTAppDelegate.h"
#import "FLTHomeScreenViewController.h"

@implementation FLTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    FLTHomeScreenViewController *hvc = [[FLTHomeScreenViewController alloc] init];
    self.window.rootViewController = hvc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
