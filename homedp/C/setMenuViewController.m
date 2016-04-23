//
//  setMenuViewController.m
//  homedp
//
//  Created by GYJ on 16/4/10.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "setMenuViewController.h"
#import "setViewCell.h"
#import "UITableView+Wave.h"
#import "RoomsViewController.h"
#import "InHomeAccessoryViewController.h"
#import "zoneViewController.h"
#import "ActionSetViewController.h"
#import "userManageViewController.h"
#import "ActionInHomeViewController.h"
@interface setMenuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *setTable;
@property(nonatomic,strong)UIButton *back;

@end

static NSString *ree=@"ree";

@implementation setMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.setTable=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.setTable.delegate=self;
    self.setTable.dataSource=self;
    self.setTable.separatorColor=[UIColor clearColor];
    [self.view addSubview:self.setTable];
    self.setTable.backgroundColor=[UIColor clearColor];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.navigationController.navigationBar.hidden=YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.back=[[UIButton alloc] initWithFrame:CGRectMake(10, 20, 32, 32)];
    [self.back setBackgroundImage:[UIImage imageNamed:@"back"] forState:(UIControlStateNormal)];
    [self.back addTarget:self action:@selector(backTo) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.back];
    
}


-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.setTable.hidden=NO;
    if (self.isFromRight==YES) {
        [self.setTable reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    }else{
        [self.setTable reloadDataAnimateWithWave:LeftToRightWaveAnimation];
    }
    
    self.back.hidden=NO;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    self.setTable.hidden=YES;
    self.back.hidden=YES;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    setViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ree];
    if (cell==nil) {
        cell=[[setViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ree];
    }
    switch (indexPath.row) {
        case 0:
            cell.backgroundColor=[UIColor colorWithRed:242/255.0 green:173/255.0 blue:153/255.0 alpha:1];
            [cell setIcon:[UIImage imageNamed:@"user"] Title:@"用户"];
            break;
        case 1:
            cell.backgroundColor=[UIColor colorWithRed:236/255.0 green:113/255.0 blue:127/255.0 alpha:1];
            [cell setIcon:[UIImage imageNamed:@"room1"] Title:@"房间"];
            break;
        case 2:
            cell.backgroundColor=[UIColor colorWithRed:192.0/255.0 green:108/255.0 blue:132/255.0 alpha:1];
            [cell setIcon:[UIImage imageNamed:@"trigger"] Title:@"触发器"];
            break;
        case 3:
            cell.backgroundColor=[UIColor colorWithRed:90/255.0 green:83/255.0 blue:135/255.0 alpha:1];
            [cell setIcon:[UIImage imageNamed:@"zone"] Title:@"分区"];
            break;
        case 4:
            cell.backgroundColor=[UIColor colorWithRed:72/255.0 green:117/255.0 blue:170/255.0 alpha:1];
            [cell setIcon:[UIImage imageNamed:@"accessory"] Title:@"设备"];
            break;
        case 5:
            cell.backgroundColor=[UIColor colorWithRed:63/255.0 green:81/255.0 blue:181/255.0 alpha:1];
            [cell setIcon:[UIImage imageNamed:@"action"] Title:@"动作"];
            break;
        default:
            break;
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height/6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            userManageViewController *uvc=[[userManageViewController alloc] init];
            uvc.home=self.home;
            [self.navigationController pushViewController:uvc animated:YES];
        }
            break;
        case 1:
        {
            RoomsViewController *rvc=[[RoomsViewController alloc]init];
            rvc.home=self.home;
            [self.navigationController pushViewController:rvc animated:YES];
        }
            break;
        case 2:
        {
            ActionSetViewController *avc=[[ActionSetViewController alloc]init];
            avc.home=self.home;
            [self.navigationController pushViewController:avc animated:YES];
        }
            break;
        case 3:
        {
            zoneViewController *zoneVc=[[zoneViewController alloc] init];
            zoneVc.home=self.home;
            [self.navigationController pushViewController:zoneVc animated:YES];
        }
            break;
        case 4:
        {
            InHomeAccessoryViewController *avc=[[InHomeAccessoryViewController alloc] init];
            avc.home=self.home;
            [self.navigationController pushViewController:avc animated:YES];
        }
            break;
        case 5:
        {
            ActionInHomeViewController *avc=[[ActionInHomeViewController alloc]init];
            avc.home=self.home;
            [self.navigationController pushViewController:avc animated:YES];
        }
            break;
        default:
            break;
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
