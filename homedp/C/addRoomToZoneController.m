//
//  addRoomToZoneController.m
//  homedp
//
//  Created by GYJ on 16/4/12.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "addRoomToZoneController.h"
#import <HomeKit/HomeKit.h>
#import "HYBBubbleTransition.h"
#import "zoneViewController.h"
@interface addRoomToZoneController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *roomsTableView;
@property(nonatomic,strong)NSMutableArray <HMRoom*>*a;
@end

@implementation addRoomToZoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *b=[[UIButton alloc] initWithFrame:CGRectMake(10, 20, 30, 30)];
    [b setBackgroundImage:[UIImage imageNamed:@"back"] forState:(UIControlStateNormal)];
    [b addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    self.roomsTableView=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.roomsTableView.delegate=self;
    self.roomsTableView.dataSource=self;
    self.roomsTableView.backgroundColor=[UIColor purpleColor];
    [self.view addSubview:self.roomsTableView];
    self.roomsTableView.contentInset=UIEdgeInsetsMake(50, 0, 0, 0);
    self.a=[NSMutableArray array];
    if (self.zone.rooms.count!=0) {
        for (HMRoom *room in self.home.rooms) {
            if (![self.zone.rooms containsObject:room]) {
                [self.a addObject:room];
            }
        }
    }else{
        _a=[self.home.rooms mutableCopy];
    }
    
    [self.view addSubview:b];
}


-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.a.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
    l.text=self.a[section].name;
    l.textColor=[UIColor grayColor];
    
    
    UIButton *b=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 5, 30, 30)];
    [b setBackgroundColor:[UIColor whiteColor]];
    [b setTitle:@"+" forState:(UIControlStateNormal)];
    [b setTitleColor:[UIColor purpleColor] forState:(UIControlStateNormal)];
    b.layer.cornerRadius=15;
    [b addTarget:self action:@selector(addCompleteWithButton:) forControlEvents:(UIControlEventTouchUpInside)];
    b.tag=section+10000;
    
    [v addSubview:l];
    [v addSubview:b];
    
    return v;
}


-(void)addCompleteWithButton:(UIButton *)b{
//    CGPoint p=[b.superview convertPoint:b.center toView:self.view];
//    p.y-=64;
//    ((HYBBubbleTransition*)self.transitioningDelegate).bubbleStartPoint=p;
    __weak __typeof(self)weakSelf = self;
    [self.zone addRoom:self.a[b.tag-10000] completionHandler:^(NSError * _Nullable error) {
        if (error==nil) {
            NSLog(@"add room to zone success");
            [((zoneViewController*)((UINavigationController*)weakSelf.presentingViewController).viewControllers.lastObject).zoneTable reloadData];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }else{
            UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
            [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
            [weakSelf presentViewController:a animated:YES completion:nil];
        }
    }];
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
