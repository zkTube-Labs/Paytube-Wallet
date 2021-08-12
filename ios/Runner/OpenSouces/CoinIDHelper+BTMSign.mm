//
//  CoinIDHelper+BTMSign.m
//  CoinID
//
//  Created by MWTECH on 2019/4/18.
//  Copyright © 2019 新明华区块链技术（深圳）有限公司. All rights reserved.
//

#import "CoinIDHelper+BTMSign.h"
#import "CoinIDTool.h"
#import "CoinIDLIBInterface.h"
#import "WalletObject.h"
@implementation CoinIDHelper (BTMSign)

+(id)importBTMWallet:(ImportObject * )object {

    
    int leadType = object.mLeadType ;
    NSString * content = object.content ;
    int index = object.index ;
    NSString * PIN = object.pin ;
    WalletObject * wallet = [[WalletObject alloc] init];
    u8 * prvKeyAndPubKey ;
    if (leadType == MLeadWalletType_Memo) {
        
        NSData * memoData = [CoinIDTool convertDataWithMasterStrings:content];
        CoinID_SetMaster((unsigned char *)[memoData bytes], memoData.length);
        CoinID_DeriveKeyRoot(0x99);
        CoinID_DeriveKeyAccount(0);
        prvKeyAndPubKey  = CoinID_DeriveKey(0);
    }
    else if (leadType == MLeadWalletType_PrvKey){
       
        if (![CoinIDTool isHexBTMPrvKey:content]) {
            return wallet ;
        }
        u8 * priKey = [CoinIDTool hexToBytes:content];
        prvKeyAndPubKey  = CoinID_ImportBYTOMPrvKey(priKey) ;
    }
    else if (leadType == MLeadWalletType_KeyStore){
        
        u8 * passChar = (u8*)[PIN UTF8String];
        u8 * contentChar = (u8*)[content UTF8String];
        u8 * outlen = (u8*)malloc(2) ;
        prvKeyAndPubKey  = CoinID_importKeyStore(contentChar, passChar , PIN.length, outlen);
        int tranLength = (outlen[0]<<8)|(outlen[1]) ;
        if (tranLength == 0 ) {
            return wallet;
        }
    }else{
       
        [CoinIDTool CoinID_SetMasterStandard:content];
        prvKeyAndPubKey = [CoinIDTool CoinID_deriveKeyByPath:@"44/153/1/0/1"];
    }
    
    if (prvKeyAndPubKey == NULL){
        return wallet;
    }
    u8 * priKey = (u8*)malloc(64);
    memcpy(priKey, prvKeyAndPubKey, 64);
    u8 * publickey = (u8*)malloc(64);
    memcpy(publickey, prvKeyAndPubKey + 64, 64);
    u8 * bymAddress  = CoinID_getBYTOMAddress(publickey);
    NSString *  pubString = [CoinIDTool formtterWithChar:bymAddress];
    NSString *  prvString =  [CoinIDTool beginHexString:64 data:priKey];
    wallet.coinType = MCoinType_BTM;
    wallet.address = pubString;
    wallet.prvKey = prvString ;
    wallet.pubKey = [CoinIDTool beginHexString:64 data:publickey] ;
    return wallet;
    
}

@end
