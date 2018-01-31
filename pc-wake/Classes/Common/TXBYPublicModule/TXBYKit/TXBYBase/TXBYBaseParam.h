//
//  TXBYBaseParam.h
//  TXBYBaseParam
//
//  Created by hj on 16/5/9.
//  Copyright © 2016年 eeesys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXBYBaseParam : NSObject
/**
 *  访问类型
 */
@property (nonatomic, copy) NSString *act;
/**
 *  快速创建一个请求参数对象
 */
+ (instancetype)param;

@end
