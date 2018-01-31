//
//  PadNavView.h
//  visitor-manage
//
//  Created by YandL on 2017/4/7.
//  Copyright © 2017年 YandL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PadNavView : UIView
/**
 * <#name#>
 */
typedef void (^padNavClickBlock)();
/**
 * <#name#>
 */
@property (nonatomic, strong) UIView *backView;
/**
 * <#name#>
 */
@property (nonatomic, strong) UIView *nextView;
/**
 * <#name#>
 */
@property (nonatomic, strong) NSString *title;
/**
 * <#name#>
 */
@property (nonatomic, strong) UIView *rightView;
/**
 * <#name#>
 */
@property (nonatomic, copy) padNavClickBlock backblock;
/**
 * <#name#>
 */
@property (nonatomic, copy) padNavClickBlock nextblock;

- (void)showBackView:(padNavClickBlock)block;

- (void)showRightView:(padNavClickBlock)block;

- (void)setRightEnable:(BOOL)enable;

- (void)setTitleAlpha:(CGFloat)alpha;

@end
