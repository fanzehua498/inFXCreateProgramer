//
//  ClickViewController.m
//  test
//
//  Created by rrjj on 2018/10/10.
//  Copyright © 2018 rrjj. All rights reserved.
//

#import "ClickViewController.h"

@interface ClickViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContent;
@property (weak, nonatomic) IBOutlet UILabel *labelL;

@end

@implementation ClickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"1:%@",NSStringFromCGRect(self.labelL.bounds));
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.labelL.text = @"asdmnzckujehwjknjkxchnskjdhalsjdklejwkldxjklhlksjdlajdljqwiohjkxvcjkasdjakhdskljhfdjkshflaskhas";
    });
    
    NSLog(@"2:%@",NSStringFromCGRect(self.labelL.bounds));
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"3:%@",NSStringFromCGRect(self.labelL.bounds));
    
}

- (IBAction)clickButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        self.heightContent.constant = 0;
    }else{
        self.heightContent.constant = 128;
    }
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
