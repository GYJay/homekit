//
//  InRoomAccessoryViewController.m
//  homedp
//
//  Created by GYJ on 16/4/11.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "InRoomAccessoryViewController.h"
#import <HomeKit/HomeKit.h>
#import "accessoryViewCell.h"
#import "InHomeAccessoryViewController.h"
@interface InRoomAccessoryViewController ()<UITableViewDelegate,UITableViewDataSource
>
@property(nonatomic,strong)UITableView *accessoryTable;
@end

static NSString *accell=@"accell";

@implementation InRoomAccessoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=[NSString stringWithFormat:@"%@中的设备",self.room.name];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes=dict;
    self.accessoryTable=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.accessoryTable.delegate=self;
    self.accessoryTable.dataSource=self;
    [self.view addSubview:self.accessoryTable];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(addAccessory)];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.room.accessories.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    accessoryViewCell *cell=[tableView dequeueReusableCellWithIdentifier:accell];
    if (cell==nil) {
        cell=[[accessoryViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:accell];
    }
    if (self.room.accessories[indexPath.section].reachable==NO) {
        [cell setAcName:self.room.accessories[indexPath.section].name available:@"不可用"];
    }else{
        [cell setAcName:self.room.accessories[indexPath.section].name available:@"可用"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof (self) weakSelf = self;
    [tableView beginUpdates];
    [self.home assignAccessory:self.room.accessories[indexPath.section] toRoom:[self.home roomForEntireHome] completionHandler:^(NSError * _Nullable error) {
        if (error==nil) {
            [weakSelf.accessoryTable deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationTop)];
            [weakSelf.accessoryTable endUpdates];
        }else{
            [tableView endUpdates];
            UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
            [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
            [weakSelf presentViewController:a animated:YES completion:nil];
        }
    }];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.accessoryTable reloadData];
}

-(void)addAccessory{
    InHomeAccessoryViewController *ivc=[[InHomeAccessoryViewController alloc] init];
    ivc.home=self.home;
    ivc.isAssignToRoom=YES;
    ivc.room=self.room;
    [self presentViewController:ivc animated:YES completion:nil];
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
