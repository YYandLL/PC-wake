//
//  TXBYBaseParam.m
//  TXBYBaseParam
//
//  Created by hj on 16/5/9.
//  Copyright © 2016年 eeesys. All rights reserved.
//

#import "TXBYBaseParam.h"
#import "TXBYKitConst.h"

@implementation TXBYBaseParam
/**
 *  快速创建一个请求参数对象
 */
+ (instancetype)param {
    id param = [[self alloc] init];
    return param;
}

@end
