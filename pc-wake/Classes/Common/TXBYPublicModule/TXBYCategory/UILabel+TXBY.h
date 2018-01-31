//
//  UILabel+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TXBY)

/**
 *  创建Label
 */
+ (instancetype)txby_label;

/**
 *  根据字体创建Label
 */
+ (instancetype)labelWithFont:(UIFont *)font;

@end