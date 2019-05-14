//
//  ZHBluetoothViewController.m
//  test
//
//  Created by rrjj on 2019/5/13.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "ZHBluetoothViewController.h"
#import "CircleSelectButtonView.h"

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

@interface ZHBluetoothViewController ()

@property (nonatomic,strong) UILabel *moveLabel;


@end

@implementation ZHBluetoothViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
