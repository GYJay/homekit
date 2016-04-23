//
//  ActionSetViewController.m
//  homedp
//
//  Created by GYJ on 16/4/13.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "ActionSetViewController.h"
#import <HomeKit/HomeKit.h>
#import "TriggerCell.h"
#import "TimeTriggerViewController.h"
#import "timeTriggerManageController.h"
@interface ActionSetViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITableView *actionSet;
@property(nonatomic,copy)NSString *addActionSetName;
@end

static NSString *actionCell=@"actioncell";

@implementation ActionSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=[NSString stringWithFormat:@"%@中的触发器",self.home.name];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes=dict;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.actionSet=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.actionSet.delegate=self;
    self.actionSet.dataSource=self;
    [self.view addSubview:self.actionSet];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgAction"] forBarMetrics:(UIBarMetricsDefault)];
    self.navigationController.navigationBar.hidden=NO;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(addTrigger)];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.home.triggers.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TriggerCell *cell=[tableView dequeueReusableCellWithIdentifier:actionCell];
    if (cell==nil) {
        cell=[[TriggerCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:actionCell];
    }
    cell.textLabel.text=self.home.triggers[indexPath.section].name;
    [cell.s addTarget:self action:@selector(setEnableWithSwitch:) forControlEvents:(UIControlEventValueChanged)];
    cell.s.tag=indexPath.section+10000;
    if (self.home.triggers[indexPath.section].enabled==YES) {
        [cell.s setOn:YES];
    }else{
        [cell.s setOn:NO];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     __weak __typeof(self) weakSelf = self;
    timeTriggerManageController *tvc=[[timeTriggerManageController alloc]init];
    tvc.home=self.home;
    tvc.trigger=(HMTimerTrigger*)self.home.triggers[indexPath.section];
    tvc.addT=^(){
        [weakSelf.actionSet reloadData];
    };

    [self.navigationController pushViewController:tvc animated:YES];
}


-(void)setEnableWithSwitch:(UISwitch *)s{
    __weak __typeof(self)weakSelf=self;
    if (s.on==NO) {
        [self.home.triggers[s.tag-10000] enable:NO completionHandler:^(NSError * _Nullable error) {
            if (error==nil) {
                [s setOn:NO animated:YES];
            }else{
                [s setOn:YES animated:YES];
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
        }];
    }else{
        [self.home.triggers[s.tag-10000] enable:YES completionHandler:^(NSError * _Nullable error) {
            if (error==nil) {
                [s setOn:YES animated:YES];
            }else{
                [s setOn:NO animated:YES];
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
        }];
    }
}




-(void)addTimeTrigger{
    __weak __typeof(self) weakSelf = self;
    TimeTriggerViewController *tvc=[[TimeTriggerViewController alloc] init];
    tvc.addT=^(HMTimerTrigger *trigger){
        [weakSelf.home addTrigger:trigger completionHandler:^(NSError * _Nullable error) {
            if (error==nil) {
                NSLog(@"add triggre success");
                [weakSelf.actionSet reloadData];
            }else{
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
        }];
    };
    [self presentViewController:tvc animated:YES completion:nil];
}
    
    
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self) weakSelf = self;
    [tableView beginUpdates];
    [self.home removeTrigger:self.home.triggers[indexPath.section] completionHandler:^(NSError * _Nullable error) {
        if (error==nil) {
            [weakSelf.actionSet deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationFade)];
            [weakSelf.actionSet endUpdates];
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

//-(void)deleteActionSetWithButton:(UIButton *)b{
//        __weak __typeof(self) weakSelf = self;
//        UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:@"要删除这个动作集吗？" preferredStyle:(UIAlertControllerStyleAlert)];
//        [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
//            [weakSelf.home removeActionSet:weakSelf.home.actionSets[b.tag-10000] completionHandler:^(NSError * _Nullable error) {
//                if (error==nil) {
//                    [weakSelf.actionSet reloadData];
//                    NSLog(@"remove actionset success");
//                }else{
//                    UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:@"无法删除内置动作集" preferredStyle:(UIAlertControllerStyleAlert)];
//                    [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
//                    [weakSelf presentViewController:a animated:YES completion:nil];
//                }
//            }];
//        }]];
//        [a addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
//        [self presentViewController:a animated:YES completion:nil];
//
//}


-(void)addEventTrigger{

}
-(void)addTrigger{
    __weak __typeof(self) weakSelf = self;
    UIAlertController *a=[UIAlertController alertControllerWithTitle:@"" message:@"选择触发器" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    [a addAction:[UIAlertAction actionWithTitle:@"时间触发器" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf addTimeTrigger];
    }]];
    
    [a addAction:[UIAlertAction actionWithTitle:@"事件触发器" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf addEventTrigger];
    }]];
    
    [a addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
    
    [self presentViewController:a animated:YES completion:nil];
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
