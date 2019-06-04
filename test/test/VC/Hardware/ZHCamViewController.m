//
//  ZHCamViewController.m
//  test
//
//  Created by rrjj on 2019/5/30.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHCamViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZHAVDeviceManager.h"
#import "ZHCamHeadView.h"
#import <Masonry.h>
@interface ZHCamViewController ()<ZHScanOutPutMetaDelegate>

@property (nonatomic,strong) ZHAVDeviceManager *dManager;

@property (nonatomic,strong) UILabel *resultLabel;


@end

@implementation ZHCamViewController
#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initHead];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = YES;
    [self.dManager startRunning];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.dManager stopRunning];
}

-(void)dealloc
{
    NSLog(@"%s",__func__);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - private
- (void)initHead{
    __weak typeof(self) weakSelf = self;
    [self.dManager initWithFrame:[UIScreen mainScreen].bounds view:self.view];
    ZHCamHeadView *head = [ZHCamHeadView shareHeadView];
    [self.view addSubview:head];
    head.block = ^{
        if (weakSelf.reserveValue) {
            weakSelf.reserveValue(nil);
        }
        [DCURLRouter popViewControllerAnimated:YES];
    };
    self.resultLabel = [[UILabel alloc] init];
    [self.view addSubview:self.resultLabel];
    self.resultLabel.numberOfLines = 0;
    
    [head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(isIPhoneX ? 20:0);
        make.left.equalTo(self.view).offset(0);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(64);
    }];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(head.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(15);
    }];
}

#pragma mark - ZHScanOutPutMetaDelegate
-(void)ZHScanDataWithArray:(NSArray<__kindof AVMetadataObject *> *)array
{
    
    __weak typeof(self) weakSelf = self;
    NSString *result = @"";
    for (AVMetadataMachineReadableCodeObject *obj in array) {
        NSLog(@"码数据:%@",obj.stringValue);
        NSLog(@"码类型:%@",obj.type);
        result = [result stringByAppendingFormat:@"%@ %@",obj.stringValue,obj.type];
    }
    
    self.resultLabel.text = result;
    if (weakSelf.reserveValue) {
        weakSelf.reserveValue(result);
    }
    [DCURLRouter popViewControllerAnimated:YES];
}

#pragma mark - lazy
- (ZHAVDeviceManager *)dManager
{
    if (!_dManager) {
        _dManager = [ZHAVDeviceManager shareManager];
        _dManager.delegate = self;
    }
    return _dManager;
}

@end
