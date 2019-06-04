//
//  ZHBaseViewController.m
//  test
//
//  Created by rrjj on 2019/5/29.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHBaseViewController.h"
//#import <FBRetainCycleDetector.h>
@interface ZHBaseViewController ()

@end

@implementation ZHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    FBRetainCycleDetector *detector = [FBRetainCycleDetector new];
//    [detector addCandidate:self];
//    NSSet *retainCycles = [detector findRetainCycles];
//    if (retainCycles.count > 0) {
//       NSLog(@"%@ %@",self,retainCycles);
//    }
    
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
