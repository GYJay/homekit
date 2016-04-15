//
//  InRoomAccessoryViewController.m
//  homedp
//
//  Created by GYJ on 16/4/11.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "InRoomAccessoryViewController.h"
#import <HomeKit/HomeKit.h>
@interface InRoomAccessoryViewController ()

@end

@implementation InRoomAccessoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//-(void)addAccessoryToRoom{
//    __weak __typeof(self)weakSelf = self;
//    [self.home assignAccessory:self.home.accessories[indexPath.row] toRoom:self.room completionHandler:^(NSError * _Nullable error) {
//        if (error==nil) {
//            [weakSelf.table reloadDate];
//        }
//    }];
//}
//
//-(void)addTrigger{
//    [self.home addTrigger:self.trigger completionHandler:^(NSError * _Nullable error) {
//        if (error==nil) {
//            [self.table reloadData];
//        }
//    }]
//}
//
//-(void)removeTriggerFromRoom{
//    [self.home removeTrigger:self.home.triggers[indexPath.row] completionHandler:^(NSError * _Nullable error) {
//        if (error==nil) {
//            [self.table reloadData];
//        }
//    }];
//}

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
