//
//  CoinIDHelper.m
//  CoinID
//
//  Created by MWTECH on 2018/10/23.
//  Copyright © 2018年 新明华区块链技术（深圳）有限公司. All rights reserved.
//

#import "CoinIDHelper.h"
#import "CoinIDLIBInterface.h"
#import "CoinIDHelper+ETHSign.h"
#import "CoinIDTool.h"
#import "WalletObject.h"
#import "YCommonMethods.h"

@implementation CoinIDHelper


+(NSArray<NSString*>*)createWalletMemo:(MMemoCount )memoCount
                   memoType:(MMemoType )memoType{
    
    NSArray * localRemberWorld = [CoinIDTool fetchLocalRemberWorld:memoType];
    //获得索引数据
    NSArray * indexArrs = [CoinIDTool fetchRemberIndex:memoCount];
    NSMutableArray * memos = [NSMutableArray array ] ;
    for (int i = 0 ; i < indexArrs.count; i ++ ) {
        int tempdaa = [indexArrs[i] intValue];
        NSString * memo = localRemberWorld[tempdaa];
        [memos addObject:memo];
    }
    NSLog(@"生成的助记词 %@",[memos componentsJoinedByString:@","]);
    return memos ;
}

+(unsigned short*)fetchMemoIndex:(NSString*)memos{
    
    __block BOOL isok = NO ;
    BOOL isChar = NO;
    NSString * path = @"";
    memos = [memos stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSArray * contentArr = [memos componentsSeparatedByString:@" "];
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (int  i = 0 ; i < contentArr.count; i ++) {
        
        NSString * smallKey = [contentArr objectAtIndex:i] ;
        if (smallKey.length == 0) {
            continue ;
        }
        [arr addObject:smallKey];
    }
    if (arr.count == 12 || arr.count == 18 || arr.count == 24) {
        
        //判断词库
        isok = YES ;
        NSString * newRemberKey  = [arr firstObject];
        isChar = [CoinIDTool isChar:newRemberKey];
        if (isChar) {
            path = [[NSBundle mainBundle] pathForResource:@"english" ofType:@"txt"];
        }else{
            path = [[NSBundle mainBundle] pathForResource:@"chinese_simplified" ofType:@"txt"];
        }
        NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSArray * arrData = [content componentsSeparatedByString:@"\n"];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            NSString * objstring = obj ;
            if (![arrData containsObject:objstring]) {
                isok = NO;
                *stop = NO;
            }
        }];
        //获取索引
        if (isok) {
            u16 * memoIndexBuf = (u16*)malloc(24);
            for (int i = 0 ; i < arr.count; i ++ ) {
                NSString * objstring = arr[i] ;
                NSInteger index = [arrData indexOfObject:objstring];
                memoIndexBuf[i] = index ;
            }
            return memoIndexBuf;
        }
    }
    return NULL;
}

+(BOOL)checkMemoValid:(NSString*)memos {
    
    __block BOOL isok = NO ;
    BOOL isChar = NO;
    NSString * path = @"";
    memos = [memos stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSArray * contentArr = [memos componentsSeparatedByString:@" "];
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (int  i = 0 ; i < contentArr.count; i ++) {
        
        NSString * smallKey = [contentArr objectAtIndex:i] ;
        if (smallKey.length == 0) {
            continue ;
        }
        [arr addObject:smallKey];
    }
    if (arr.count == 12 || arr.count == 18 || arr.count == 24) {
        
        //判断词库
        isok = YES ;
        NSString * newRemberKey  = [arr firstObject];
        isChar = [CoinIDTool isChar:newRemberKey];
        if (isChar) {
            path = [[NSBundle mainBundle] pathForResource:@"english" ofType:@"txt"];
        }else{
            path = [[NSBundle mainBundle] pathForResource:@"chinese_simplified" ofType:@"txt"];
        }
        NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSArray * arrData = [content componentsSeparatedByString:@"\n"];
        NSMutableString * string = [NSMutableString string];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            NSString * objstring = obj ;
            if (![arrData containsObject:objstring]) {
                isok = NO;
                *stop = NO;
            }
        }];
        if (isok) {
            u16 memoIndexBuf[24] = {};
            //获取索引
            for (int i = 0 ; i < arr.count; i ++ ) {
                NSString * objstring = arr[i] ;
                NSInteger index = [arrData indexOfObject:objstring];
                memoIndexBuf[i] = index ;
            }
            u8 result = CoinID_checkMemoValid(memoIndexBuf, arr.count);
            if ((int)result != 1) {
                isok = NO ;
            }
        }
    }
    NSLog(@"助记词校验结果 %@",isok == YES ? @"通过":@"失败");
    return isok ;
}

