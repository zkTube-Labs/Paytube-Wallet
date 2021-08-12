//
//  CoinIDHelper+USDTSign.m
//  CoinID
//
//  Created by MWTECH on 2019/5/27.
//  Copyright © 2019 新明华区块链技术（深圳）有限公司. All rights reserved.
//

#import "CoinIDHelper+USDTSign.h"
#import "CoinIDLIBInterface.h"
#import "CoinIDHelper+BTCSign.h"
#import "WalletObject.h"
@implementation CoinIDHelper (USDTSign)


+(id)importUSDTWallet:(ImportObject * )object {
    
    WalletObject * wallet  = [CoinIDHelper importBTCWallet:object];
    wallet.coinType = MCoinType_USDT ;
    return wallet ;
}



@end
