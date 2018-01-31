//
//  SocketConnect.m
//  pc-wake
//
//  Created by YandL on 2017/5/17.
//  Copyright © 2017年 YandL. All rights reserved.
//

#import "SocketConnect.h"

@implementation SocketConnect

#pragma mark - 懒加载
- (AsyncUdpSocket *)udpSocket {
    if (!_udpSocket) {
        _udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
        NSError *error = nil;        //开启广播模式
        [_udpSocket enableBroadcast:YES error:&error];
//        NSLog(@"%@",error);
    }
    return _udpSocket;
}

// 懒加载结束
#pragma mark - 初始化单例对象
+ (instancetype)sharedInstance {
    static SocketConnect *socketConnect = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        socketConnect = [[SocketConnect alloc] init];
    });
    return socketConnect;
}

- (void)wakeUp:(NSData *)sendData host:(NSString *)host result:(void (^)(BOOL))result {
    self.wakeState = result;
    //由于是局域网，我直接发送洪的广播包，如果做远程唤醒，需要替换这里的ip地址
    [self.udpSocket sendData:sendData toHost:host port:self.hostPort withTimeout:-1 tag:0];
    
}

#pragma mark - socket协议方法
//已接收到消息
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port {

    return YES;
}

//没有接受到消息
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error {
    
}
//没有发送出消息
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    
    self.wakeState(NO);
    
}
//已发送出消息
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    
    self.wakeState(YES);

}


//断开连接
- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock {


}

@end
