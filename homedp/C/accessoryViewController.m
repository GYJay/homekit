//
//  accessoryViewController.m
//  homedp
//
//  Created by GYJ on 16/4/10.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "accessoryViewController.h"
#import <HomeKit/HomeKit.h>
#import "accessoryViewCell.h"
@interface accessoryViewController ()<UITableViewDelegate,UITableViewDataSource,HMAccessoryBrowserDelegate>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)HMAccessoryBrowser *acb;
@property(nonatomic,strong)UIButton *b;
@end

static NSString *accell=@"accell";
@implementation accessoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.home.name;
    self.table=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.table.delegate=self;
    self.table.dataSource=self;
    [self.view addSubview:self.table];
    self.acb=[[HMAccessoryBrowser alloc] init];
    self.acb.delegate=self;
    [self.acb startSearchingForNewAccessories];
    self.table.backgroundColor=[UIColor clearColor];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgAccessory"]];
    self.table.separatorColor=[UIColor clearColor];
    
    self.b=[[UIButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-70, 60, 60)];
    self.b.center=CGPointMake(self.view.center.x, self.b.center.y);
    [self.b setTitle:@"X" forState:(UIControlStateNormal)];
    [self.b setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgAccessory"]] forState:(UIControlStateNormal)];
    [self.b addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    self.b.layer.cornerRadius=30;
    [self.b setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.b];
    self.table.frame=CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y, self.table.frame.size.height, self.table.frame.size.height-80);
}

-(void)back{
    self.br();
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.acb stopSearchingForNewAccessories];
}

-(void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory{
    [self.table reloadData];
}
-(void)accessoryBrowser:(HMAccessoryBrowser *)browser didRemoveNewAccessory:(HMAccessory *)accessory{
    [self.table reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.acb.discoveredAccessories.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    accessoryViewCell *cell=[tableView dequeueReusableCellWithIdentifier:accell];
    if (cell==nil) {
        cell=[[accessoryViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:accell];
    }
    if (self.acb.discoveredAccessories[indexPath.section].reachable==NO) {
        [cell setAcName:self.acb.discoveredAccessories[indexPath.section].name available:@"不可用"];
    }else{
        [cell setAcName:self.acb.discoveredAccessories[indexPath.section].name available:@"可用"];
    }
   cell.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.3];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self) weakSelf = self;
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"要把此设备添加到%@吗?",self.home.name] preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.home addAccessory:self.acb.discoveredAccessories[indexPath.section] completionHandler:^(NSError * _Nullable error) {
            if (error==nil) {
                NSLog(@"add accessory success");
                [self.table reloadData];
                //[weakSelf dismissViewControllerAnimated:YES completion:nil];
            }else{
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
        }];
    }]];
     [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
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
