//
//  CoinIDHelper.h
//  CoinID
//
//  Created by MWTECH on 2018/10/23.
//  Copyright © 2018年 新明华区块链技术（深圳）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enum.h"
#import "BigNumber.h"
#import "ImportObject.h"

typedef void(^HelperComplation)(id data,BOOL status);


@interface CoinIDHelper : NSObject


#pragma mark - 获得钱包助记词
+(NSArray<NSString*>*)createWalletMemo:(MMemoCount )memoCount
                              memoType:(MMemoType )memoType;

+(NSArray *)importWalletFrom:(ImportObject *) object ;

+(BOOL)checkMemoValid:(NSString*)memos ;

+(unsigned short*)fetchMemoIndex:(NSString*)memos ;

+(NSString*)fetch_ExportKeyStore:(NSString*)pwd priKey:(NSString*)priKey coinType:(int)coinType ;


+(bool)CoinID_checkETHpushValid:(NSString*)pushStr to:(NSString*)to value:(NSString*)value decimal:(int)decimal isContract:(bool)isContract contraAddr:(NSString*)contraAddr ;

+  (NSString *)getHexByDecimal:(BigNumber *)tempStr ;


@end
