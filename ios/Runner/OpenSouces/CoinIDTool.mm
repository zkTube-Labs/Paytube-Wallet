//
//  CoinIDTool.m
//  Runner
//
//  Created by MWT on 2/11/2020.
//

#import "CoinIDTool.h"
#import "CoinIDLIBInterface.h"

NS_ASSUME_NONNULL_BEGIN

@implementation CoinIDTool

+ (NSString *)deleteBlankAndEnter:(NSString *)string
{
    NSString *newString= [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    newString= [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return newString;
}

+ (NSData *)convertDataWithMasterStrings:(NSString *)remberStrings{
    
    NSString * memos = [CoinIDTool deleteBlankAndEnter:remberStrings];
    NSStringEncoding  gb2312enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    if ([CoinIDTool isChar:memos]) {
        return [memos dataUsingEncoding:NSASCIIStringEncoding];
    }
    return [memos dataUsingEncoding:gb2312enc];
}

+ (bool)CoinID_SetMasterStandard:(NSString *)mnemonicBuffer{
    
    return CoinID_SetMasterStandard([mnemonicBuffer UTF8String]);
}

+ (unsigned char *)CoinID_deriveKeyByPath:(NSString *)path{
    
    string pathChar = "";
    if (path) {
        pathChar = [path UTF8String];
    }
    string prvAndpubKey = CoinID_deriveKeyByPath(pathChar);
    NSString * prvAndpubKeyStr = [NSString stringWithCString:prvAndpubKey.c_str() encoding:4];
    return [self hexToBytes:prvAndpubKeyStr];
}

+(NSString*)CoinID_cvtAddrByEIP55:(NSString*)address {
    
    string addressStr = "" ;
    if (address) {
        address = [address stringByReplacingOccurrencesOfString:@"0x" withString:@""];
        addressStr = [address UTF8String];
    }
    string newAdress = CoinID_cvtAddrByEIP55(addressStr);
    NSString * newAddressStr = [NSString stringWithCString: (char*)newAdress.c_str() encoding:4];
    return newAddressStr ;
}

#pragma mark - 获得助记词需要的随机数
+(NSString*)fetchMemoRandomString : (NSInteger) Places{
    
    NSMutableString * randomNub = [NSMutableString string];
    for (int i = 0; i < Places + 1; i++) {
        unsigned char a = (arc4random() % 255 + [[NSDate date] timeIntervalSince1970]);
        if ([randomNub containsString:[NSString stringWithFormat:@"%c",a]]) {
            
            while([randomNub containsString:[NSString stringWithFormat:@"%c",a]])
            {
                a = (arc4random() % 255 + [[NSDate date] timeIntervalSince1970]);
            }
        }
        [randomNub appendFormat:@"%c",a];
    }
    return randomNub ;
}

#pragma mark - 获得本地词库需要的索引
+(NSArray*)fetchRemberIndex :(MMemoCount)count {
    
    NSMutableArray * num = [NSMutableArray arrayWithCapacity:0];
    NSInteger interspace = count * 2 ;
    NSInteger space = (count /3) *4 ;//16
    NSData *data = [[self fetchMemoRandomString:space] dataUsingEncoding:NSUTF8StringEncoding];   //asic
    unsigned char empty_y[interspace];
    NSNumber *nub = 0 ;
    BOOL isRepeat = YES ;
    while (isRepeat) { //去重
        NSString * time = [self fetchMemoRandomString:space];
        data = [time dataUsingEncoding:NSUTF8StringEncoding];   //asic
        num = [NSMutableArray arrayWithCapacity:0];
        CoinID_generateMnemonicIndex((unsigned char *)[data bytes], space, empty_y);
        for(int i =0;i < interspace;i+=2)
        {
            unsigned short tempdaa = (empty_y[i] << 8);
            tempdaa|=empty_y[i + 1];
            nub = [NSNumber numberWithInt:tempdaa];
            if ([num containsObject:nub]) {
                isRepeat = YES;
                
            }else{
                [num addObject:nub];
                isRepeat = NO;
            }
        }
        if (num.count == interspace /2) {
            isRepeat = NO;
        }else{
            isRepeat = YES;
        }
    }
    return num;
}

#pragma mark - 获得根据类型获得本地词库
+(NSArray*)fetchLocalRemberWorld:(MMemoType)memoType{
    
    NSString * path = @"";
    if (memoType == MMemoType_English) {
        path = [[NSBundle mainBundle] pathForResource:@"english" ofType:@"txt"];
    }else if (memoType == MMemoType_Chinese){
        path = [[NSBundle mainBundle] pathForResource:@"chinese_simplified" ofType:@"txt"];
    }
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray * arrData = [content componentsSeparatedByString:@"\n"];
    return arrData ;
}

+ (BOOL)isChar:(NSString*)string {
    
    NSString * zc_char = @"^[a-zA-Z]+$";//纯字母
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", zc_char];
    return [predicate evaluateWithObject:string];
}

+ (unsigned char *) hexToBytes:(NSString*)string{
    
    unsigned char * hexprikey = (unsigned char *)malloc((int)[string length] / 2 + 1);
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

+(NSString*)formtterWithChar:(unsigned char*)data{
    
    int i = 0;
    NSMutableString *str = [NSMutableString string];
    while(data[i] != '\0')
    {
        [str appendFormat:@"%c",data[i]];
        i++;
    }
    return str ;
}

+(NSString*)beginHexString:(int)count data:(unsigned char *)data{
    
    NSMutableString * prvString = @"".mutableCopy;
    int i = 0 ;
    bool isok = true;
    while(isok)
    {
        [prvString appendFormat:@"%02x",data[i]];
        i++ ;
        if (i== count) {
            isok = false;
        }
    }
    return prvString ;
}
+(BOOL)isHexETHPrvKey:(NSString*)content {
    
    return [self convertHexRegex:content number:64];
}

+(BOOL)isHexBTMPrvKey:(NSString*)content {
    
    return [self convertHexRegex:content number:128];
}

+(BOOL)convertHexRegex:(NSString*)content number:(int)nsnumber{
    
    NSString *regex = [NSString stringWithFormat:@"^[0-9A-Fa-f]{%d}+$",nsnumber];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:content];
    if (!isMatch) {
        NSLog(@"hex 校验失败");
        return NO;
    }
    NSLog(@"hex 校验成功");
    return YES ;
}

+(NSString*)CoinID_getMasterPubKey {
    
    u8 * pubkey = CoinID_getMasterPubKey();
    return  [self formtterWithChar:pubkey];
}

+(NSString*)CoinID_EncByAES128CBC:(NSString *) input pin:(NSString*)pin {
    
    if (input.length <= 0) {
        return @"";
    }
    NSData * data = [input dataUsingEncoding:4];
    NSData * pinData = [pin dataUsingEncoding:4];
    u8 * pinu8 = (u8*)malloc(16);
    memset((void*)pinu8, 0, 16);
    if (pinData.length > 16 )
    {
        memcpy(pinu8, (u8 * )[pinData bytes], 16 );
    }
    else
    {
        memcpy(pinu8, (u8 * )[pinData bytes], pinData.length );
    }
    int outputLen = (data.length + 16) & 0xff0 ;
    unsigned char * output = ( unsigned char *)malloc(outputLen);
    int len = CoinID_EncByAES128CBC((u8*)[data bytes], data.length, pinu8, output);
    return [self beginHexString:outputLen data:output];
}
+(NSString*)CoinID_DecByAES128CBC:(NSString *) value pin:(NSString*)pin {
    
    if (value.length <= 0) {
        return @"";
    }
    int inputLen = value.length / 2 ;
    unsigned char * inputValue = [self hexToBytes:value];
    NSData * pinData = [pin dataUsingEncoding:4];
    int outputLen = (inputLen + 16) & 0xff0 ;
    unsigned char * output = ( unsigned char *)malloc(outputLen);
    u8 * pinu8 = (u8*)malloc(16);
    memset((void*)pinu8, 0, 16);
    if (pinData.length > 16 )
    {
        memcpy(pinu8, (u8 * )[pinData bytes], 16 );
    }
    else
    {
        memcpy(pinu8, (u8 * )[pinData bytes], pinData.length );
    }
    int realL  = CoinID_DecByAES128CBC(inputValue, inputLen  , pinu8 , output) ;
    return [[NSString alloc] initWithBytes:output length:realL encoding:4] ;
}

+(bool)CoinID_checkAddressValid:(NSString *) chainType address:(NSString*)address {
    
    bool status =  CoinID_checkAddressValid([chainType UTF8String], [address UTF8String]);
    return status ;
}

+(NSString * )CoinID_sigETH_TX_by_str:(NSDictionary*)params{
    
    string nonce = [params[@"nonce"] UTF8String];
    string gasPrice = [params[@"gasprice"] UTF8String];
    string gasLimit = [params[@"startgas"] UTF8String];
    string to = [params[@"to"] UTF8String];
    string value = [params[@"value"] UTF8String];
    string data = [params[@"data"] UTF8String];
    string chainID = [params[@"chainId"] UTF8String];
    string prvKey = [params[@"prvKey"] UTF8String];
    string sign  = CoinID_sigETH_TX_by_str(nonce, gasPrice, gasLimit, to, value, data, chainID, prvKey);
    return  [NSString stringWithCString:sign.c_str() encoding:4];
}

+(bool)CoinID_checkETHpushValid:(NSDictionary*)params{
    
    string pushStr = [params[@"pushStr"] UTF8String];
    string to = [params[@"to"] UTF8String];
    string value = [params[@"value"] UTF8String];
    int decimal = [params[@"decimal"] intValue] ;
    NSString * contract = params[@"contractAddr"];
    bool isContract = false;
    string contractAddr = "";
    if (contract.length > 0 ) {
        isContract = true ;
        contractAddr = [contract UTF8String];
    }
    return CoinID_checkETHpushValid(pushStr, to, value, decimal, isContract, contractAddr);
}

+(NSString*)CoinID_sigtBTCTransaction:(NSDictionary*)params{
    
    NSString * jsonStr = params[@"jsonTran"];
    u8 * jsonTran = (u8*)[jsonStr UTF8String];
    int jsonLen = (int)strlen((char*)jsonTran) ;
    NSString * prvKey = params[@"prvKey"];
    NSData * prvData = [prvKey dataUsingEncoding:1];
    u8 * priChar =  (u8*)[prvData bytes];
    u8 * prvKeyAndPubKey  = CoinID_ImportBTCPrvKeyByWIF(priChar, prvData.length) ;
    u8 * wifPrv = (u8*)malloc(32);
    memcpy(wifPrv, prvKeyAndPubKey, 32);
    u8 * dataJson = CoinID_sigtBTCTransaction(jsonTran, jsonLen, wifPrv);
    return [CoinIDTool formtterWithChar:dataJson];
}

+(bool)CoinID_checkBTCpushValid:(NSDictionary*)params{
    
    string pushStr = [params[@"pushStr"] UTF8String];
    string to = [params[@"to"] UTF8String];
    string toValue = [params[@"toValue"] UTF8String];
    string from = [params[@"from"] UTF8String];
    string fromValue = [params[@"fromValue"] UTF8String];
    string usdtValue = [params[@"usdtValue"] UTF8String];
    string coinType = [params[@"coinType"] UTF8String];
    bool isSegwit = [params[@"isSegwit"] boolValue];
    return CoinID_checkBTCpushValid(pushStr, to, toValue, from, fromValue, usdtValue, coinType, isSegwit);
}

+(NSString*)CoinID_sigtBYTOMTransaction:(NSDictionary*)params{
    
    u8 * jsonTran = (u8*)[params[@"jsonTran"] UTF8String];
    NSString * prvKey = params[@"prvKey"] ;
    u8 * prvkey  = [CoinIDTool hexToBytes:prvKey] ;
    u8 * sign = CoinID_sigtBYTOMTransaction(jsonTran, prvkey);
    return [CoinIDTool formtterWithChar:sign];
}

+(NSString*)CoinID_getBYTOMCode:(NSDictionary*)params{
    
    string add = [params[@"address"] UTF8String];
    string code =  CoinID_getBYTOMCodeStr(add);
    return [NSString stringWithCString:code.c_str() encoding:4];
}

+(bool) CoinID_checkBYTOMpushValid:(NSDictionary*)params{
    
    string pushStr = [params[@"pushStr"] UTF8String];
    string to = [params[@"to"] UTF8String];
    string toValue = [params[@"toValue"] UTF8String];
    string from = [params[@"from"] UTF8String];
    string fromValue = [params[@"fromValue"] UTF8String];
    return CoinID_checkBYTOMpushValid(pushStr, to, toValue, from, fromValue);
}

+(NSString*) CoinID_GetTranSigJson:(NSDictionary*)params{
    
    NSString * jsonStr = params[@"jsonTran"];
    u8 * jsonTran = (u8*)[jsonStr UTF8String];
    int jsonLen = (int)strlen((char*)jsonTran) ;
    NSString * prvKey = params[@"prvKey"];
    NSData * prvData = [prvKey dataUsingEncoding:1];
    u8 * priChar =  (u8*)[prvData bytes];
    u8 * prvKeyAndPubKey  = CoinID_ImportEOSPrvKey(priChar, prvData.length);
    u8 * wifPrv = (u8*)malloc(32);
    memcpy(wifPrv, prvKeyAndPubKey, 32);
    u8 * rtnJson =  CoinID_GetTranSigJson(jsonTran, jsonLen, wifPrv);
    return [CoinIDTool formtterWithChar:rtnJson];
}

+(bool) CoinID_checkEOSpushValid:(NSDictionary*)params{
    
    string pushStr = [params[@"pushStr"] UTF8String];
    string to = [params[@"to"] UTF8String];
    string value = [params[@"value"] UTF8String];
    string unit = [params[@"unit"] UTF8String];
    return  CoinID_checkEOSpushValid(pushStr, to, value, unit);
}

+(NSString*) CoinID_genBTCAddress:(NSDictionary*)params{
    
    NSString * prvKey = params[@"prvKey"];
    u8 * prvStr = (u8*)[prvKey UTF8String];
    bool segwit = [params[@"segwit"] boolValue];
    u8 * prvKeyAndPubKey  = CoinID_ImportBTCPrvKeyByWIF(prvStr, prvKey.length);
    if (prvKeyAndPubKey == NULL) {
        return @"";
    }
    u8 * publickey = (u8*)malloc(65);
    memcpy(publickey, prvKeyAndPubKey + 32, 65);
    u8 * exportPubkey ;
   
    if (segwit == 0) {
        //普通
        exportPubkey  = CoinID_genBTCAddress(0, publickey, 33, 0);
    }else{
        //隔离
        exportPubkey  = CoinID_genBTCAddress(5, publickey, 33, 3);
    }
    return [self formtterWithChar:exportPubkey];
}

+(NSString*)CoinID_filterUTXO:(NSDictionary*)params{
    
    string utxoJson = [params[@"utxoJson"] UTF8String];
    string amount = [params[@"amount"] UTF8String];
    string fee = [params[@"fee"] UTF8String];
    int quorum = [params[@"quorum"] intValue];
    int num = [params[@"num"] intValue];
    string type = [params[@"type"] UTF8String];
    string value  = CoinID_filterUTXO(utxoJson, amount, fee, quorum, num, type);
    return  [NSString stringWithCString:value.c_str() encoding:4];
}

+(NSString*)CoinID_genScriptHash:(NSDictionary*)params{
    
    string address = [params[@"address"] UTF8String];
    string value = CoinID_genScriptHashStr(address);
    return [NSString stringWithCString:value.c_str() encoding:4];
}

+(NSString*)CoinID_sigPolkadotTransaction:(NSDictionary*)params{
    
    string jsonTran = [params[@"jsonTran"] UTF8String];
    string prvKey = [params[@"prvKey"] UTF8String];
    string pubKey = [params[@"pubKey"] UTF8String];
    string sign = CoinID_sigPolkadotTransaction(jsonTran, prvKey, pubKey);
    return [NSString stringWithCString:sign.c_str() encoding:4];
}

+(NSString*)CoinID_polkadot_getNonceKey:(NSDictionary*)params{
    
    string address = [params[@"address"] UTF8String];
    string nonce = CoinID_polkadot_getNonceKey(address);
    return [NSString stringWithCString:nonce.c_str() encoding:4];
}

@end
NS_ASSUME_NONNULL_END
