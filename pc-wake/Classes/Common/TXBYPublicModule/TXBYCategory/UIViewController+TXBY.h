//
//  UIViewController+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TXBY)

#pragma mark - 网络失败
/**
 *  加载网络失败
 *
 *  @param error 错误信息
 */
- (void)requestFailure:(NSError *)error;

#pragma mark - 添加提示view
/**
 *  没有数据的提示view
 */
- (void)emptyViewWithText:(NSString *)text;
/**
 *  没有数据的提示view
 */
- (void)emptyViewWithText:(NSString *)text andImg:(UIImage *)image;
/**
 *  没有数据的提示view, image大小根据image自身大小
 */
- (void)emptyViewWithImage:(UIImage *)image WithText:(NSString *)text;
/**
 *  删除没有数据的提示
 */
- (void)deleteEmptyText;
/**
 *  添加提示声明等
 */
- (void)addTipsText:(NSString *)text;

- (void)updateShortcutItem;

@end
