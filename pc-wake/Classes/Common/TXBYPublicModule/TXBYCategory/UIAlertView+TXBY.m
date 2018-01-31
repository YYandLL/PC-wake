//
//  UIAlertView+TXBY.m
//  zhongda-hospital
//
//  Created by YandL on 2017/3/29.
//  Copyright © 2017年 YandL. All rights reserved.
//

#import "UIAlertView+TXBY.h"
#import <objc/runtime.h>

@implementation UIAlertView (TXBY)
static const void *Block = &Block;
static const void *DefaultColor = &DefaultColor;
@dynamic alertClickBlock;
@dynamic defaultTintColor;

- (void)showWithClickBlock:(AlertViewClickBlock)alertClickBlock {
    self.alertClickBlock = alertClickBlock;
    self.delegate = self;
    
    
    self.defaultTintColor = [UIView appearance].tintColor;
    
    [UIView appearance].tintColor = TXBYMainColor;
    
    unsigned int count = 0;
    Ivar *property = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar var = property[i];
        const char *name = ivar_getName(var);
        const char *type = ivar_getTypeEncoding(var);
        NSLog(@"%s =============== %s",name,type);
    }
    Ivar message = property[2];
    /**
     *  字体修改
     */
    UIFont *big = [UIFont systemFontOfSize:25];
    UIFont *small = [UIFont systemFontOfSize:18];
    UIColor *red = [UIColor redColor];
    UIColor *blue = [UIColor blueColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"hello world" attributes:@{NSFontAttributeName:big,
                                                                                                                  NSForegroundColorAttributeName:red}];
    [str setAttributes:@{NSFontAttributeName:small} range:NSMakeRange(0, 2)];
    [str setAttributes:@{NSForegroundColorAttributeName:blue} range:NSMakeRange(0, 4)];
    
    //最后把message内容替换掉
    object_setIvar(self, message, str);
    [self show];
}

- (AlertViewClickBlock)alertClickBlock {
    return objc_getAssociatedObject(self, Block);
}

- (void)setAlertClickBlock:(AlertViewClickBlock)alertClickBlock {
    objc_setAssociatedObject(self, Block, alertClickBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)defaultTintColor {
    return objc_getAssociatedObject(self, DefaultColor);
}

- (void)setDefaultTintColor:(UIColor *)defaultTintColor {
    objc_setAssociatedObject(self, DefaultColor, defaultTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.alertClickBlock) {
        ///block传值
        self.alertClickBlock(buttonIndex);
    }
    [UIView appearance].tintColor = self.defaultTintColor;
}

@end
