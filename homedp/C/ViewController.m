//
//  ViewController.m
//  homedp
//
//  Created by GYJ on 16/3/8.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "ViewController.h"
#import <HomeKit/HomeKit.h>
#import "homesCell.h"
#import "setMenuViewController.h"
#import "CALayer+drawLine.h"
@interface ViewController ()<HMHomeManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIAlertAction *action;
}
@property(nonatomic,strong)HMHomeManager *homemanage;
@property(nonatomic,strong)UICollectionView *homesView;
@property(nonatomic,copy)NSString *addHomeName;
@property(nonatomic,strong)UILongPressGestureRecognizer *longPress;
@end

static NSString *reuse=@"cell";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.homemanage=[[HMHomeManager alloc] init];
    self.homemanage.delegate=self;
    
    self.title=@"Homes";
    self.view.backgroundColor=[UIColor clearColor];
    //self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"delete"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(deleteHome)];
    //self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"add"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(addHome)];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:(UIBarMetricsDefault)];
    //self.navigationController.navigationBar.shadowImage=[UIImage imageNamed:@"meitu1"];
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:77/255.0 green:177/255.0 blue:250/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes=dict;

    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.width/2);
    layout.minimumLineSpacing=0;
    layout.minimumInteritemSpacing=0;

    self.homesView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [self.view addSubview:self.homesView];
    self.homesView.delegate=self;
    self.homesView.dataSource=self;
    self.homesView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    [self.homesView registerClass:[homesCell class] forCellWithReuseIdentifier:reuse];
    [self addGesture];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
    [self.homemanage.delegate homeManagerDidUpdateHomes:self.homemanage];
    for (UIView *cell in self.homesView.subviews) {
        if ([cell isKindOfClass:[homesCell class]]) {
            ((homesCell*)cell).b.hidden=YES;
            ((homesCell*)cell).labelName.enabled=NO;
        }
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.addHomeName = textField.text;
}

//监听textField
-(void)textFieldChanged:(UITextField *)textField{
    if (textField.text.length==0) {
        action.enabled=NO;
    }else{
        action.enabled=YES;
    }
}

-(void)deleteHomeWithName:(NSString *)name{
    __weak __typeof(self) weakSelf = self;
    HMHome *h;
    NSUInteger index=0;

    for (NSInteger i=0; i<self.homemanage.homes.count; i++) {
        if ([self.homemanage.homes[i].name isEqualToString:name]) {
            h=self.homemanage.homes[i];
            index=i;
        }
    }
        [self.homemanage removeHome:h completionHandler:^(NSError * _Nullable error) {
            if (error==nil) {
                NSLog(@"remove home success");
                [weakSelf.homesView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
                [NSThread sleepForTimeInterval:1];
                for (UIView *cell in self.homesView.subviews) {
                    if ([cell isKindOfClass:[homesCell class]]) {
                        ((homesCell*)cell).b.hidden=YES;
                        [((homesCell*)cell).contentView.layer removeAllAnimations];
                    }
                }
            }
        }];
}

//添加home
-(void)addHome{
    __weak __typeof(self) weakSelf = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新建Home"message:@"给你的房子取一个独一无二的名字."preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.delegate = self;
        textField.placeholder = @"Home name";
        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
    }];
    
    action=[UIAlertAction actionWithTitle:@"添加"style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf.homemanage addHomeWithName:weakSelf.addHomeName completionHandler:^(HMHome * _Nullable home, NSError * _Nullable error) {
            if (error==nil) {
                NSLog(@"add home success");
                [weakSelf.homemanage.delegate homeManagerDidUpdateHomes:weakSelf.homemanage];
            }else{
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:@"请不要添加重名的Home" preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
        }];
    }];
        action.enabled=NO;
        [alert addAction:action];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            weakSelf.addHomeName = nil;
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}



//添加home后
-(void)homeManager:(HMHomeManager *)manager didAddHome:(HMHome *)home{
    [self.homesView reloadData];
}
//更新home后
-(void)homeManagerDidUpdateHomes:(HMHomeManager *)manager{
    [self.homesView reloadData];
}
//更新PrimaryHome后
-(void)homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager{}
//移除home后
-(void)homeManager:(HMHomeManager *)manager didRemoveHome:(HMHome *)home{}

-(void)addGesture{
    if (self.longPress==nil) {
        self.longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Edited:)];
        self.longPress.delegate=self;
        _longPress.minimumPressDuration=1.0f;
    }
    [self.homesView addGestureRecognizer:_longPress];
}

-(void)Edited:(UILongPressGestureRecognizer*)longpress{
    if (longpress.state==UIGestureRecognizerStateBegan) {
        for (UIView *v in self.homesView.subviews) {
            if ([v isKindOfClass:[homesCell class]]) {
                [((homesCell*)v) doAnimate];
            }
        }
    }
}

#pragma arguments collection代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.homemanage.homes.count+1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    homesCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
    if (indexPath.item<self.homemanage.homes.count) {
        cell.isAdd=NO;
        [cell setLableWithName:((HMHome*)self.homemanage.homes[indexPath.item]).name];
    }else{
        cell.isAdd=YES;
        [cell setLableWithName:nil];
    }

    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    setMenuViewController *rvc=[[setMenuViewController alloc] init];
    rvc.home=self.homemanage.homes[indexPath.item];
    rvc.isFromRight=YES;
    [self.navigationController pushViewController:rvc animated:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
