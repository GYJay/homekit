//
//  CharacteristicInfoViewController.m
//  homedp
//
//  Created by GYJ on 16/4/23.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "CharacteristicInfoViewController.h"
#import <HomeKit/HomeKit.h>
@interface CharacteristicInfoViewController ()<UITableViewDelegate,UITableViewDataSource,HMAccessoryDelegate>
@property(nonatomic,strong)UITableView *characteristicTable;
@end

static NSString *characteristicCell=@"characteristicCell";

@implementation CharacteristicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:@"upDateHome" object:nil];
    self.characteristicTable=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.characteristicTable.delegate=self;
    self.characteristicTable.dataSource=self;
    [self.view addSubview:self.characteristicTable];
    self.accessory.delegate=self;
}

-(void)update{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic{
    [self.characteristicTable reloadData];
}

-(void)accessoryDidUpdateServices:(HMAccessory *)accessory{
    [self.characteristicTable reloadData];
}

-(void)accessoryDidUpdateReachability:(HMAccessory *)accessory{
    [self.characteristicTable reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.service.characteristics.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:characteristicCell];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:characteristicCell];
    }
    cell.textLabel.text=self.service.characteristics[indexPath.row].localizedDescription;
    id value=[NSString stringWithFormat:@"%@",self.service.characteristics[indexPath.row].value];

    if ([self.service.characteristics[indexPath.row].metadata.format isEqualToString:@"bool"]) {
        if ([self.service.characteristics[indexPath.row].value isEqual:@(0)]) {
            value=@"NO";
        }else if([self.service.characteristics[indexPath.row].value isEqual:@(1)]){
            value=@"YES";
        }
    }
    if (![self.service.characteristics[indexPath.row].properties containsObject:@"HMCharacteristicPropertyReadable"]) {
        value=@"不可读";
    }
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",value];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
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
