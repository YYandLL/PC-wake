//
//  UIViewController+TXBY.m
//  TXBYCategory
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "UIViewController+TXBY.h"
#import "TXBYKit.h"
#import "PCInfo.h"

@implementation UIViewController (TXBY)

#pragma mark - 网络失败
/**
 *  加载网络失败
 *
 *  @param error 错误信息
 */
- (void)requestFailure:(NSError *)error {
    NSInteger code = error.code;
    // “取消网络请求”和“网络请求正在进行”不显示错误
    if (code == -999 || code == -12001) {
        TXBYLog(@"%@",error);
        return;
    }
    NSString *msg = @"网络有问题，请稍后再试";
    if(code == -1009) {
        msg = @"似乎已断开与互联网的连接";
    }
    
    TXBYAlert(msg);
//    TXBYCustomAlert(msg);
}

#pragma mark - 添加提示view
/**
 *  没有数据的提示view
 */
- (void)emptyViewWithText:(NSString *)text {
    UILabel *label = [UILabel label];
    label.tag = 9999;
    label.frame = self.view.bounds;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.text = text;
    label.numberOfLines = 0;
    [self.view addSubview:label];
}

/**
 *  没有数据的提示view, image大小根据image自身大小
 */
- (void)emptyViewWithImage:(UIImage *)image WithText:(NSString *)text {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.tag = 9999;
    imgView.center = self.view.center;
    [self.view addSubview:imgView];
    
    UILabel *label = [UILabel label];
    label.tag = 9999;
    label.frame = self.view.bounds;
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.txby_y = CGRectGetMaxY(imgView.frame);
    label.txby_height = 30;
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.text = text;
    [self.view addSubview:label];
}

/**
 *  没有数据的提示view
 */
- (void)emptyViewWithText:(NSString *)text andImg:(UIImage *)image {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.tag = 9999;
    imgView.frame = CGRectMake(TXBYApplicationW / 2 - TXBYApplicationW * 0.3 / 2, TXBYApplicationH / 2 - TXBYApplicationW * 0.3 / 2 - 80, TXBYApplicationW * 0.3, TXBYApplicationW * 0.3);
    //imgView.center = self.view.center;
    //imgView.txby_centerY -= 50;
    [self.view addSubview:imgView];
    
    UILabel *label = [UILabel label];
    label.tag = 9999;
    label.frame = self.view.bounds;
    label.numberOfLines = 0;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.txby_y = CGRectGetMaxY(imgView.frame) + 20;
    label.txby_height = 40;
    label.font = [UIFont systemFontOfSize:15.0];
    label.text = text;
    [self.view addSubview:label];
}
/**
 *  删除没有数据的提示
 */
- (void)deleteEmptyText {
    for (UIView *view in self.view.subviews) {
        if (view.tag == 9999) {
            [view removeFromSuperview];
        }
    }
}

/**
 *  添加提示声明等
 */
- (void)addTipsText:(NSString *)text {
    
    UIView *tipsView = [[UIView alloc] init];
    tipsView.frame = CGRectMake(0, 0, TXBYApplicationW, 50);
    tipsView.backgroundColor = [UIColor colorWithRed:253.0 / 255 green:210.0 / 255 blue:95.0 / 255 alpha:1];
    [self.view addSubview:tipsView];
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.frame = CGRectMake(20, 5, TXBYApplicationW - 60, 40);
    tipsLabel.font = [UIFont systemFontOfSize:14.0];
    tipsLabel.textColor = [UIColor colorWithRed:245.0 / 255 green:116.0 / 255 blue:15.0/255 alpha:1];
    tipsLabel.text = text;
    tipsLabel.numberOfLines = 0;
    [tipsView addSubview:tipsLabel];
    
    UIButton *closeButon = [[UIButton alloc] init];
    closeButon.backgroundColor = [UIColor clearColor];
    closeButon.frame = CGRectMake(TXBYApplicationW - 30, 13, 25, 25);
    [closeButon setTitle:@"×" forState:UIControlStateNormal];
    [closeButon setTintColor:[UIColor whiteColor]];
    closeButon.titleLabel.font = [UIFont boldSystemFontOfSize:23];
    [closeButon addTarget:self action:@selector(closeTips) forControlEvents:UIControlEventTouchUpInside];
    [tipsView addSubview:closeButon];
    tipsView.tag = 9998;
}

- (void)closeTips {
    for (UIView *view in self.view.subviews) {
        if (view.tag == 9998) {
            [view removeFromSuperview];
            break;
        }
    }
}

- (void)updateShortcutItem {
    
    NSArray *PCArray = [TXBYUserDefaults valueForKey:PCINFOCACHE];
    PCArray = [PCInfo mj_objectArrayWithKeyValuesArray:PCArray];
    if (PCArray.count) {
        NSMutableArray *itemArray = [NSMutableArray array];
        for (int i = 0; i < ((PCArray.count < 4)? PCArray.count
                             : 4); i ++) {
            PCInfo *info = PCArray[i];
            //创建系统风格的icon
            UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePlay];
            //创建快捷选项
            UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:[NSString stringWithFormat:@"%d", i] localizedTitle:info.name localizedSubtitle:@"开 机" icon:icon userInfo:nil];
            
            [itemArray addObject:item];
        }
        //添加到快捷选项数组
        [UIApplication sharedApplication].shortcutItems = [NSArray arrayWithArray:itemArray];
    }
}

@end
