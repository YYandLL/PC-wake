//
//  UILabel+TXBY.m
//  TXBYCategory
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "UILabel+TXBY.h"

@implementation UILabel (TXBY)

+ (instancetype)txby_label {
    return [self labelWithFont:nil];
}

+ (instancetype)labelWithFont:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    if (font) {
        label.font = font;
    }
    return label;
}

@end