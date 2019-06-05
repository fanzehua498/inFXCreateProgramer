//
//  ZHPageTestViewController.m
//  test
//
//  Created by rrjj on 2019/5/27.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHPageTestViewController.h"

@interface ZHPageTestViewController ()

@end

@implementation ZHPageTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *labe = [[UILabel alloc] initWithFrame:CGRectMake(0, Screenheight/2, 100, 20)];
    labe.text = self.labelTitle;
    [self.view addSubview:labe];
    self.view.backgroundColor = [UIColor whiteColor];
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