+(NSArray *)importWalletFrom:(ImportObject *) object {

    NSMutableArray * datas = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * arrDatas = [NSMutableArray arrayWithCapacity:0];
    int coinType = object.mCoinType ;
    int leadType = object.mLeadType ;
    NSString * content = object.content ;
    int index = object.index ;
    NSString * PIN = object.pin ;
    NSLog(@"content %@ PIN %@ coinType %d leadType %d",content,PIN,coinType,leadType);
   /* if (coinType == MCoinType_All||coinType == MCoinType_BTC) {
        
        [datas addObject:[self importBTCWallet:object]];
    }
    */
    if (coinType == MCoinType_ETH) {
        
        [datas addObject:[self importETHWallet:object]];
    }
    
    NSString * masterPubKey = @"";
    if ( leadType == MLeadWalletType_StandardMemo) {
        masterPubKey=  [CoinIDTool CoinID_getMasterPubKey];
    }
    for (WalletObject * wallet in datas) {
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        NSString * prvKey = wallet.prvKey;
        NSString * subPrvKey = wallet.subPrvKey;
        prvKey = [CoinIDTool CoinID_EncByAES128CBC:prvKey pin:PIN];
        subPrvKey = [CoinIDTool CoinID_EncByAES128CBC:subPrvKey pin:PIN];
        dic[@"address"] = wallet.address;
        dic[@"prvKey"] = prvKey ;
        dic[@"pubKey"] = wallet.pubKey;
        dic[@"coinType"] = @(wallet.coinType);
        dic[@"subPrvKey"] = subPrvKey;
        dic[@"subPubKey"] = wallet.subPubKey ? wallet.subPubKey :@"";
        dic[@"masterPubKey"] = masterPubKey;
        [arrDatas addObject:dic];
    }
    return arrDatas ;
}

+(NSString*)fetchRandomString : (NSInteger) numbers {
    
    NSMutableString * randomNub = [NSMutableString string];
    for (int i = 0; i < numbers; i++) {
        
        unsigned char   a = (arc4random() % 255) + [[NSDate date] timeIntervalSince1970];
        [randomNub appendFormat:@"%02x",a];
    }
    if (randomNub.length > numbers * 2 ) {
        randomNub  = [randomNub substringToIndex:numbers * 2].mutableCopy;
    }
    return randomNub ;
}

+(NSString*)fetch_ExportKeyStore:(NSString*)pwd priKey:(NSString*)priKey coinType:(int)coinType {

    NSString * ksJson = @"";
    
    u8 * password =(u8*) [pwd UTF8String];
    u8 * salt  = (u8*)[[CoinIDHelper fetchRandomString:32] UTF8String] ;
    u8 * iv  = (u8*)[[CoinIDHelper fetchRandomString:16] UTF8String] ;
    u8 * uuid  = (u8*)[[CoinIDHelper fetchRandomString:16] UTF8String] ;
    u8 * privateKey ;
    privateKey = [CoinIDTool hexToBytes:priKey];
    u8 * json =  CoinID_exportKeyStore(privateKey, 32 , 0 , password , pwd.length , salt, iv, uuid);
    int tranLen = (int)strlen((char*)json) ;
    ksJson = [[NSString alloc] initWithBytes:json length:tranLen encoding:1];
    NSLog(@"keyStore %@",ksJson);
    return ksJson ;
}

+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

