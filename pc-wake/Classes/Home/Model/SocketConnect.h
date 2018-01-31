//
//  SocketConnect.h
//  pc-wake
//
//  Created by YandL on 2017/5/17.
//  Copyright © 2017年 YandL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"

@interface SocketConnect : NSObject
/**
*  ip地址
*/
@property (strong,nonatomic) NSString *hostIpAddress;

/**
 *  端口号
 */
@property (assign,nonatomic) NSInteger hostPort;

/**
 *  udp Socket
 */
@property (strong,nonatomic) AsyncUdpSocket *udpSocket;

/**
 *  唤醒状态的回调
 */
@property (strong,nonatomic) void(^wakeState)(BOOL result);

/**
 *  socket单例
 */
+ (instancetype)sharedInstance;

/**
 *  远程唤醒电脑
 *
 *  @param sendData data数据
 *  @param result   返回唤醒的状态
 */
- (void)wakeUp:(NSData *)sendData host:(NSString *)host result:(void(^)(BOOL result))result;

@end
