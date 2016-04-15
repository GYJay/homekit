//
//  InHomeAccessoryViewController.m
//  homedp
//
//  Created by GYJ on 16/4/11.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "InHomeAccessoryViewController.h"
#import <HomeKit/HomeKit.h>
#import "accessoryViewCell.h"
#import "setMenuViewController.h"
#import "accessoryViewController.h"
#import "accessoryInfoViewController.h"
@interface InHomeAccessoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *inHomeTable;
@end


static NSString *acell=@"acell";
@implementation InHomeAccessoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=[NSString stringWithFormat:@"已在%@中的设备",self.home.name];
    self.inHomeTable=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.inHomeTable.delegate=self;
    self.inHomeTable.dataSource=self;
    [self.view addSubview:self.inHomeTable];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgAccessory"] forBarMetrics:(UIBarMetricsDefault)];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(searchAccessory)];
    self.inHomeTable.separatorColor=[UIColor clearColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes=dict;
}

-(void)searchAccessory{
    accessoryViewController *avc=[[accessoryViewController alloc] init];
    avc.home=self.home;
    [self presentViewController:avc animated:YES completion:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setBackIndicatorImage:<#(UIImage * _Nullable)#>];
    self.navigationController.navigationBar.hidden=NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    ((setMenuViewController*)self.navigationController.viewControllers[1]).isFromRight=NO;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.home.accessories.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    accessoryViewCell *cell=[tableView dequeueReusableCellWithIdentifier:acell];
    if (cell==nil) {
        cell=[[accessoryViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:acell];
    }
    if (self.home.accessories[indexPath.section].blocked==YES) {
        [cell setAcName:self.home.accessories[indexPath.section].name available:@"禁用"];
    }else{
        [cell setAcName:self.home.accessories[indexPath.section].name available:@"可用"];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    accessoryInfoViewController *avc=[[accessoryInfoViewController alloc] init];
    avc.accessory=self.home.accessories[indexPath.section];
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
