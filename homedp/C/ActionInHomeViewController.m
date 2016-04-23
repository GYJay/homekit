//
//  ActionInHomeViewController.m
//  homedp
//
//  Created by GYJ on 16/4/22.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "ActionInHomeViewController.h"
#import <HomeKit/HomeKit.h>
#import "ActionSetManageViewController.h"
@interface ActionInHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIAlertAction *action;
}
@property(nonatomic,strong)UITableView *actionTable;
@property(nonatomic,copy)NSString *name;
@end

static NSString *actionCell=@"actionCell";

@implementation ActionInHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=[NSString stringWithFormat:@"%@中的动作集",self.home.name];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes=dict;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=NO;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(addActionSet)];
    
    self.actionTable=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.actionTable.delegate=self;
    self.actionTable.dataSource=self;
    [self.view addSubview:self.actionTable];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"actionbg"] forBarMetrics:(UIBarMetricsDefault)];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.name = textField.text;
}

//监听textField
-(void)textFieldChanged:(UITextField *)textField{
    if (textField.text.length==0) {
        action.enabled=NO;
    }else{
        action.enabled=YES;
    }
}

-(void)addActionSet{
    __weak __typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新建动作集"message:@"给你的动作集取一个独一无二的名字."preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.delegate = self;
        textField.placeholder = @"actionSet name";
        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
    }];
    
    action=[UIAlertAction actionWithTitle:@"添加"style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf.home addActionSetWithName:self.name completionHandler:^(HMActionSet * _Nullable actionSet, NSError * _Nullable error) {
            if (error==nil) {
                [weakSelf.actionTable reloadData];
                NSLog(@"add actionSet success");
            }else{
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
        }];
    }];
    action.enabled=NO;
    [alert addAction:action];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        weakSelf.name= nil;
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];

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
        cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:actionCell];
    }
    cell.textLabel.text=self.home.actionSets[indexPath.row].name;
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak  __typeof(self)weakSelf=self;
    [tableView beginUpdates];
    [self.home removeActionSet:self.home.actionSets[indexPath.row] completionHandler:^(NSError * _Nullable error) {
        if (error==nil) {
            NSLog(@"remove actionSet success");
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActionSetManageViewController *avc=[[ActionSetManageViewController alloc]init];
    avc.actionSet=self.home.actionSets[indexPath.row];
    avc.home=self.home;
    [self.navigationController pushViewController:avc animated:YES];
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
