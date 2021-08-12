//
//  MPing.m
//  Runner
//
//  Created by MWT on 2021/1/11.
//

#import "MPing.h"
#import "SimplePing.h"

@implementation MPingItem

@end

@interface MPing ()<SimplePingDelegate>

@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, strong) SimplePing *pinger;
@property (nonatomic, strong) NSTimer *sendTimer;
@property (nonatomic, strong) NSMutableArray <NSDate *>*startDateArray;
@property (nonatomic, assign) NSInteger dateSendIndex;
@property (nonatomic, copy) PingCallBack pingCallBack;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger needPingCount;
@property (nonatomic, assign) NSInteger receivedOrDelayCount;

@end

@implementation MPing

- (instancetype)initWithHostName:(NSString *)hostName count:(NSInteger)count pingCallBack:(PingCallBack)pingCallBack
{
    if (self = [super init]) {
        NSRange range = [hostName rangeOfString:@"://"];
        if (range.location != NSNotFound) {
            hostName = [hostName substringFromIndex:range.location + range.length ];
        }
        hostName = [[hostName componentsSeparatedByString:@"/"] firstObject];
        self.hostName = hostName;
        self.count = count;
        self.needPingCount = count;
        self.startDateArray = [NSMutableArray array];
        self.pingCallBack = pingCallBack;
        self.pinger = [[SimplePing alloc] initWithHostName:hostName];
        self.pinger.addressStyle = SimplePingAddressStyleAny;
        self.pinger.delegate = self;
        [self.pinger start];
    }
    return self;
}

#pragma mark - Private Methods
/// stop ping service
- (void)stop
{
    NSLog(@"%@ stop",self.hostName);
    [self cleanWithStatus:MPingManagerStatusDidFinished];
}

/// ping delay
- (void)timeOut
{
    if (self.sendTimer) {
        NSLog(@"%@ timeout",self.hostName);
        self.receivedOrDelayCount++;
        MPingItem *pingItem = [[MPingItem alloc] init];
        pingItem.hostName = self.hostName;
        pingItem.status = MPingManagerStatusDidTimeOut;
        self.pingCallBack(pingItem);
        if (self.receivedOrDelayCount == self.needPingCount) {
            [self stop];
        }
    }
}

/// ping failure
- (void)fail
{
    NSLog(@"%@ fail",self.hostName);
    [self cleanWithStatus:MPingManagerStatusDidError];
}

- (void)cleanWithStatus:(MPingManagerStatus)status
{
    MPingItem *pingItem = [[MPingItem alloc] init];
    pingItem.hostName = self.hostName;
    pingItem.status = status;
    self.pingCallBack(pingItem);
    
    [self.pinger stop];
    self.pinger = nil;
    
    [self.sendTimer invalidate];
    self.sendTimer = nil;
    
    [self cancelRunLoopPerformTimeOut];
    
    self.hostName = nil;
    if (status == MPingManagerStatusDidFailToSendPacket) {
        [self.startDateArray removeLastObject];
    } else {
        [self.startDateArray removeAllObjects];
    }
    self.pingCallBack = nil;
}

- (void)sendPing
{
    if (self.count < 1) {
        return;
    }
    self.count --;
    [self.startDateArray addObject:[NSDate date]];
    [self.pinger sendPingWithData:nil];
    [self performSelector:@selector(timeOut) withObject:self afterDelay:1.0];
}

- (void)cancelRunLoopPerformTimeOut
{
    // 无法取消?
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeOut) object:nil];
}

#pragma mark - Ping Delegate
- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address
{
    NSLog(@"start ping %@",self.hostName);
    [self sendPing];
    NSAssert(self.sendTimer == nil, @"timer can't be nil");
    self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(sendPing) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.sendTimer forMode:NSDefaultRunLoopMode];
    
    MPingItem *pingItem = [[MPingItem alloc] init];
    pingItem.hostName = self.hostName;
    pingItem.status = MPingManagerStatusDidStart;
    self.pingCallBack(pingItem);
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error
{
    [self cancelRunLoopPerformTimeOut];
    NSLog(@"%@ %@",self.hostName, error.localizedDescription);
    [self fail];
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    [self cancelRunLoopPerformTimeOut];
    NSLog(@"%@ %hu send packet success",self.hostName, sequenceNumber);
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error
{
    [self cancelRunLoopPerformTimeOut];
    NSLog(@"%@ %hu send packet failed: %@",self.hostName, sequenceNumber, error.localizedDescription);
    [self cleanWithStatus:MPingManagerStatusDidFailToSendPacket];
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    [self cancelRunLoopPerformTimeOut];
    double millSecondsDelay = 0;
    if (self.startDateArray.count <= self.dateSendIndex) {
        millSecondsDelay = 1.f;
    } else {
        millSecondsDelay = [[NSDate date] timeIntervalSinceDate:self.startDateArray[self.dateSendIndex]] * 1000;
    }
    self.dateSendIndex++;
    self.receivedOrDelayCount++;
    NSLog(@"%@ %hu received, size=%lu time=%.2f",self.hostName, sequenceNumber, (unsigned long)packet.length, millSecondsDelay);
    MPingItem *pingItem = [[MPingItem alloc] init];
    pingItem.hostName = self.hostName;
    pingItem.status = MPingManagerStatusDidReceivePacket;
    pingItem.millSecondsDelay = millSecondsDelay;
    self.pingCallBack(pingItem);
    
    if (self.receivedOrDelayCount == self.needPingCount) {
        [self stop];
    }
    
}

- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet
{
    [self cancelRunLoopPerformTimeOut];
}

@end
