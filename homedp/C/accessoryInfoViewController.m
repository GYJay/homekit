//
//  accessoryInfoViewController.m
//  homedp
//
//  Created by GYJ on 16/4/14.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "accessoryInfoViewController.h"
#import <HomeKit/HomeKit.h>
#import "CharacteristicInfoViewController.h"
@interface accessoryInfoViewController ()<UITableViewDelegate,UITableViewDataSource,HMAccessoryDelegate,UITextFieldDelegate>
{
    UIAlertAction *ac;
    NSString *reName;
}
@property(nonatomic,strong)UITableView *accessoryInfo;

@end

static NSString *accell=@"accell";

@implementation accessoryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:@"upDateHome" object:nil];
    self.title=self.accessory.name;
    self.accessoryInfo=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.accessoryInfo.delegate=self;
    self.accessoryInfo.dataSource=self;
    [self.view addSubview:self.accessoryInfo];
    self.accessory.delegate=self;
}


-(void)update{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
}

- (void)accessoryDidUpdateName:(HMAccessory *)accessory{
    [self.accessoryInfo reloadData];
}
- (void)accessory:(HMAccessory *)accessory didUpdateNameForService:(HMService *)service{
    [self.accessoryInfo reloadData];
}
- (void)accessory:(HMAccessory *)accessory didUpdateAssociatedServiceTypeForService:(HMService *)service{
    [self.accessoryInfo reloadData];
}
- (void)accessoryDidUpdateServices:(HMAccessory *)accessory{
    [self.accessoryInfo reloadData];
}
- (void)accessoryDidUpdateReachability:(HMAccessory *)accessory{
    [self.accessoryInfo reloadData];
}
- (void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic
{
    [self.accessoryInfo reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==4) {
        return self.accessory.services.count-1;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:accell];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:accell];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text=self.accessory.name;
            break;
        case 1:
            if (self.accessory.reachable==YES) {
                cell.textLabel.text=@"是";
            }else{
                cell.textLabel.text=@"否";
            }
            break;
        case 2:
            if (self.accessory.blocked==YES) {
                cell.textLabel.text=@"是";
            }else{
                cell.textLabel.text=@"否";
            }
            break;
        case 3:
            cell.textLabel.text=self.accessory.room.name;
            break;
        case 4:
            cell.textLabel.text=self.accessory.services[indexPath.row+1].name;
            break;
        default:
            break;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"名称";
            break;
        case 1:
            return @"可用";
            break;
        case 2:
            return @"屏蔽";
            break;
        case 3:
            return @"所在房间";
            break;
        case 4:
            return @"服务";
            break;
        default:
            return nil;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UIAlertController *a=[UIAlertController alertControllerWithTitle:@"重命名" message:@"输入设备名称" preferredStyle:(UIAlertControllerStyleAlert)];
        [a addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.delegate = self;
            textField.placeholder = nil;
            [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
        }];
        [a addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
        ac=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self.accessory updateName:reName completionHandler:^(NSError * _Nullable error) {
                if (error==nil) {
                    [self.accessoryInfo reloadData];
                    NSLog(@"update success");
                }else{
                    UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                    [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                    [self presentViewController:a animated:YES completion:nil];
                }
            }];
        }];
        ac.enabled=NO;
        [a addAction:ac];
        [self presentViewController:a animated:YES completion:nil];
    }
    
    if (indexPath.section==4) {
        CharacteristicInfoViewController *cvc=[[CharacteristicInfoViewController alloc] init];
        cvc.service=self.accessory.services[indexPath.row+1];
        cvc.accessory=self.accessory;
        [self.navigationController pushViewController:cvc animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    reName = textField.text;
}

//监听textField
-(void)textFieldChanged:(UITextField *)textField{
    if (textField.text.length==0) {
        ac.enabled=NO;
    }else{
        ac.enabled=YES;
    }
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
