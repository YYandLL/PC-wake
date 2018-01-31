//
//  PCInfo.h
//  pc-wake
//
//  Created by YandL on 2017/5/19.
//  Copyright © 2017年 YandL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCInfo : NSObject
/**
 * <#name#>
 */
@property (nonatomic, copy) NSString *name;
/**
 * <#name#>
 */
@property (nonatomic, copy) NSString *mac;
/**
 * <#name#>
 */
@property (nonatomic, copy) NSString *ip;
/**
 * <#name#>
 */
@property (nonatomic, copy) NSString *showInHome;
@end
