//
//  ScanVC.h
//  CoinID
//
//  Created by 新明华区块链技术（深圳）有限公司 on 2018/8/1.
//  Copyright © 2018年 新明华区块链技术（深圳）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBXScanViewController.h"

typedef void(^ScanComplation)(id content);
typedef NS_ENUM(NSInteger, YScanType) {
    YScanType_NotInit ,
    YScanType_Transfer,   //交易
    YScanType_Lead,     //导入
    YScanType_Address , //地址管理
};

@interface ScanVC : LBXScanViewController

@property (nonatomic,assign) YScanType scanType; //类型

@property (nonatomic,copy) ScanComplation ScanComplation ; //回调


@end
