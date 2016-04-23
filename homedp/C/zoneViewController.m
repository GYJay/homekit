//
//  zoneViewController.m
//  homedp
//
//  Created by GYJ on 16/4/11.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "zoneViewController.h"
#import <HomeKit/HomeKit.h>
#import "addRoomToZoneController.h"
#import "HYBBubbleTransition.h"
@interface zoneViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIAlertAction *action;
}

@property(nonatomic,copy)NSString *addZoneName;
@property(nonatomic,strong)HYBBubbleTransition *ble;
@end

static NSString *zoneCell=@"zoneCell";
@implementation zoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=[NSString stringWithFormat:@"%@的分组",self.home.name];
    self.zoneTable=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.zoneTable.delegate=self;
    self.zoneTable.dataSource=self;
    [self.view addSubview:self.zoneTable];
    self.navigationController.navigationBar.hidden=NO;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(addZone)];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgZone"] forBarMetrics:(UIBarMetricsDefault)];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes=dict;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.addZoneName = textField.text;
}

//监听textField
-(void)textFieldChanged:(UITextField *)textField{
    if (textField.text.length==0) {
        action.enabled=NO;
    }else{
        action.enabled=YES;
    }
}




-(void)addZone{
    __weak __typeof(self) weakSelf = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新建Zone"message:@"给你的分区取一个独一无二的名字."preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.delegate = self;
        textField.placeholder = @"Zone name";
        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
    }];
    
    action=[UIAlertAction actionWithTitle:@"添加"style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf.home addZoneWithName:self.addZoneName completionHandler:^(HMZone * _Nullable zone, NSError * _Nullable error) {
            if (error==nil) {
                NSLog(@"add zone success");
                [weakSelf.zoneTable reloadData];
            }else{
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
        }];
    }];
    action.enabled=NO;
    [alert addAction:action];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        weakSelf.addZoneName = nil;
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.home.zones.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.home.zones[section].rooms.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:zoneCell];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:zoneCell];
    }
    
    cell.textLabel.text=self.home.zones[indexPath.section].rooms[indexPath.row].name;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    roomsInZoneViewController *rvc=[[roomsInZoneViewController alloc] init];
//    rvc.zone=self.home.zones[indexPath.row];
//    [self.navigationController pushViewController:rvc animated:YES];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
    l.text=self.home.zones[section].name;
    l.textColor=[UIColor grayColor];
    
    
    UIButton *b=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 5, 30, 30)];
    [b setBackgroundColor:[UIColor purpleColor]];
    [b setTitle:@"+" forState:(UIControlStateNormal)];
    b.layer.cornerRadius=15;
    [b addTarget:self action:@selector(addRoomsWithButton:) forControlEvents:(UIControlEventTouchUpInside)];
    b.tag=section+10000;
    
    
    UIButton *d=[[UIButton alloc] initWithFrame:CGRectMake(b.frame.origin.x-50, 5, 30, 30)];
    [d setBackgroundColor:[UIColor blueColor]];
    [d setTitle:@"-" forState:(UIControlStateNormal)];
    d.layer.cornerRadius=15;
    d.tag=section+10000;
    [d addTarget:self action:@selector(deleteZoneWithButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [v addSubview:l];
    [v addSubview:b];
    [v addSubview:d];
    return v;
}


-(void)deleteZoneWithButton:(UIButton *)b{
    __weak __typeof(self) weakSelf = self;
    UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:@"要删除这个分区吗？" preferredStyle:(UIAlertControllerStyleAlert)];
    [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        [self.home removeZone:weakSelf.home.zones[b.tag-10000] completionHandler:^(NSError * _Nullable error) {
            if (error==nil) {
                NSLog(@"remove zone success");
                [weakSelf.zoneTable reloadData];
            }else{
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
            
        }];
    }]];
    [a addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
    [self presentViewController:a animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.zoneTable reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(void)addRoomsWithButton:(UIButton *)b{
    __weak __typeof(self) weakSelf=self;
    addRoomToZoneController *rvc=[[addRoomToZoneController alloc]init];
    rvc.modalPresentationStyle=UIModalPresentationCustom;
    rvc.zone=self.home.zones[b.tag-10000];
    rvc.home=self.home;
    rvc.re=^(){
        [weakSelf.zoneTable reloadData];
    };
    self.ble=[[HYBBubbleTransition alloc] initWithPresented:^(UIViewController *presented, UIViewController *presenting, UIViewController *source, HYBBaseTransition *transition) {
        HYBBubbleTransition *bubble = (HYBBubbleTransition *)transition;
        bubble.bubbleColor = presented.view.backgroundColor;
        CGPoint center = [b.superview convertPoint:b.center toView:self.view];
        center.y += 64;
        bubble.bubbleStartPoint = center;
    } dismissed:^(UIViewController *dismissed, HYBBaseTransition *transition) {
        transition.transitionMode = kHYBTransitionDismiss;
    }];
    rvc.transitioningDelegate=self.ble;
    [self presentViewController:rvc animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self) weakSelf=self;
    [self.zoneTable beginUpdates];
    [self.home.zones[indexPath.section] removeRoom:self.home.zones[indexPath.section].rooms[indexPath.row] completionHandler:^(NSError * _Nullable error) {
        if (error==nil) {
            NSLog(@"remove room success");
            [weakSelf.zoneTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:(UITableViewRowAnimationFade)];
            [weakSelf.zoneTable endUpdates];
        }else{
            [tableView endUpdates];
            UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
            [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
            [weakSelf presentViewController:a animated:YES completion:nil];
        }
    }];
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
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
