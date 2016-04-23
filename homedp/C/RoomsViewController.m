//
//  RoomsViewController.m
//  homedp
//
//  Created by GYJ on 16/4/8.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "RoomsViewController.h"
#import <HomeKit/HomeKit.h>
#import "roomCell.h"
#import "setMenuViewController.h"
#import "InRoomAccessoryViewController.h"
@interface RoomsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    UIAlertAction *action;
}
@property(nonatomic,strong)UICollectionView *roomViews;
@property(nonatomic,strong)UILongPressGestureRecognizer *longPress;
@property(nonatomic,copy)NSString *addRoomName;
@end

static NSString *re=@"rr";
@implementation RoomsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"房间";
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes=dict;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.width/2);
    layout.minimumLineSpacing=0;
    layout.minimumInteritemSpacing=0;
    self.roomViews=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.roomViews.delegate=self;
    self.roomViews.dataSource=self;
    self.roomViews.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.roomViews];
    [self.roomViews registerClass:[roomCell class] forCellWithReuseIdentifier:re];
    [self addGesture];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgRoom"] forBarMetrics:(UIBarMetricsDefault)];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"siri_image_large.jpg"]];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
    for (UIView *cell in self.roomViews.subviews) {
        if ([cell isKindOfClass:[roomCell class]]) {
            ((roomCell*)cell).b.hidden=YES;
            ((roomCell*)cell).labelName.enabled=NO;
        }
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    ((setMenuViewController*)self.navigationController.viewControllers[1]).isFromRight=NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.addRoomName = textField.text;
}

//监听textField
-(void)textFieldChanged:(UITextField *)textField{
    if (textField.text.length==0) {
        action.enabled=NO;
    }else{
        action.enabled=YES;
    }
}


-(void)addGesture{
    if (self.longPress==nil) {
        self.longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Edited:)];
        self.longPress.delegate=self;
        _longPress.minimumPressDuration=1.0f;
    }
    [self.roomViews addGestureRecognizer:_longPress];
}


-(void)Edited:(UILongPressGestureRecognizer*)longpress{
    if (longpress.state==UIGestureRecognizerStateBegan) {
        for (UIView *v in self.roomViews.subviews) {
            if ([v isKindOfClass:[roomCell class]]) {
                [((roomCell*)v) doAnimate];
                //((homesCell*)v).isAnimate=YES;
            }
        }
    }
}

-(void)addRoom{
    __weak __typeof(self) weakSelf = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新建room"message:@"给你的房间取一个独一无二的名字."preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.delegate = self;
        textField.placeholder = @"Room name";
        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
    }];
    
    action=[UIAlertAction actionWithTitle:@"添加"style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf.home addRoomWithName:self.addRoomName completionHandler:^(HMRoom * _Nullable room, NSError * _Nullable error) {
            if (error==nil) {
                NSLog(@"add room success");
                [weakSelf.roomViews reloadData];
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
        weakSelf.addRoomName= nil;
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)deleteRoomWithName:(NSString *)name{
    __weak __typeof(self) weakSelf = self;
    HMRoom *h;
    NSUInteger index=0;

    for (NSInteger i=0; i<self.home.rooms.count; i++) {
        if ([self.home.rooms[i].name isEqualToString:name]) {
            h=self.home.rooms[i];
            index=i;
        }
    }
    [self.home removeRoom:h completionHandler:^(NSError * _Nullable error) {
        if (error==nil) {
            NSLog(@"remove room success");
            [weakSelf.roomViews deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
            [NSThread sleepForTimeInterval:1];
            for (UIView *cell in self.roomViews.subviews) {
                if ([cell isKindOfClass:[roomCell class]]) {
                    ((roomCell*)cell).b.hidden=YES;
                    [((roomCell*)cell).contentView.layer removeAllAnimations];
                }
            }
        }else{
            UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
            [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
            [weakSelf presentViewController:a animated:YES completion:nil];
        }
    }];

}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.home.rooms.count+1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     roomCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:re forIndexPath:indexPath];
    if (indexPath.item<self.home.rooms.count) {
        cell.isAdd=NO;
        [cell setLableWithName:((HMHome*)self.home.rooms[indexPath.item]).name];
    }else{
        cell.isAdd=YES;
        [cell setLableWithName:nil];
    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    InRoomAccessoryViewController *invc=[[InRoomAccessoryViewController alloc]init];
    invc.room=self.home.rooms[indexPath.item];
    invc.home=self.home;
    [self.navigationController pushViewController:invc animated:YES];
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
