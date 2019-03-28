//
//  WebSocketManager.h
//  time
//
//  Created by 魏苏扬 on 2019/3/28.
//  Copyright © 2019 1ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>
#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SocketResponeData : JSONModel
@property (nonatomic,copy)NSString<Optional> *code;
@property (nonatomic,copy)NSString<Optional> *msg;
@property (nonatomic,copy)NSString<Optional> *cmd;
@property (nonatomic,copy)NSDictionary<Optional> *data;
@end


@interface WebSocketManager : NSObject<SRWebSocketDelegate>
@property(nonatomic,strong) SRWebSocket *webSocket;

+(WebSocketManager *) sharedInstance;
- (void)startAtSocket;
- (void)stopAtSocket;
- (void)socketSendDataWithDic:(NSMutableDictionary *)dic;
- (void)socketSendDataWithJsonStr:(NSString *)jsonStr;
//更新服务器聊天未读消息数
- (void)socketSendDataWithNum:(NSInteger )unReadNum;
- (BOOL)socketConnectStatus;
@end

NS_ASSUME_NONNULL_END
