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
@end

static NSString *accell=@"accell";
@implementation accessoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.home.name;
    self.table=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.table.delegate=self;
    self.table.dataSource=self;
    [self.view addSubview:self.table];
    self.acb=[[HMAccessoryBrowser alloc] init];
    self.acb.delegate=self;
    [self.acb startSearchingForNewAccessories];
    self.table.backgroundColor=[UIColor clearColor];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgAccessory"]];
    self.table.separatorColor=[UIColor clearColor];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.acb stopSearchingForNewAccessories];
}

-(void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory{
    [self.table reloadData];
}
-(void)accessoryBrowser:(HMAccessoryBrowser *)browser didRemoveNewAccessory:(HMAccessory *)accessory{}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.acb.discoveredAccessories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    accessoryViewCell *cell=[tableView dequeueReusableCellWithIdentifier:accell];
    if (cell==nil) {
        cell=[[accessoryViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:accell];
    }
    if (self.acb.discoveredAccessories[indexPath.row].blocked==YES) {
        [cell setAcName:self.acb.discoveredAccessories[indexPath.row].name available:@"禁用"];
    }else{
        [cell setAcName:self.acb.discoveredAccessories[indexPath.row].name available:@"可用"];
    }
    NSUInteger i=indexPath.row;
    cell.backgroundColor=[UIColor colorWithRed:(95-i*15)/255.0 green:(201-i*15)/255.0 blue:(197-i*15)/255.0 alpha:1];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height/8;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self) weakSelf = self;
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"要把此设备添加到%@吗?",self.home.name] preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.home addAccessory:self.acb.discoveredAccessories[indexPath.row] completionHandler:^(NSError * _Nullable error) {
            if (error==nil) {
                NSLog(@"add accessory success");
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
