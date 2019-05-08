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
    [attrStr addAttribute:NSLinkAttributeName
                    value:@"我是button"
                    range:NSMakeRange(6, attrStr.length -6 -4)];
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(100, 220, 200, 200)];
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


#pragma mark - XML 解析
- (void)loadXMLData
{
    
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
