//
//  AppDelegate.m
//  pc-wake
//
//  Created by YandL on 2017/5/17.
//  Copyright © 2017年 YandL. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "PCInfo.h"
#import "SocketConnect.h"
#import "AddPCViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [UIView appearance].tintColor = TXBYColor(80, 80, 80);
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *navgation = [[UINavigationController alloc] initWithRootViewController:homeVC];
    [navgation.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]/*, NSForegroundColorAttributeName:[UIView appearance].tintColor*/}];
//    [navgation.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
//    navgation.navigationBar.shadowImage = [UIImage imageNamed:@"shadow_alpha_window"];
    
    self.window.rootViewController = navgation;
    [self.window makeKeyAndVisible];
    
    [self creatShortcutItem];
    
    UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    //如果是从快捷选项标签启动app，则根据不同标识执行不同操作，然后返回NO，防止调用- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
    if (shortcutItem) {
        //判断设置的快捷选项标签唯一标识，根据不同标识执行不同操作
        [self wakeUpPC:shortcutItem.type];
        return NO;
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
    
    NSArray *workoutArr = [userActivity.title componentsSeparatedByString:@"_"];
    
    NSString *workoutName = workoutArr[1];
    NSString *workoutStatus = workoutArr[0];
    
    NSDictionary *workout = [[NSDictionary alloc]initWithObjectsAndKeys:
                             workoutName,   @"workoutName",
                             workoutStatus, @"workoutStatus",
                             nil];
    
    //创建一个消息对象
    NSNotification *notice = [NSNotification notificationWithName:@"siri" object:nil userInfo:workout];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    return YES;
}


- (void)creatShortcutItem {
    
    NSArray *PCArray = [TXBYUserDefaults valueForKey:PCINFOCACHE];
    PCArray = [PCInfo mj_objectArrayWithKeyValuesArray:PCArray];
    if (PCArray.count) {
        NSMutableArray *itemArray = [NSMutableArray array];
        for (int i = 0; i < ((PCArray.count < 4)? PCArray.count
             : 4); i ++) {
            PCInfo *info = PCArray[i];
            //创建系统风格的icon
            UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"shutdown"];
            //创建快捷选项
            UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:[NSString stringWithFormat:@"%d", i] localizedTitle:info.name localizedSubtitle:@"在局域网唤醒" icon:icon userInfo:nil];
            
            [itemArray addObject:item];
        }
        //添加到快捷选项数组
        [UIApplication sharedApplication].shortcutItems = [NSArray arrayWithArray:itemArray];
    }
}

- (void)wakeUpPC:(NSString *)indexString {
    //消息是否发送成功的回调
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //被控制的电脑主机的mac地址
        NSArray *PCArray = [TXBYUserDefaults valueForKey:PCINFOCACHE];
        PCArray = [PCInfo mj_objectArrayWithKeyValuesArray:PCArray];
        PCInfo *info = PCArray[[indexString integerValue]];
        NSString *macAddress = info.mac;
        Byte mac[6] = {};
        for (int i = 0; i < macAddress.length; i +=2) {
            NSString *strByte = [macAddress substringWithRange:NSMakeRange(i, 2)];
            unsigned long red = strtoul([strByte UTF8String], 0, 16);
            
            Byte b = (Byte)((0xff & red));
            mac[i / 2 + 0] = b;
        }
        
        Byte packet[17 * 6] = {};
        for (int i = 0 ; i < 6; i++) {
            packet[i] = 0xFF;
            for (int i = 1; i <= 16; i++) {
                for (int j = 0; j < 6; j++) {
                    packet[i * 6 + j] = mac[j];
                }
            }
        }
        
        SocketConnect *socket = [SocketConnect sharedInstance];
        socket.hostPort = 1001;
        
        NSData *data = [NSData dataWithBytes:packet length:sizeof(packet)];
        [socket wakeUp:data host:info.ip result:^(BOOL result) {
            
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
        }];
    });
}

//如果APP没被杀死，还存在后台，点开Touch会调用该代理方法
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if (shortcutItem) {
        [self wakeUpPC:shortcutItem.type];
    }
    if (completionHandler) {
        completionHandler(YES);
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.scheme isEqualToString:@"LanWakeUp"]) {
        if ([url.host isEqualToString:@"1"]) {
            AddPCViewController *addVC = [[AddPCViewController alloc] init];
            [(UINavigationController *)self.window.rootViewController pushViewController:addVC animated:YES];
        }
    }
    return YES;
}

// ios9 之后
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    if ([url.scheme isEqualToString:@"LanWakeUp"]) {
        if ([url.host isEqualToString:@"1"]) {
            AddPCViewController *addVC = [[AddPCViewController alloc] init];
            [(UINavigationController *)self.window.rootViewController pushViewController:addVC animated:YES];
        }
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
