//
//  userManageViewController.m
//  homedp
//
//  Created by GYJ on 16/4/15.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "userManageViewController.h"
#import <HomeKit/HomeKit.h>
@interface userManageViewController ()

@end

@implementation userManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    __weak __typeof (self) weakSelf = self;
    [self.home manageUsersWithCompletionHandler:^(NSError * _Nullable error) {
        if (error==nil) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
            [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
            [weakSelf presentViewController:a animated:YES completion:nil];
        }

    }];
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
