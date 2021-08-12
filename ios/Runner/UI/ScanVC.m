//
//  ScanVC.m
//  CoinID
//
//  Created by 新明华区块链技术（深圳）有限公司 on 2018/8/1.
//  Copyright © 2018年 新明华区块链技术（深圳）有限公司. All rights reserved.
//

#import "ScanVC.h"
#import "UIView+Additions.h"
#import "LBXScanTypes.h"
#import "Enum.h"
@interface ScanVC (){
//    SGQRCodeObtain * obtain;
}
//@property (nonatomic, strong) SGQRCodeScanView *scanView;
@property (nonatomic, strong) UIButton *flashlightBtn;  //上光灯
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UIView *bottomView;
@end


@implementation ScanVC

- (void)dealloc {
    NSLog(@"WCQRCodeVC - dealloc");
//    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.libraryType = SLT_Native ;
    self.isOpenInterestRect = YES ;
    [self reStartDevice];
    [self addNavBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /// 二维码开启方法
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)addNavBar
{
    //返回
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage: [[UIImage imageNamed:@"arrow_white_left"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]forState:UIControlStateNormal];
    
    if (IS_IPHONEX) {
        
        left.frame = CGRectMake(22, 54, 40,40);
    }
    else
    {
        left.frame = CGRectMake(22, 34, 40,40);
    }
    
    [left addTarget:self action:@selector(backtrack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:left];
    
    //打开相册
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setImage:[UIImage imageNamed:@"pointW"] forState:UIControlStateNormal];
    if (IS_IPHONEX) {
        right.frame = CGRectMake(KSCREEN_WIDTH - 63, 54, 40,40);
    }
    else
    {
        right.frame = CGRectMake(KSCREEN_WIDTH - 63, 34, 40,40);
    }
    
    [right addTarget:self action:@selector(openPhoto)forControlEvents:UIControlEventTouchUpInside];
    [self.qRScanView addSubview:right];
    
    //标题
    UILabel *lab = [[UILabel alloc] init];
    
    if (IS_IPHONEX) {
        
        lab.frame = CGRectMake(self.view.centerX - 75, 55, 150, 28);
        
    }
    else
    {
        lab.frame = CGRectMake(self.view.centerX - 75, 35, 150, 28);
    }
    
    lab.text = @"扫码";
    lab.font = [UIFont fontWithName:@"Semiboldr" size:18];
    lab.textColor = fontWhiteColor;
    lab.textAlignment = NSTextAlignmentCenter;
    [self.qRScanView addSubview:lab];
    [self.qRScanView addSubview:self.promptLabel];
    [self.qRScanView addSubview:self.flashlightBtn];
}

-(void)openPhoto{
    
    [self openLocalPhoto:YES];
    
}

-(void)backtrack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)flashlightBtn_action
{
    [self openOrCloseFlash];
}
#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (!array ||  array.count < 1){
        NSLog(@"暂未识别出二维码");
//        [UIViewController showInfoWithStatus:YLOCALIZED_UserVC(@"scanvc_unfondcode")];
        return;
    }
    LBXScanResult *scanResult = array[0];
    NSString*strResult = scanResult.strScanned;
    if (!strResult) {
        NSLog(@"暂未识别出二维码");
//        [UIViewController showInfoWithStatus:YLOCALIZED_UserVC(@"scanvc_unfondcode")];
        return;
    }
    [self renderUrlStr:strResult];
}


#pragma mark  输出扫描字符串
- (void)renderUrlStr:(NSString *)url {
    
    if (!url || url.length == 0) {
        
    }
    NSLog(@"扫描的内容 %@",url);
    [self.navigationController popViewControllerAnimated:true];
    if (_ScanComplation) {
        _ScanComplation(url);
    }
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 30;
        CGFloat promptLabelY = 0.68 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width - 60;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:12];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
        _promptLabel.numberOfLines = 0;
        
        _promptLabel.text = @"请将镜头对准二维码进行扫描" ;
    }
    return _promptLabel;
}


#pragma mark - - - 闪光灯按钮
- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        // 添加闪光灯按钮
        _flashlightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat flashlightBtnW = 120;
        CGFloat flashlightBtnH = 80;
        CGFloat flashlightBtnX = 0.5 * (self.view.frame.size.width - flashlightBtnW);
        CGFloat flashlightBtnY = 0.68 * self.view.frame.size.height + 25+50;
        _flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        [_flashlightBtn setImage:[UIImage imageNamed:@"SGQRCodeFlashlightOpenImage"] forState:(UIControlStateNormal)];
        [_flashlightBtn setImage:[UIImage imageNamed:@"SGQRCodeFlashlightCloseImage"] forState:(UIControlStateSelected)];
        [_flashlightBtn setTitle:@"打开手电筒" forState:UIControlStateNormal];
        _flashlightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_flashlightBtn setTitleColor:fontWhiteColor forState:UIControlStateNormal];
//        [_flashlightBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsImageStyleTop imageTitlespace:10];
        [_flashlightBtn addTarget:self action:@selector(flashlightBtn_action) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashlightBtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
