//
//  CoinIDHelper+EOSSign.m
//  CoinID
//
//  Created by MWTECH on 2019/4/11.
//  Copyright © 2019 新明华区块链技术（深圳）有限公司. All rights reserved.
//

#import "CoinIDHelper+EOSSign.h"
#import "CoinIDTool.h"
#import "CoinIDLIBInterface.h"
#import "WalletObject.h"
@implementation CoinIDHelper (EOSSign)

+(id)importEOSWallet:(ImportObject * )object {
    
    int leadType = object.mLeadType ;
    NSString * content = object.content ;
    int index = object.index ;
    NSString * PIN = object.pin ;
    WalletObject * wallet = [[WalletObject alloc] init];
    u8 * prvAndPubKeyOwner ;
    u8 * prvAndPubKeyActive ;
    u8 * prvPubKey ;
    if (leadType == MLeadWalletType_Memo) {
        
        NSData * memoData = [CoinIDTool convertDataWithMasterStrings:content];
        CoinID_SetMaster((unsigned char *)[memoData bytes], memoData.length);
        CoinID_DeriveEOSKeyRoot();//生成一个根
        CoinID_DeriveEOSKeyAccount(0);
        prvAndPubKeyOwner = CoinID_DeriveEOSKey(0);//o
        prvAndPubKeyActive = CoinID_DeriveEOSKey(1);//e
    }
    else if (leadType == MLeadWalletType_PrvKey){
        
        u8 * priChar =  (u8*)[content UTF8String];
        bool success  = CoinID_ImportEOSPrvKeyCheck(priChar, content.length);
        if (!success) {
            return wallet;
        }
        prvPubKey = CoinID_ImportEOSPrvKey(priChar, content.length);
        
    }
    else if (leadType == MLeadWalletType_KeyStore){
        
        u8 * passChar = (u8*)[PIN UTF8String];
        u8 * contentChar = (u8*)[content UTF8String];
        u8 * outlen = (u8*)malloc(2) ;
        prvPubKey  = CoinID_importKeyStore(contentChar, passChar , PIN.length, outlen);
        int tranLength = (outlen[0]<<8)|(outlen[1]) ;
        if (tranLength == 0 ) {
            return wallet;
        }
    }
    else{
        //0 是owner
        //1 是active
        [CoinIDTool CoinID_SetMasterStandard:content];
        prvAndPubKeyOwner = [CoinIDTool CoinID_deriveKeyByPath:@"44'/194'/0'/0/0"];
        prvAndPubKeyActive = [CoinIDTool CoinID_deriveKeyByPath:@"44'/194'/0'/0/1"];
    }
    
    NSString * prvKey_owner = nil;
    NSString * prvKey_active = nil;
    NSString * pubKey_owner = nil;
    NSString * pubKey_active = nil;
    
    if (leadType == MLeadWalletType_Memo || leadType == MLeadWalletType_StandardMemo) {
        
        if (prvAndPubKeyActive == NULL|| prvAndPubKeyOwner == NULL) {
            return wallet ;
        }
        u8 * prvOwner = CoinID_ExportEOSPrvKey(prvAndPubKeyOwner);
        u8 * prvActive = CoinID_ExportEOSPrvKey(prvAndPubKeyActive);
        u8 * pubOwner = CoinID_ExportEOSPubKey(prvAndPubKeyOwner + 32);
        u8 * pubActive = CoinID_ExportEOSPubKey(prvAndPubKeyActive + 32);
        prvKey_owner = [CoinIDTool formtterWithChar:prvOwner];
        prvKey_active = [CoinIDTool formtterWithChar:prvActive];
        pubKey_owner = [CoinIDTool formtterWithChar:pubOwner];
        pubKey_active = [CoinIDTool formtterWithChar:pubActive];
        
    }else{
        
        if (prvPubKey == NULL) {
            return wallet;
        }
        u8 * prikey  = (u8*)malloc(32);
        u8 * ownerKey = (u8*)malloc(100);
        memcpy(prikey, prvPubKey, 32);
        memcpy(ownerKey, prvPubKey + 32, 65);
            
        prvKey_owner = [CoinIDTool formtterWithChar: CoinID_ExportEOSPrvKey(prikey)];
        pubKey_owner = [CoinIDTool formtterWithChar:CoinID_ExportEOSPubKey(ownerKey)];
    }
    
    wallet.coinType = MCoinType_EOS;
    wallet.address = @"";
    if (leadType == MLeadWalletType_StandardMemo || leadType == MLeadWalletType_Memo) {
        
        wallet.pubKey = pubKey_owner;
        wallet.subPubKey = pubKey_active;
        wallet.prvKey = prvKey_owner;
        wallet.subPrvKey = prvKey_active ;
    }else{
        
        wallet.pubKey = pubKey_owner;
        wallet.prvKey = prvKey_owner;
    }
    return wallet;
    
}


@end
