//
//  ZHAVDeviceManager.m
//  test
//
//  Created by rrjj on 2019/5/30.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHAVDeviceManager.h"
#import "UIView+ZHCategory.h"
@interface ZHAVDeviceManager ()<AVCaptureMetadataOutputObjectsDelegate>
/**
 *  输入设备
 *  调用所有的输入硬件。例如摄像头和麦克风
 */
@property (nonatomic,strong) AVCaptureDeviceInput *DeviceInput;
/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 *  控制输入和输出设备之间的数据传递
 */
@property (nonatomic,strong) AVCaptureSession *session;
/**
 *  照片输出流
 *  用于输出图像
 */
@property (nonatomic, strong) AVCapturePhotoOutput* stillImageOutput;
/**
 *  预览图层
 *  镜头捕捉到得预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
/**
 * 数据输出流
 *
 */
@property (nonatomic,strong) AVCaptureMetadataOutput *metaOutPut;




@property (nonatomic,assign) BOOL isChangeZoom;
@end

@implementation ZHAVDeviceManager

+(instancetype)shareManager
{
    //
//    static ZHAVDeviceManager *manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [ZHAVDeviceManager new];
//    });
//    return manager;
    
    //是不是有点浪费内存的 ？
    ZHAVDeviceManager *m = [ZHAVDeviceManager new];
    return m;
}




#pragma mark - public
-(void)initWithFrame:(CGRect)frame view:(UIView *)view
{
    [self
     initAV];
    self.previewLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [view.layer addSublayer:self.previewLayer];

    CGFloat distance = 35;
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = view.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(distance, (frame.size.height - (frame.size.width - distance * 2)) / 2, (frame.size.width - distance * 2), (frame.size.width - distance * 2)) cornerRadius:0];
    layer.path = path.CGPath;
    
    CAShapeLayer *shape = [self addTransparencyViewWith:path];
    [view.layer addSublayer:shape];
    NSLog(@"-------%@",NSStringFromCGRect(path.bounds));
    //四个角
    UIImageView *imageViewLeftTop = [[UIImageView alloc] initWithFrame:CGRectMake(35, (frame.size.height - (frame.size.width - distance * 2)) / 2, 32, 32)];
    imageViewLeftTop.image = [UIImage imageNamed:@"QRCodeLeftTop"];
    [view addSubview:imageViewLeftTop];
    
    UIImageView *imageViewLeftBottom = [[UIImageView alloc] initWithFrame:CGRectMake(35, (frame.size.height - (frame.size.width - distance * 2)) / 2 + (frame.size.width - distance * 2) - 32, 32, 32)];
    imageViewLeftBottom.image = [UIImage imageNamed:@"QRCodeLeftBottom"];
    [view addSubview:imageViewLeftBottom];
    
    
    UIImageView *imageViewRightTop = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 32 -35, (frame.size.height - (frame.size.width - distance * 2)) / 2, 32, 32)];
    imageViewRightTop.image = [UIImage imageNamed:@"QRCodeRightTop"];
    [view addSubview:imageViewRightTop];
    
    UIImageView *imageViewRightBottom = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 32 -35, (frame.size.height - (frame.size.width - distance * 2)) / 2 + (frame.size.width - distance * 2) - 32, 32, 32)];
    imageViewRightBottom.image = [UIImage imageNamed:@"QRCodeRightBottom"];
    [view addSubview:imageViewRightBottom];
    
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 12)];
    line.image = [UIImage imageNamed:@"QRCodeScanningLine"];
    [view addSubview:line];
    line.origin = CGPointMake(0, (frame.size.height - (frame.size.width - distance * 2)) / 2);
    
    CABasicAnimation *animation = [self animation:@(0) toValue:@(frame.size.width - distance * 2 - 6) repCount:CGFLOAT_MAX duration:2.5];
    [line.layer addAnimation:animation forKey:@"lineYanimation"];
    
    
//    self.metaOutPut.rectOfInterest = path.bounds;
}

-(void)startRunning
{
//    [UIApplication sharedApplication].statusBarHidden = YES;
    if (self.session && !self.session.isRunning) {
        [self.session startRunning];
        self.isChangeZoom = NO;
        [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
            [captureDevice rampToVideoZoomFactor:1.0 withRate:10];
        }];
    }
}
- (void)stopRunning
{
//    [UIApplication sharedApplication].statusBarHidden = NO;
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
            [captureDevice rampToVideoZoomFactor:1.0 withRate:10];
        }];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.session && self.session.isRunning) {
            [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
                [captureDevice rampToVideoZoomFactor:1.0 withRate:10];
            }];
             [self.session stopRunning];
        }
    });
    
}

