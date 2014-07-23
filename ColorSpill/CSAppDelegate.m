//
//  CSAppDelegate.m
//  ColorSpill
//
//  Created by Cody Caldwell on 6/13/14.
//  Copyright (c) 2014 Cody Caldwell. All rights reserved.
//

#import "CSAppDelegate.h"
#import "CSHomeScreenViewController.h"

@implementation CSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    CSHomeScreenViewController *hvc = [[CSHomeScreenViewController alloc] init];
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
