//
//  WebSocketManager.m
//  time
//
//  Created by 魏苏扬 on 2019/3/28.
//  Copyright © 2019 1ge. All rights reserved.
//

#import "WebSocketManager.h"
#import "MomentsViewController.h"
#import "AppDelegate.h"
@implementation SocketResponeData

@end


@interface WebSocketManager ()
@property (nonatomic, strong)NSTimer *connectTimer;
@end

@implementation WebSocketManager
+(WebSocketManager *) sharedInstance {
    static WebSocketManager *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
    return sharedInstace;
}
- (SRWebSocket *)webSocket {
    if (!_webSocket) {
        _webSocket.delegate = nil;
        [_webSocket close];
        NSURL *url = [NSURL URLWithString:@"ws://121.40.165.18:8800"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        _webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
        _webSocket.delegate = self;
    }
    return _webSocket;
}
//链接socket
- (void)startAtSocket {
    self.webSocket = nil;
    [self.webSocket open];
    [self webSocketDidOpen:self.webSocket];
}
- (void)stopAtSocket {
    [self.connectTimer invalidate];
    self.webSocket = nil;
}
#pragma SRWebSocketDelegate
//连接成功
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"连接状态-----%lu",webSocket.readyState);
    if (webSocket.readyState == SR_OPEN) {
        //登录
        [self sendTologin];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(long_connect_heart) userInfo:nil repeats:YES];
            [self.connectTimer fire];
        });
    }
}
//连接失败 这里可以实现掉线自动重连，要注意以下几点"
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    self.webSocket = nil;
    [self.connectTimer invalidate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //重新链接socket
        [self startAtSocket];
    });
}
//连接关闭
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    _webSocket = nil;
    [self.connectTimer invalidate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //如果断开了，链接，自动重连
        [self startAtSocket];
    });
}

//开启心跳，心跳是发送pong的消息
-(void)long_connect_heart {
    //1.判断本地有没有token（登录token）
    //2.判断socket是否连接成功
    NSDictionary *info = @{@"cmd":@"heartbeat",@"p":@{@"uid":@"用户id"}};
    [self.webSocket send:[self objectJSONString:info]];
}

- (void)sendTologin {
    //1.判断本地有没有token（登录token）
    //2.判断socket是否连接成功
    NSDictionary *info = @{@"cmd":@"login",@"p":@{@"token":@"用户token"}};
    [self.webSocket send:[self objectJSONString:info]];
}

- (NSString *)objectJSONString:(NSDictionary *)dic {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *string = [[ NSString alloc ] initWithData :data encoding : NSUTF8StringEncoding];
    return string;
}

- (void)socketSendDataWithDic:(NSMutableDictionary *)dic{
    NSString *jsonStr =  [self objectJSONString:dic];
    if (jsonStr == nil) {
        jsonStr = @"";
    }
    [self socketSendDataWithJsonStr:jsonStr];
}

- (void)socketSendDataWithJsonStr:(NSString *)jsonStr{
    if (self.webSocket.readyState == SR_OPEN) {
        [self.webSocket send:jsonStr];
    }
}

- (void)socketSendDataWithNum:(NSInteger )unReadNum{
    if (self.webSocket.readyState == SR_OPEN) {
        NSDictionary *dictionary = @{@"cmd":@"RyunNum",@"p":@{@"uid":[NSString stringWithFormat:@"%@",@"uid"],@"num":[NSString stringWithFormat:@"%@",@(unReadNum)]}};
        [self.webSocket send:[self objectJSONString:dictionary]];
    }
}

// 接收到新消息的处理
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSError *error = nil;
    SocketResponeData *data= [[SocketResponeData alloc] initWithString:message error:&error];
    NSLog(@"cmd---%@",message);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        MomentsViewController *vc = [[MomentsViewController alloc] init];
//        vc.curModel = message;
//        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [delegate.window.rootViewController presentViewController:vc animated:YES completion:^{
//            
//        }];
    });
    //处理消息
//    [SocketReceivedSel dealWithSocketData:data];
}
- (BOOL)socketConnectStatus {
    if (self.webSocket.readyState == SR_OPEN) {
        return YES;
    }
    return NO;
}
@end
