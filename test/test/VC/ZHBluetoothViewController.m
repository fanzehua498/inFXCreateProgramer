//
//  ZHBluetoothViewController.m
//  test
//
//  Created by rrjj on 2019/5/13.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "ZHBluetoothViewController.h"
#import "CircleSelectButtonView.h"
#import "ZHTextField.h"
#define kMaxLength 20

CGColorSpaceRef ZHCGColorSpaceGetDeviceRGB(void) {
    static CGColorSpaceRef colorSpace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorSpace = CGColorSpaceCreateDeviceRGB();
    });
    return colorSpace;
}

BOOL ZHCGImageRefContainsAlpha(CGImageRef imageRef) {
    if (!imageRef) {
        return NO;
    }
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone ||
                      alphaInfo == kCGImageAlphaNoneSkipFirst ||
                      alphaInfo == kCGImageAlphaNoneSkipLast);
    return hasAlpha;
}

BOOL ZHCGImageRefContainsAlpha1(CGImageRef imageRef){
    
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    BOOL hasAlpha = NO;
    if (alphaInfo == kCGImageAlphaPremultipliedLast || alphaInfo == kCGImageAlphaPremultipliedFirst || alphaInfo == kCGImageAlphaLast || alphaInfo == kCGImageAlphaFirst) {
        hasAlpha = YES;
    }
    return hasAlpha;
}

@interface ZHBluetoothViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *moveLabel;


@end

@implementation ZHBluetoothViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//
//    UIImage *image = [UIImage imageNamed:@"logo_img_01"];
//    UIImageView *imageVIew= [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [self.view addSubview:imageVIew];
//    CFDataRef rawData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
//
//    NSLog(@"%@",rawData);
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        UIImage *ima = [self compressImageWith:image];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            imageVIew.image = ima;
//        });
//
//    });
//
//    UIImageView *imageVIew1 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
//    [self.view addSubview:imageVIew1];
//    imageVIew1.image = image;
    CircleSelectButtonView *v = [[CircleSelectButtonView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, Screenheight)];

    [self.view addSubview:v];
    
    NSNumberFormatter *fo = [[NSNumberFormatter alloc] init];
    fo.numberStyle = NSNumberFormatterPercentStyle;
    fo.groupingSize = 2;
    
    dispatch_queue_t queue = dispatch_queue_create("label", 0);
    dispatch_queue_t queue1 = dispatch_queue_create("label1", 0);
    dispatch_async(queue, ^{
        // 这两个是同时执行的
        NSLog(@"任务1, %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务2, %@",[NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"任务 barrier, %@", [NSThread currentThread]);
    });
    dispatch_async(queue1, ^{
        // 这两个是同时执行的
        NSLog(@"任务3, %@",[NSThread currentThread]);
    });
    dispatch_async(queue1, ^{
        NSLog(@"任务4, %@",[NSThread currentThread]);
    });
    // 输出结果: 任务1 任务2 ——》 任务 barrier ——》任务3 任务4  // 其中的任务1与任务2，任务3与任务4 由于是并行处理先后顺序不定。
    ZHTextField *field = [[ZHTextField alloc] initWithFrame:CGRectMake(100, 100, 100, 30) WithDelegate:self];
    field.placeholder = @"placeholder";
    field.MaxLength = 10;
    field.type = FieldTypeChinese;
    [self.view addSubview:field];

}
- (UIImage *)compressImageWith:(UIImage *)image
{
    @autoreleasepool {
        CGImageRef imageRef = image.CGImage;
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        //SDWebImage
        BOOL hasAlpha = ZHCGImageRefContainsAlpha(imageRef);
        //YYImage
        //    BOOL hasAlpha = ZHCGImageRefContainsAlpha1(imageRef);
        
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        
        
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, ZHCGColorSpaceGetDeviceRGB(), bitmapInfo);
        if (context == NULL) {
            return image;
        }
        
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        CGImageRef imageRefWithNoAlpha = CGBitmapContextCreateImage(context);
        UIImage *imageWithNoAlpha = [[UIImage alloc] initWithCGImage:imageRefWithNoAlpha scale:image.scale*2 orientation:UIImageOrientationLeft];
        //非arc对象 释放
        CGContextRelease(context);
        CGImageRelease(imageRefWithNoAlpha);
        
        return imageWithNoAlpha;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    UIView animateKeyframesWithDuration:<#(NSTimeInterval)#> delay:<#(NSTimeInterval)#> options:(UIViewKeyframeAnimationOptions) animations:<#^(void)animations#> completion:<#^(BOOL finished)completion#>
}
@end
