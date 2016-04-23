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
@interface accessoryInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *accessoryInfo;
@end

static NSString *accell=@"accell";

@implementation accessoryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.accessory.name;
    self.accessoryInfo=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.accessoryInfo.delegate=self;
    self.accessoryInfo.dataSource=self;
    [self.view addSubview:self.accessoryInfo];
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
    if (indexPath.section==4) {
        CharacteristicInfoViewController *cvc=[[CharacteristicInfoViewController alloc] init];
        cvc.service=self.accessory.services[indexPath.row+1];
        cvc.accessory=self.accessory;
        [self.navigationController pushViewController:cvc animated:YES];
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
