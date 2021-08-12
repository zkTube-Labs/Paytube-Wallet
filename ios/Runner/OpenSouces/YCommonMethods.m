//
//  YCommonMethods.m
//  CoinID
//
//  Created by Wind on 2018/8/27.
//  Copyright © 2018年 新明华区块链技术（深圳）有限公司. All rights reserved.
//

#import "YCommonMethods.h"
#import "Enum.h"
#import "UIDevice+FCUUID.h"
#import <CommonCrypto/CommonDigest.h>
#import "BigNumber.h"
#define LANGUAGE_SET @"langeuageset"
@implementation YCommonMethods

+ (NSString *)deleteBlank:(NSString *)string
{
    NSString *newString= [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newString;
}

+ (NSString *)deleteBlankAndEnter:(NSString *)string
{
    NSString *newString= [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    newString= [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return newString;
}

+ (BOOL)isChinese:(NSString*)string
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}

+ (BOOL)isChar:(NSString*)string {
    
    NSString * zc_char = @"^[a-zA-Z]+$";//纯字母
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", zc_char];
    return [predicate evaluateWithObject:string];
}

+ (double)adaptationIphone6Height:(double)height {
//    if (IS_IPHONE_6) {
//        return height;
//    }else if (IS_IPHONE_6P){
//        return height * 1.10;
//    }else if (IS_IPHONE_5){
//        return height * 0.85;
//    }else if (IS_IPHONE_4_OR_LESS){
//        return height * 0.72;
//    }
    
    if (IS_IPHONEX) {
        return height;
    }else if (IS_IPHONE_6){
        return height * 0.8;
    }else if (IS_IPHONE_5){
        return height * 0.85 * 0.9;
    }else if (IS_IPHONE_4_OR_LESS){
        return height * 0.72 * 0.9;
    }else if (IS_IPHONE_6P){
        return height * 0.91;
    }
    return height;
}

+ (double)adaptationIphone6Width:(double)width{
    if (IS_IPHONE_6) {
        return width;
    }else if (IS_IPHONE_6P){
        return width * 1.10;
    }else if (IS_IPHONE_5){
        return width * 0.85;
    }else if (IS_IPHONE_4_OR_LESS){
        return width * 0.72;
    }
//    if (IS_IPHONEX) {
//        return width;
//    }else if (IS_IPHONE_6P){
//        return width * 1.10;
//    }else if (IS_IPHONE_5){
//        return width * 0.85;
//    }else if (IS_IPHONE_4_OR_LESS){
//        return width * 0.72;
//    }
    return width;
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    return [[self class] colorWithHexString:hexString alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    // Check for hash and add the missing hash
    if('#' != [hexString characterAtIndex:0])
    {
        hexString = [NSString stringWithFormat:@"#%@", hexString];
    }
    
    // check for string length
    assert(7 == hexString.length || 4 == hexString.length);
    
    // check for 3 character HexStrings
    hexString = [[self class] hexStringTransformFromThreeCharacters:hexString];
    
    NSString *redHex    = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(1, 2)]];
    unsigned redInt = [[self class] hexValueToUnsigned:redHex];
    
    NSString *greenHex  = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(3, 2)]];
    unsigned greenInt = [[self class] hexValueToUnsigned:greenHex];
    
    NSString *blueHex   = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(5, 2)]];
    unsigned blueInt = [[self class] hexValueToUnsigned:blueHex];
    
    UIColor *color = [[self class]  colorWith8BitRed:redInt green:greenInt blue:blueInt alpha:alpha];
    
    return color;
}

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    return [[self class] colorWith8BitRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha
{
    UIColor *color = nil;
#if (TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE)
    color = [UIColor colorWithRed:(float)red/255 green:(float)green/255 blue:(float)blue/255 alpha:alpha];
#else
    color = [UIColor colorWithCalibratedRed:(float)red/255 green:(float)green/255 blue:(float)blue/255 alpha:alpha];
#endif
    
    return color;
}

+ (NSString *)hexStringTransformFromThreeCharacters:(NSString *)hexString
{
    if(hexString.length == 4)
    {
        hexString = [NSString stringWithFormat:@"#%@%@%@%@%@%@",
                     [hexString substringWithRange:NSMakeRange(1, 1)],[hexString substringWithRange:NSMakeRange(1, 1)],
                     [hexString substringWithRange:NSMakeRange(2, 1)],[hexString substringWithRange:NSMakeRange(2, 1)],
                     [hexString substringWithRange:NSMakeRange(3, 1)],[hexString substringWithRange:NSMakeRange(3, 1)]];
    }
    
    return hexString;
}

+ (unsigned)hexValueToUnsigned:(NSString *)hexValue
{
    unsigned value = 0;
    
    NSScanner *hexValueScanner = [NSScanner scannerWithString:hexValue];
    [hexValueScanner scanHexInt:&value];
    
    return value;
}

+ (UIColor *)colorWithRGB:(CGFloat)R G:(CGFloat)G B:(CGFloat)B {
    
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}

+ (UIColor *)colorWithRGB:(CGFloat)R G:(CGFloat)G B:(CGFloat)B alpha:(CGFloat)alpha{
    
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:alpha];
}

+(NSDictionary *)addHeaderBaseParams {
    
    //8 bit version  32 bits uuid  32 bits package 32bits ipa file md5
    NSMutableData * data = [NSMutableData data] ;
    char * headParams = (char*)malloc(104);
    memset(headParams, 0, 104);
    
    char *  version   = (char *) [[self fetchCurrentShortVersion] UTF8String];
    int verLen = (int) strlen(version) ;
    memcpy(headParams, version, verLen) ;
    char * uuid = ( char *) [[self getUUID] UTF8String];
    memcpy(headParams + 8, uuid, 32) ;

    char * bundleid = (char *) [[[NSBundle mainBundle] bundleIdentifier]UTF8String];
    int bunLen = (int)strlen((char*)bundleid) ;
    memcpy(headParams + 40, bundleid, bunLen) ;
    NSString * fileMD5 = [self MD5:[self getUUID]];
    char * fileM = (char *) [fileMD5 UTF8String];
    memcpy(headParams + 72, fileM, 32) ;

    [data appendBytes:headParams length:104];
    
    NSString * base64 = [data.copy base64EncodedStringWithOptions:0];
    
    NSString * lanString = @"zh" ;
    NSDictionary * aheaderDic = @{@"info":base64,@"language":lanString};
    return aheaderDic;
}
+(NSString*)fetchCurrentShortVersion{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return  [infoDictionary objectForKey:@"CFBundleShortVersionString"] ;
}
+(NSString*)getUUID{
   
    return  [[UIDevice currentDevice]uuid] ;
}

+(NSString*)MD5:(NSString *) value {
    const char *cStr = value.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *md5Str = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
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

+(NSBundle*)fetchCurrentLanguageBundle {
    
    NSString * lanageString = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE_SET];
    NSString *path = nil ;
    NSBundle * bundle  = nil ;
    if (lanageString) {
        path = [[NSBundle mainBundle]pathForResource:lanageString ofType:@"lproj"];
        bundle = [NSBundle bundleWithPath:path];
        return bundle ;
    }
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSString * languageString = @"" ;
    if ([currentLanguage containsString:@"en"]) {
        languageString = @"en" ;
    }else if ([currentLanguage isEqualToString:@"zh-Hans"]){
        languageString = @"zh-Hans" ;
    }else{
         languageString = @"zh-Hans" ;
    }
    path = [[NSBundle mainBundle]pathForResource:languageString ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
    return bundle ;
}
@end