-(void)focalLength
{
    if (self.isChangeZoom) {
        return;
    }
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        [captureDevice rampToVideoZoomFactor:1.5 withRate:10];
    }];
}


#pragma mark - private

- (CABasicAnimation *)animation:(id)fromValue toValue:(id)toValue repCount:(CGFloat)repCount duration:(CGFloat)duration
{
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    bas.fromValue = fromValue;
    bas.toValue = toValue;
    bas.repeatCount = repCount;
    bas.duration = duration;
    bas.fillMode = kCAFillModeForwards;
    bas.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return bas;
}

- (CAShapeLayer *)addTransparencyViewWith:(UIBezierPath *)tempPath{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
    [path appendPath:tempPath];
    path.usesEvenOddFillRule = YES;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor= [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
    shapeLayer.fillRule=kCAFillRuleEvenOdd;
    return shapeLayer;
}

- (void)initAV
{
    if ([self.session canAddInput:self.DeviceInput]) {
        [self.session addInput:self.DeviceInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    if ([self.session canAddOutput:self.metaOutPut]) {
        [self.session addOutput:self.metaOutPut];
        @try {
            self.metaOutPut.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception.userInfo);
        } @finally {
            
        }
    }
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
}

-(void)registerAvDevice
{
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    if (self.block) {
                        self.block();
                    }
                }
            } ];
            NSLog(@"用户尚未授予或拒绝该权限:AVAuthorizationStatusNotDetermined");
        }
            break;
        case AVAuthorizationStatusRestricted:
        {
            NSLog(@"不允许用户访问媒体捕获设备:AVAuthorizationStatusRestricted");
        }
            break;
        case AVAuthorizationStatusDenied:
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有权限" message:@"该功能需要授权使用你的相机" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSURL *url= [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if (@available(iOS 10.0, *)){
                    if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                        [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL success) {
                        }];
                    }
                }else{
                    if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                        [[UIApplication sharedApplication]openURL:url];
                    }
                }
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [DCURLRouter presentViewController:alertController animated:YES completion:nil];
            NSLog(@"用户已经明确拒绝了应用访问捕获设备:AVAuthorizationStatusDenied");
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
        NSLog(@"用户授予应用访问捕获设备的权限:AVAuthorizationStatusAuthorized");
            if (self.block) {
                self.block();
            }
        }
        default:
            break;
    }
}

- (void)changeDevicePropertySafety:(void(^)(AVCaptureDevice *captureDevice))property
{
    AVCaptureDevice *device = self.DeviceInput.device;
    if ( [device lockForConfiguration:nil]) {
        property(device);
        [device unlockForConfiguration];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
//    [self focalLength];
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        [captureDevice rampToVideoZoomFactor:1.5 withRate:10];
    }];
    if (metadataObjects.count > 0 && !self.isChangeZoom) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZHScanDataWithArray:)]) {
            self.isChangeZoom = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate ZHScanDataWithArray:metadataObjects];
            });
        }
    }
    
    
    for (AVMetadataObject *object in metadataObjects) {
        // 2.1.1判断当前获取到的数据, 是否是机器可识别的类型
        if ([object isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            // 2.1.2将坐标转换界面可识别的坐标
            AVMetadataMachineReadableCodeObject *codeObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:object];
            // 2.1.3绘制图形
            
        }
    }
}

#pragma mark - 懒加载
-(AVCaptureDeviceInput *)DeviceInput
{
    if (!_DeviceInput) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error;
        _DeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }
    }
    return _DeviceInput;
}

-(AVCaptureSession *)session
{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];////设置高质量采集率
    }
    return _session;
}

-(AVCapturePhotoOutput *)stillImageOutput
{
    if (!_stillImageOutput) {
        _stillImageOutput = [[AVCapturePhotoOutput alloc] init];
    }
    return _stillImageOutput;
}

-(AVCaptureVideoPreviewLayer *)previewLayer
{
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    }
    return _previewLayer;
}

-(AVCaptureMetadataOutput *)metaOutPut
{
    if (!_metaOutPut) {
        _metaOutPut = [[AVCaptureMetadataOutput alloc] init];
        [_metaOutPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
    }
    return _metaOutPut;
}
@end
