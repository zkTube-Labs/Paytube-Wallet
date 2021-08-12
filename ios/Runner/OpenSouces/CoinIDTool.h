//
//  CoinIDTool.h
//  Runner
//
//  Created by MWT on 2/11/2020.
//

#import <Foundation/Foundation.h>
#import "Enum.h"

NS_ASSUME_NONNULL_BEGIN


@interface CoinIDTool : NSObject

+(NSData *) convertDataWithMasterStrings :(NSString * )memos;

+(bool)CoinID_SetMasterStandard:(NSString*)mnemonicBuffer;

+(unsigned char *)CoinID_deriveKeyByPath:(NSString*)path ;

+(NSString*)CoinID_cvtAddrByEIP55:(NSString*)address ;

+(BOOL)isHexETHPrvKey:(NSString*)content ;
+(BOOL)isHexBTMPrvKey:(NSString*)content ;
+ (unsigned char *) hexToBytes:(NSString*)string  ;
+(NSArray*)fetchLocalRemberWorld:(MMemoType)memoType ;
+(NSArray*)fetchRemberIndex :(MMemoCount)count ;
+ (BOOL)isChar:(NSString*)string ;
+(NSString*)formtterWithChar:(unsigned char*)data ;
+(NSString*)beginHexString:(int)count data:(unsigned char *)data ;
+(NSString*)CoinID_getMasterPubKey;
+(NSString*)CoinID_EncByAES128CBC:(NSString *) value pin:(NSString*)pin ;
+(NSString*)CoinID_DecByAES128CBC:(NSString *) value pin:(NSString*)pin ;
+(bool)CoinID_checkAddressValid:(NSString *) chainType address:(NSString*)address ;
+(NSString * )CoinID_sigETH_TX_by_str:(NSDictionary*)params ;
+(bool)CoinID_checkETHpushValid:(NSDictionary*)params ;
+(NSString*)CoinID_sigtBTCTransaction:(NSDictionary*)params;
+(bool)CoinID_checkBTCpushValid:(NSDictionary*)params ;
+(NSString*)CoinID_sigtBYTOMTransaction:(NSDictionary*)params;
+(NSString*)CoinID_getBYTOMCode:(NSDictionary*)params;
+(bool) CoinID_checkBYTOMpushValid:(NSDictionary*)params;
+(NSString*) CoinID_GetTranSigJson:(NSDictionary*)params;
+(bool) CoinID_checkEOSpushValid:(NSDictionary*)params;
+(NSString*) CoinID_genBTCAddress:(NSDictionary*)params;
+(NSString*)CoinID_filterUTXO:(NSDictionary*)params ;
+(NSString*)CoinID_genScriptHash:(NSDictionary*)params;
+(NSString*)CoinID_sigPolkadotTransaction:(NSDictionary*)params;
+(NSString*)CoinID_polkadot_getNonceKey:(NSDictionary*)params;

@end

NS_ASSUME_NONNULL_END
