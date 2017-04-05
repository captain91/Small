//
//  AppDelegate.m
//  SmallFeature
//
//  Created by Sun on 16/1/21.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MoreViewController.h"
#import "FirstOpenViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface AppDelegate ()

@end

@implementation AppDelegate {
    UITabBarController *_tabBarController;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    //SMS_SDK
    [SMSSDK registerApp:@"111c6df00d508" withSecret:@"e45a5483b3f3d721b46cd77677ce3443"];
    
    //判断是不是第一次打开APP
    BOOL isFirstOpen = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstOpen"] boolValue];
    if (!isFirstOpen) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isFirstOpen"];
        //第一次打开
        FirstOpenViewController *firstVc = [FirstOpenViewController new];
        //点击进入应用，block回调
        __weak AppDelegate *weakSelf = self;
        firstVc.enterAppBlock = ^{
            [weakSelf addViewController];
        };
        self.window.rootViewController = firstVc;
    }else {
        [self addViewController];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)addViewController {
    UINavigationController *viewNa = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    UINavigationController *moreNa = [[UINavigationController alloc]initWithRootViewController:[MoreViewController new]];
    
    NSArray *naArray = [NSArray arrayWithObjects:viewNa,moreNa, nil];
    NSArray *itemTitleA = [NSArray arrayWithObjects:@"首页",@"更多", nil];
    NSArray *itemImageA = [NSArray arrayWithObjects:@"home",@"more", nil];
    for (int i = 0; i < naArray.count; i++) {
        UITabBarItem *item = [[UITabBarItem alloc]init];
        [item setTitle:itemTitleA[i]];
        UIImage *itemImage = [UIImage imageNamed:itemImageA[i]];
        itemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setImage:itemImage];
        [item setSelectedImage:[UIImage imageNamed:itemImageA[i]]];
        [naArray[i] setTabBarItem:item];
    }
    
    _tabBarController = [[UITabBarController alloc]init];
    _tabBarController.viewControllers = naArray;
    
    self.window.rootViewController = _tabBarController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
