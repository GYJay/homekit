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
#import "HYBBubbleTransition.h"
@interface InHomeAccessoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *inHomeTable;
@property(nonatomic,strong)UIButton *b;
@property(nonatomic,strong)HYBBubbleTransition *bubbleTransition;
@property(nonatomic,assign)CGPoint p;
@end


static NSString *acell=@"acell";
@implementation InHomeAccessoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:@"upDateHome" object:nil];
    self.title=[NSString stringWithFormat:@"%@的设备",self.home.name];
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
    
    self.b=[[UIButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-70, 60, 60)];
    self.b.center=CGPointMake(self.view.center.x, self.b.center.y);
    self.p=self.b.center;
    if (self.isAssignToRoom==YES) {
        self.b=[[UIButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-70, 60, 60)];
        self.b.center=CGPointMake(self.view.center.x, self.b.center.y);
        [self.b setTitle:@"X" forState:(UIControlStateNormal)];
        [self.b setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgRoom"]] forState:(UIControlStateNormal)];
        [self.b addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
        self.b.layer.cornerRadius=30;
        [self.b setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:self.b];
        self.inHomeTable.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgRoom"]];
        self.inHomeTable.frame=CGRectMake(self.inHomeTable.frame.origin.x, self.inHomeTable.frame.origin.y, self.inHomeTable.frame.size.width, self.inHomeTable.frame.size.height-80);
    }
}

-(void)back{
    self.br();
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)update{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)searchAccessory{
    __weak typeof(self) weakSelf = self;
    accessoryViewController *avc=[[accessoryViewController alloc] init];
    avc.home=self.home;
    avc.br=^(){
        self.inHomeTable.frame=self.view.bounds;
        [weakSelf.inHomeTable reloadData];
    };
    avc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    avc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    self.bubbleTransition=[[HYBBubbleTransition alloc] initWithPresented:^(UIViewController *presented, UIViewController *presenting, UIViewController *source, HYBBaseTransition *transition) {
        HYBBubbleTransition *bubble = (HYBBubbleTransition *)transition;
        bubble.bubbleColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgAccessory"]];
        CGPoint center = self.p;
        center.y += 64;
        bubble.bubbleStartPoint = center;
    } dismissed:^(UIViewController *dismissed, HYBBaseTransition *transition) {
        transition.transitionMode=kHYBTransitionDismiss;
    }];
    avc.transitioningDelegate=self.bubbleTransition;
    [self presentViewController:avc animated:YES completion:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.inHomeTable reloadData];
    if (self.isAssignToRoom==NO) {
        self.inHomeTable.frame=self.view.bounds;
    }
    
    self.navigationController.navigationBar.hidden=NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isAssignToRoom==NO) {
        self.inHomeTable.frame=self.view.bounds;
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=YES;
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
    if (self.home.accessories[indexPath.section].reachable==NO) {
        [cell setAcName:self.home.accessories[indexPath.section].name available:@"不可用"];
    }else{
        [cell setAcName:self.home.accessories[indexPath.section].name available:@"可用"];
    }
    if (self.isAssignToRoom==YES) {
        cell.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.3];
    }else{
        cell.backgroundColor=[UIColor whiteColor];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self) weakSelf = self;
    if (self.isAssignToRoom==NO) {
        accessoryInfoViewController *avc=[[accessoryInfoViewController alloc] init];
        avc.accessory=self.home.accessories[indexPath.section];
        [self.navigationController pushViewController:avc animated:YES];
    }else{
        [self.home assignAccessory:self.home.accessories[indexPath.section] toRoom:self.room completionHandler:^(NSError * _Nullable error) {
            if (error==nil) {
                self.br();
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }else{
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
        }];
    }
    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isAssignToRoom==NO) {
        __weak __typeof(self) weakSelf = self;
        [tableView beginUpdates];
        [self.home removeAccessory:self.home.accessories[indexPath.section] completionHandler:^(NSError * _Nullable error) {
            if (error==nil) {
                NSLog(@"remove accessory success");
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationFade)];
                [tableView endUpdates];
            }else{
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
                [tableView endUpdates];
            }
        }];
    }
   
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isAssignToRoom==NO) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
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
