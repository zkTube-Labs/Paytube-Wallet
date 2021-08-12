//
//  WalletObject.m
//  Runner
//
//  Created by MWT on 2/11/2020.
//

#import "WalletObject.h"
#import <CommonCrypto/CommonDigest.h>
#import "CoinIDTool.h"
#import "Enum.h"
@implementation WalletObject


-(NSString*)deckAESCBC:(NSString*)desk {
    
    if (!self.keys || self.keys.length == 0) {
        NSAssert(NO, @"未记录解锁后的密码");
        return nil ;
    }
    
    return [CoinIDTool CoinID_DecByAES128CBC:desk pin:self.keys];
}


@end
