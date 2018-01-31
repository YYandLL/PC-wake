//
//  UIColor+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TXBY)


- (CGColorSpaceModel) colorSpaceModel;
/**
 *  red值
 */
- (CGFloat)red;
/**
 *  green值
 */
- (CGFloat)green;
/**
 *   blue值
 */
- (CGFloat)blue;
/**
 *  透明度值
 */
- (CGFloat)alpha;

// 0x开头的十六进制转换成的颜色,透明度可调整
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;

// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
+ (UIColor *)colorWithHexString:(NSString *)color;

@end
