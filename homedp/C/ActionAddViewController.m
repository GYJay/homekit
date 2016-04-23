//
//  ActionSetManageViewController.m
//  homedp
//
//  Created by GYJ on 16/4/22.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "ActionAddViewController.h"
#import <HomeKit/HomeKit.h>
@interface ActionAddViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *actionSetTable;
@end

static NSString *actionCell=@"acell";

@implementation ActionAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"触发器";
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(addActionSet)];
    self.actionSetTable=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.actionSetTable.delegate=self;
    self.actionSetTable.dataSource=self;
    [self.view addSubview:self.actionSetTable];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.home.actionSets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:actionCell];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:actionCell];
    }
    cell.textLabel.text=self.home.actionSets[indexPath.row].name;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     __weak __typeof(self)weakSelf=self;
    [self.trigger addActionSet:self.home.actionSets[indexPath.row] completionHandler:^(NSError * _Nullable error) {
        if (error==nil) {
            NSLog(@"add actionSet success");
            weakSelf.addsuccess();
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
