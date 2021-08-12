//
//  Enum.h
//  Runner
//
//  Created by MWT on 27/7/2020.
//

#ifndef Enum_h
#define Enum_h

//交易币的类型
typedef NS_ENUM(NSInteger,MCoinType) {
  MCoinType_ETH,
};

typedef NS_ENUM(NSInteger,MLeadWalletType) {
    MLeadWalletType_PrvKey,
    MLeadWalletType_KeyStore,
    MLeadWalletType_StandardMemo,
};

typedef NS_ENUM(NSInteger,MOriginType) {
    MOriginType_Create, //创建
    MOriginType_Restore, //恢复
    MOriginType_LeadIn, //导入
    MOriginType_Colds, //冷
    MOriginType_NFC, //nfc
    MOriginType_MultiSign, //预留多签
};

//助记词类型
typedef NS_ENUM(NSInteger,MMemoType) {
    MMemoType_Chinese,
    MMemoType_English ,
};

//助记词个数
typedef NS_ENUM(NSInteger,MMemoCount) {
    MMemoCount_12  = 12,
    MMemoCount_18  = 18,
    MMemoCount_24  = 24,
};

typedef NS_ENUM(NSInteger,URLLoadType) {
  
    URLLoadType_Links,
    URLLoadType_Bancor,
    URLLoadType_DomainName,
    URLLoadType_VUSD
};

typedef NS_ENUM(NSInteger,YVerifyPasswordState) {
    //cancle
    //wrong
    //ok
    YVerifyPasswordState_Cancle,
    YVerifyPasswordState_Wrong,
    YVerifyPasswordState_Ok,
};

//主屏宽
#define KSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//主屏高
#define KSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#if (defined(DEBUG))
#define NSLog(format, ...) printf("class(类名): <%p %s:(第%d行) > method(方法名): %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define NSLog(format, ...)
#endif

#define IS_IPHONE_4_OR_LESS (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)
//判断是否是iPhone5
#define IS_IPHONE_5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
//判断是否是iPhone6
#define IS_IPHONE_6 (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)
//判断是否是iPhone6plush
#define IS_IPHONE_6P (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)
//判断是否是iPhoneX
#define IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height-812)?NO:YES)

/**根据6为标准适配 宽*/

#define WEAK(obj) __weak typeof(obj) weakObject = obj;
#define STRONG(obj) __strong typeof(obj) strongObject = weakObject;

#define ClearBackColor [UIColor clearColor]
#define fontWhiteColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]
#define MainColor [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0]
#define SecondColor [UIColor colorWithRed:172/255.0 green:187/255.0 blue:207/255.0 alpha:1.0]
#define LineBackgroundColor [YCommonMethods colorWithHexString:@"#2C2C2C"]
#define NewTextColor [YCommonMethods colorWithHexString:@"#586883"]
#define NewBackColor [UIColor colorWithRed:246/255.0 green:249/255.0 blue:252/255.0 alpha:1]
#define Font_Regular @"PingFangSC-Regular"
#define Font_Medium @"PingFangSC-Medium"
#define Font_Semibold @"PingFangSC-Semibold"
#define LBXScan_Define_UI 

#define YLOCALIZED_UserVC(key) NSLocalizedStringFromTableInBundle(key, @"UserVC",[YCommonMethods fetchCurrentLanguageBundle], nil)

#endif /* Enum_h */
