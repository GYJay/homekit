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
    UIButton *b=[[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [b addTarget:self action:@selector(manage) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:b];
    b.backgroundColor=[UIColor redColor];
    
}


-(void)manage{
    [self.home manageUsersWithCompletionHandler:^(NSError * _Nullable error) {
        if (error==nil) {
            
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
