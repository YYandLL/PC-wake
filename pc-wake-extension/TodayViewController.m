//
//  TodayViewController.m
//  pc-wake-extension
//
//  Created by YandL on 2017/5/23.
//  Copyright © 2017年 YandL. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "SocketConnect.h"
#import "yandl.pch"
#import "PCInfo.h"

@interface TodayViewController () <NCWidgetProviding>
/**
 * <#name#>
 */
@property (nonatomic, strong) NSArray *PCArray;
/**
 * <#name#>
 */
@property (nonatomic, strong) PCInfo *info;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    NSArray *PCArray = [TXBYUserDefaults valueForKey:PCINFOCACHE];
    
    self.PCArray = [PCInfo mj_objectArrayWithKeyValuesArray:PCArray];
    if (self.PCArray.count) {
        for (PCInfo *info in self.PCArray) {
            if ([info.showInHome isEqualToString:@"yes"]) {
                self.info = info;
                [self.button setTitle:@" " forState:UIControlStateNormal];
                self.label.text = [NSString stringWithFormat:@"%@\n点击在局域网唤醒", info.name];
            }
        }
    } else {
        [self.button setTitle:@"  " forState:UIControlStateNormal];
        self.label.text = @"暂无设备\n点击添加设备";
        
    }
    
    completionHandler(NCUpdateResultNewData);
}

- (IBAction)click:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@" "]) {
        NSString *title = self.label.text;
        [self wakeUpPC:title];
    } else {
        NSString *urlStr = [NSString stringWithFormat:@"LanWakeUp://%d",1];
        NSURL *url = [NSURL URLWithString:urlStr];
        [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        }];
    }
}

- (void)wakeUpPC:(NSString *)title {
    //被控制的电脑主机的mac地址
    //    NSString *macAddress = @"4CCC6AFB0C34";
    NSString *macAddress = self.info.mac;
    
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
    [socket wakeUp:data host:self.info.ip result:^(BOOL result) {
        //消息是否发送成功的回调
        [UIView animateWithDuration:0.2 animations:^{
            self.label.alpha = 0;
        } completion:^(BOOL finished) {
            self.label.text = @"✓ 操作成功";
            [UIView animateWithDuration:0.3 animations:^{
                self.label.alpha = 1;
            }];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                self.label.alpha = 0;
            } completion:^(BOOL finished) {
                self.label.text = title;
                [UIView animateWithDuration:0.3 animations:^{
                    self.label.alpha = 1;
                }];
            }];
        });
    }];
}

@end
