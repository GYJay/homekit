//
//  ActionSetViewController.m
//  homedp
//
//  Created by GYJ on 16/4/13.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "ActionSetViewController.h"
#import <HomeKit/HomeKit.h>
@interface ActionSetViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIAlertAction *action;
}
@property(nonatomic,strong)UITableView *actionSet;
@property(nonatomic,copy)NSString *addActionSetName;
@end

static NSString *actionCell=@"actioncell";

@implementation ActionSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.actionSet=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.actionSet.delegate=self;
    self.actionSet.dataSource=self;
    [self.view addSubview:self.actionSet];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgAction"] forBarMetrics:(UIBarMetricsDefault)];
    self.navigationController.navigationBar.hidden=NO;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(addActionSet)];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.home.actionSets.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.home.actionSets[section].actions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:actionCell];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:actionCell];
    }
    cell.textLabel.text=((HMCharacteristicWriteAction*)[self.home.actionSets[indexPath.section].actions allObjects][indexPath.row]).characteristic.localizedDescription;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 40)];
    l.text=self.home.actionSets[section].name;
    l.textColor=[UIColor grayColor];
    
    
    
    UIButton *b=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 5, 30, 30)];
    [b setBackgroundColor:[UIColor purpleColor]];
    [b setTitle:@"+" forState:(UIControlStateNormal)];
    b.layer.cornerRadius=15;
    [b addTarget:self action:@selector(addActionWithButton:) forControlEvents:(UIControlEventTouchUpInside)];
    b.tag=section+10000;
    
    
    UIButton *d=[[UIButton alloc] initWithFrame:CGRectMake(b.frame.origin.x-50, 5, 30, 30)];
    [d setBackgroundColor:[UIColor blueColor]];
    [d setTitle:@"-" forState:(UIControlStateNormal)];
    d.layer.cornerRadius=15;
    d.tag=section+10000;
    [d addTarget:self action:@selector(deleteActionSetWithButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [v addSubview:l];
    [v addSubview:b];
    [v addSubview:d];
    return v;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.addActionSetName = textField.text;
}


-(void)textFieldChanged:(UITextField *)textField{
    if (textField.text.length==0) {
        action.enabled=NO;
    }else{
        action.enabled=YES;
    }
}

-(void)addActionSet{
    __weak __typeof(self) weakSelf = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新建ActionSet"message:@"给你的动作集取一个独一无二的名字."preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.delegate = self;
        textField.placeholder = @"actionSet name";
        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
    }];
    
    action=[UIAlertAction actionWithTitle:@"添加"style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf.home addActionSetWithName:self.addActionSetName completionHandler:^(HMActionSet * _Nullable actionSet, NSError * _Nullable error) {
            if (error==nil) {
                NSLog(@"add actionSet success");
                [weakSelf.actionSet reloadData];
            }else{
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:@"请不要添加重名的set" preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
        }];
    }];
    action.enabled=NO;
    [alert addAction:action];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        weakSelf.addActionSetName = nil;
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)addActionWithButton:(UIButton *)b{
//    HMCharacteristicWriteAction *action=[[HMCharacteristicWriteAction alloc] initWithCharacteristic:<#(nonnull HMCharacteristic *)#> targetValue:<#(nonnull id<NSCopying>)#>];
//    [self.home.actionSets[b.tag-10000] addAction:action completionHandler:^(NSError * _Nullable error) {
//        
//    }];
}


-(void)deleteActionSetWithButton:(UIButton *)b{
    __weak __typeof(self) weakSelf = self;
    UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:@"要删除这个动作集吗？" preferredStyle:(UIAlertControllerStyleAlert)];
    [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.home removeActionSet:weakSelf.home.actionSets[b.tag-10000] completionHandler:^(NSError * _Nullable error) {
            if (error==nil) {
                [weakSelf.actionSet reloadData];
                NSLog(@"remove actionset success");
            }else{
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:@"无法删除内置动作集" preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
        }];
    }]];
    [a addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
    [self presentViewController:a animated:YES completion:nil];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
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
