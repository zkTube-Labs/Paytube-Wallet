//
//  MPing.h
//  Runner
//
//  Created by MWT on 2021/1/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MPingItem;
typedef void(^PingCallBack)(MPingItem * pingitem);

typedef NS_ENUM(NSUInteger, MPingManagerStatus) {
    MPingManagerStatusDidStart,
    MPingManagerStatusDidFailToSendPacket,
    MPingManagerStatusDidReceivePacket,
    MPingManagerStatusDidReceiveUnexpectedPacket,
    MPingManagerStatusDidTimeOut,
    MPingManagerStatusDidError,
    MPingManagerStatusDidFinished,
};

@interface MPingItem : NSObject
/// 主机名
@property (nonatomic, copy) NSString *hostName;
/// 单次耗时
@property (nonatomic, assign) double millSecondsDelay;
/// 当前ping状态
@property (nonatomic, assign) MPingManagerStatus status;

@end


@interface MPing : NSObject

- (instancetype)initWithHostName:(NSString *)hostName count:(NSInteger)count pingCallBack:(PingCallBack)pingCallBack ;



@end





NS_ASSUME_NONNULL_END
