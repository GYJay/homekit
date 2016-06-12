//
//  ActionSetManageViewController.m
//  homedp
//
//  Created by GYJ on 16/4/22.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "ActionSetManageViewController.h"
#import <HomeKit/HomeKit.h>
#import "actionMakeViewController.h"
@interface ActionSetManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *actionTable;
@end

static NSString *actionsCell=@"actionsCell";

@implementation ActionSetManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:@"upDateHome" object:nil];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(addAction)];
    
    self.actionTable=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.actionTable.delegate=self;
    self.actionTable.dataSource=self;
    [self.view addSubview:self.actionTable];
}

-(void)update{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
}

-(void)addAction{
     __weak __typeof(self)weakSelf=self;
    actionMakeViewController *avc=[[actionMakeViewController alloc] init];
    avc.home=self.home;
    avc.actionSet=self.actionSet;
    avc.ad=^(){
        [weakSelf.actionTable reloadData];
    };
    [self presentViewController:avc animated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.actionSet.actions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:actionsCell];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:actionsCell];
    }
    cell.textLabel.text=((HMCharacteristicWriteAction*)[self.actionSet.actions allObjects][indexPath.row]).characteristic.service.accessory.name;
    NSString *value=((HMCharacteristicWriteAction*)[self.actionSet.actions allObjects][indexPath.row]).targetValue;
    if ([((HMCharacteristicWriteAction*)[self.actionSet.actions allObjects][indexPath.row]).characteristic.metadata.format isEqualToString:@"bool"]) {
        if ([[NSString stringWithFormat:@"%@",((HMCharacteristicWriteAction*)[self.actionSet.actions allObjects][indexPath.row]).targetValue] isEqualToString:@"1"]) {
            value=@"YES";
        }else if([[NSString stringWithFormat:@"%@",((HMCharacteristicWriteAction*)[self.actionSet.actions allObjects][indexPath.row]).targetValue] isEqualToString:@"0"]){
            value=@"NO";
        }
    }
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@→%@",((HMCharacteristicWriteAction*)[self.actionSet.actions allObjects][indexPath.row]).characteristic.localizedDescription,value];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self)weakSelf=self;
    [tableView beginUpdates];
    [self.actionSet removeAction:(HMCharacteristicWriteAction*)[self.actionSet.actions allObjects][indexPath.row] completionHandler:^(NSError * _Nullable error) {
        if (error==nil) {
            NSLog(@"remove action success");
            [weakSelf.actionTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:(UITableViewRowAnimationFade)];
            [tableView endUpdates];
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
