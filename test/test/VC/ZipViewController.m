//
//  ZipViewController.m
//  test
//
//  Created by rrjj on 2019/4/9.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "ZipViewController.h"
#import <SSZipArchive.h>
@interface ZipViewController ()<UITextViewDelegate>
@property (nonatomic,strong) UIImageView *imageV;

@end

@implementation ZipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageV = [[UIImageView alloc] init];
    self.imageV.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:self.imageV];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:@"这是一个网址我是button字符串！"];
    
    
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"train_rob_icon"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -3, 14, 14);
//    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[[attrStr string] rangeOfString:@"红"]];
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSMutableAttributedString attributedStringWithAttachment:attch];
    [attrStr appendAttributedString:string];
    [attrStr appendAttributedString: [[NSAttributedString alloc]initWithString:@"查看图片"]];
    [attrStr addAttribute:NSLinkAttributeName
                    value:@"查看图片"
                    range:NSMakeRange(attrStr.length-4, 4)];
    
    
    
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(100, 220, 220, 200)];
    text.attributedText = attrStr;
    text.delegate = self;
    text.editable = NO;
    [self.view addSubview:text];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    NSLog(@"%@ %@ %ld",URL,NSStringFromRange(characterRange),(long)interaction);
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    NSLog(@"textAttachment:%@ %@ %ld",textAttachment,NSStringFromRange(characterRange),(long)interaction);
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self unZipFile];
}
- (void)unZipFile
{
    NSString *unzipPath = [NSString stringWithFormat:@"%@/\%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],@"解压文件"];
    NSLog(@"%@",unzipPath);
    
    __block NSString *pathImage = @"";
    [SSZipArchive unzipFileAtPath:[[NSBundle mainBundle] pathForResource:@"zzzzzzz" ofType:@"zip"] toDestination:unzipPath progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
        NSLog(@"%@ %s %ld %ld",entry,zipInfo,entryNumber,total);
        pathImage = entry;
    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        
        if (succeeded) {
            NSLog(@"%@\n %@",path,[unzipPath stringByAppendingString:pathImage]);
            NSString *pathStr = [NSString stringWithFormat:@"%@/%@",unzipPath,pathImage];
            self.imageV.image = [UIImage imageNamed:pathStr];
        }
        if (error) {
            NSLog(@"%@",error);
        }
        
    }];
}
@end
