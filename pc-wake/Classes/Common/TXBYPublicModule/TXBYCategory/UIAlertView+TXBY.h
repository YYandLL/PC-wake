//
//  UIAlertView+TXBY.h
//  zhongda-hospital
//
//  Created by YandL on 2017/3/29.
//  Copyright © 2017年 YandL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (TXBY)

typedef void (^AlertViewClickBlock)(NSInteger index);
/**
 * <#name#>
 */
@property (nonatomic, strong) UIColor *defaultTintColor;

/**
 *  点击回调
 */
@property (nonatomic, copy) AlertViewClickBlock alertClickBlock;
/**
 * <#name#>
 */
@property (nonatomic, strong) UIColor *firstColor;
/**
 * <#name#>
 */
@property (nonatomic, strong) UIColor *otherColor;

- (void)showWithClickBlock:(AlertViewClickBlock)alertClickBlock;

@end
