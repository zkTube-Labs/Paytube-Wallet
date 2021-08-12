//
//  CoinIDHelper+LTCSign.m
//  CoinID
//
//  Created by MWTECH on 2019/5/5.
//  Copyright © 2019 新明华区块链技术（深圳）有限公司. All rights reserved.
//

#import "CoinIDHelper+LTCSign.h"
#import "CoinIDTool.h"
#import "CoinIDLIBInterface.h"
#import "WalletObject.h"
@implementation CoinIDHelper (LTCSign)

+(id)importLTCWallet:(ImportObject * )object {
    
    int leadType = object.mLeadType ;
    NSString * content = object.content ;
    int index = object.index ;
    NSString * PIN = object.pin ;
    WalletObject * wallet = [[WalletObject alloc] init];
    u8 * prvKeyAndPubKey ;
    if (leadType == MLeadWalletType_Memo) {
        
        NSData * memoData = [CoinIDTool convertDataWithMasterStrings:content];
        CoinID_SetMaster((unsigned char *)[memoData bytes], memoData.length);
        CoinID_DeriveKeyRoot(2);
        CoinID_DeriveKeyAccount(0);
        prvKeyAndPubKey  = CoinID_DeriveKey(0);
    }
    else if (leadType == MLeadWalletType_PrvKey){
        NSData * data = [content dataUsingEncoding:NSASCIIStringEncoding];
        u8 * prvKey =  (u8*)[data bytes];
        prvKeyAndPubKey  = CoinID_ImportPrvKeyByWIF(prvKey, data.length);
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
        prvKeyAndPubKey = [CoinIDTool CoinID_deriveKeyByPath:@"44'/2'/0'/0/0"];
    }
    
    if (prvKeyAndPubKey == NULL){
        return wallet;
    }
    
    u8 * prvKey = (u8*)malloc(32);
    memcpy(prvKey, prvKeyAndPubKey, 32);
    u8 * pubKey = (u8*)malloc(65);
    memcpy(pubKey, prvKeyAndPubKey + 32, 65);
    u8 * exportPubkey = CoinID_genBTCAddress(48 , pubKey, 33, 0 );
    u8 * exportPrikey = CoinID_ExportPrvKeyByWIF(176, prvKey);
    NSString *  pubString = [CoinIDTool formtterWithChar:exportPubkey];
    NSString *  prvString =  [CoinIDTool formtterWithChar:exportPrikey];
    
    wallet.coinType = MCoinType_LTC;
    wallet.address = pubString;
    wallet.prvKey = prvString ;
    wallet.pubKey = [CoinIDTool beginHexString:65 data:pubKey] ;
    return wallet;
}



@end
