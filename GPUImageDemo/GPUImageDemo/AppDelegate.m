//
//  AppDelegate.m
//  GPUImageDemo
//
//  Created by Fei Yuan on 2021/3/15.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
//@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColor.whiteColor;
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ViewController * imageVC = [board instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.window setRootViewController:[[UINavigationController alloc] initWithRootViewController:imageVC]];
    [self.window makeKeyAndVisible];
    return YES;
}





@end