+  (NSString *)getHexByDecimal:(BigNumber *)tempStr{

    //10进制转换16进制（支持无穷大数）
//    tempStr = [BigNumber bigNumberWithDecimalString:@"1208925819614629174706175"]; ;
    
    BigNumber * cacheString = tempStr ;
    BigNumber * tempValue = [BigNumber bigNumberWithInteger:16] ;
    NSString * nLetterValue;
    NSString * str = @"";
    BigNumber * tempData = [BigNumber bigNumberWithInteger:0];
   
    for (int i = 0; i < cacheString.decimalString.length; i++) {
        tempData = [tempStr mod:tempValue];
        tempStr = [tempStr div:tempValue];
        switch (tempData.integerValue) {
            case 10:
                nLetterValue = @"A";
                break;
            case 11:
                nLetterValue = @"B";
                break;
            case 12:
                nLetterValue = @"C";
                break;
            case 13:
                nLetterValue = @"D";
                break;
            case 14:
                nLetterValue = @"E";
                break;
            case 15:
                nLetterValue = @"F";
                break;
            default:
                nLetterValue = tempData.decimalString ;
        }
        str = [nLetterValue stringByAppendingString:str];
        if ([tempStr isEqualTo:[BigNumber bigNumberWithInteger: 0]]) {
            break;
        }
    }
    
//    BigNumber * sumBig = [BigNumber constantZero];
//    NSDecimalNumber * deciOne = [NSDecimalNumber decimalNumberWithString:@"16"];
//    for (int i = 0 ; i < str.length; i ++ ) {
//
//        NSString * shortString = [str substringWithRange:NSMakeRange(str.length - i - 1, 1)];
//        if ([shortString isEqualToString:@"A"]) {
//            shortString = @"10";
//        }else if ([shortString isEqualToString:@"B"]){
//             shortString = @"11";
//        }else if ([shortString isEqualToString:@"C"]){
//             shortString = @"12";
//        }else if ([shortString isEqualToString:@"D"]){
//             shortString = @"13";
//        }else if ([shortString isEqualToString:@"E"]){
//             shortString = @"14";
//        }else if ([shortString isEqualToString:@"F"]){
//             shortString = @"15";
//        }
//        NSDecimalNumber * rasNumber  = [deciOne decimalNumberByRaisingToPower:i];
//        BigNumber * resultNumber = [[BigNumber bigNumberWithDecimalString:shortString] mul:[BigNumber bigNumberWithDecimalString:rasNumber.stringValue]];
//        sumBig = [sumBig add:resultNumber];
//    }
//    NSLog(@"sumbig %@",sumBig.decimalString);
    
    return str;
}

+ (NSMutableData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] %2 == 0) {
        range = NSMakeRange(0,2);
    } else {
        range = NSMakeRange(0,1);
    }
    for (NSInteger i = range.location; i < str.length; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}

+ (u8*) hexToBytes:(NSString*)string {
    
    u8 * hexprikey = (u8 *)malloc((int)[string length] / 2 + 1);
    bzero(hexprikey, [string length] / 2 + 1);
    if (string.length  == 0 ) {
        return hexprikey;
    }
    for (int i = 0; i < [string length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [string substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        hexprikey[i / 2] = (char)anInt;
    }
    
    return hexprikey ;
}


+(bool)CoinID_checkETHpushValid:(NSString*)pushStr to:(NSString*)to value:(NSString*)value decimal:(int)decimal isContract:(bool)isContract contraAddr:(NSString*)contraAddr {
    
    string pushData = "";
    string toData = "" ;
    string valueData = "";
    string contraAddrData = "";
    
    if (pushStr) {
        pushData = [pushStr UTF8String];
    }
    if (to) {
        toData = [to UTF8String];
    }
    if (value) {
        valueData = [value UTF8String];
    }
    if (contraAddr) {
       contraAddrData = [contraAddr UTF8String];
    }

    return CoinID_checkETHpushValid(pushData, toData, valueData, decimal, isContract, contraAddrData);
}

+ (NSString *)reverseCode:(u8[] )toValue
{
    NSString *temp = [[NSString alloc] init];
    for (int i = 0; i < 32; i++)
    {
        int panValue = toValue[i];
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%02X",0xFF^panValue]];
        
    }
    return temp;
}

+(NSString*)getNumberFromHex:(NSString*)str{
    
    str  = [str stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    str = [str uppercaseString];
    BigNumber * sumBig = [BigNumber constantZero];
    BigNumber * deciOne = [BigNumber bigNumberWithInteger:16];
    for (int i = 0 ; i < str.length; i ++ ) {

        NSString * shortString = [str substringWithRange:NSMakeRange(str.length - i - 1, 1)];
        if ([shortString isEqualToString:@"A"]) {
            shortString = @"10";
        }else if ([shortString isEqualToString:@"B"]){
            shortString = @"11";
        }else if ([shortString isEqualToString:@"C"]){
            shortString = @"12";
        }else if ([shortString isEqualToString:@"D"]){
            shortString = @"13";
        }else if ([shortString isEqualToString:@"E"]){
            shortString = @"14";
        }else if ([shortString isEqualToString:@"F"]){
            shortString = @"15";
        }
        BigNumber * rasNumber  = [BigNumber constantOne];
        for (int a = 0 ; a < i; a ++ ) {
           rasNumber = [rasNumber  mul:deciOne];
        }
        BigNumber * resultNumber = [[BigNumber bigNumberWithDecimalString:shortString] mul:[BigNumber bigNumberWithDecimalString:rasNumber.decimalString]];
        sumBig = [sumBig add:resultNumber];
    }
    NSLog(@"sumbig %@",sumBig.decimalString);
    return sumBig.decimalString.length > 0 ? sumBig.decimalString : @"0" ;
//    return @"";
}
@end
