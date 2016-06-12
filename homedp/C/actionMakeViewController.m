//
//  actionMakeViewController.m
//  homedp
//
//  Created by GYJ on 16/4/22.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "actionMakeViewController.h"
#import <HomeKit/HomeKit.h>
@interface actionMakeViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView * actionMakeTable;
@property(nonatomic,strong)UITextField * accessoryName;
@property(nonatomic,strong)UITextField * serviceName;
@property(nonatomic,strong)UITextField * characteristicName;
@property(nonatomic,strong)UITextField * targetValue;
@property(nonatomic,strong)UIPickerView * accessoryPick;
@property(nonatomic,strong)UIPickerView * servicePick;
@property(nonatomic,strong)UIPickerView *characteristicPick;
@property(nonatomic,strong)HMAccessory *selectAccessory;
@property(nonatomic,strong)HMService *selectService;
@property(nonatomic,strong)HMCharacteristic *selectCharacteristic;
@property(nonatomic,strong)UIButton *b;
@property(nonatomic,strong)UIButton *back;
@end

static NSString *actionMakeCell=@"actionMakeCell";

@implementation actionMakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.actionMakeTable=[[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.actionMakeTable.delegate=self;
    self.actionMakeTable.dataSource=self;
    [self.view addSubview:self.actionMakeTable];
    
    self.accessoryName=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.accessoryName.textAlignment=NSTextAlignmentCenter;
    
    self.serviceName=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.serviceName.textAlignment=NSTextAlignmentCenter;
    
    self.characteristicName=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.characteristicName.textAlignment=NSTextAlignmentCenter;
    
    self.targetValue=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.targetValue.textAlignment=NSTextAlignmentCenter;
    self.targetValue.delegate=self;
    
    self.accessoryPick=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    self.accessoryPick.delegate=self;
    self.accessoryPick.dataSource=self;
    self.accessoryPick.backgroundColor=[UIColor whiteColor];
    self.accessoryPick.tag=10000;
    
    self.servicePick=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    self.servicePick.delegate=self;
    self.servicePick.dataSource=self;
    self.servicePick.backgroundColor=[UIColor whiteColor];
    self.servicePick.tag=10001;
    
    self.characteristicPick=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    self.characteristicPick.delegate=self;
    self.characteristicPick.dataSource=self;
    self.characteristicPick.backgroundColor=[UIColor whiteColor];
    self.characteristicPick.tag=10002;
    
    UIToolbar *b=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    UIBarButtonItem *bitem=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:self action:@selector(resign)];
    b.items=@[bitem];
    
    self.accessoryName.inputView=self.accessoryPick;
    self.accessoryName.inputAccessoryView=b;
    
    self.serviceName.inputView=self.servicePick;
    self.serviceName.inputAccessoryView=b;
    
    self.characteristicName.inputView=self.characteristicPick;
    self.characteristicName.inputAccessoryView=b;
    
    
    self.b=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2, 44)];
    [self.b setTitle:@"完成" forState:(UIControlStateNormal)];
    [self.b setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.b addTarget:self action:@selector(backTo) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.back=[[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 0, [UIScreen mainScreen].bounds.size.width/2, 44)];
    [self.back setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.back setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.back addTarget:self action:@selector(cancel) forControlEvents:(UIControlEventTouchUpInside)];
}



-(void)backTo{
    __weak __typeof(self)weakSelf=self;
    if (self.selectCharacteristic==nil||self.targetValue.text.length==0) {
        UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:@"请填写完整" preferredStyle:(UIAlertControllerStyleAlert)];
        [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:a animated:YES completion:nil];
    }else{
        id value=self.targetValue.text;
        if ([self.selectCharacteristic.metadata.format isEqualToString:@"bool"]) {
            if ([self.targetValue.text isEqualToString:@"1"]) {
                value=@(YES);
            }else if ([self.targetValue.text isEqualToString:@"0"]){
                value=@(NO);
            }
        }else if([self.selectCharacteristic.metadata.format isEqualToString:@"Int"]||[self.selectCharacteristic.metadata.format isEqualToString:@"UInt8"]||[self.selectCharacteristic.metadata.format isEqualToString:@"UInt16"]||[self.selectCharacteristic.metadata.format isEqualToString:@"UInt32"]||[self.selectCharacteristic.metadata.format isEqualToString:@"UInt64"]){
            
        }else if ([self.selectCharacteristic.metadata.format isEqualToString:@"string"]){
        
        }else if([self.selectCharacteristic.metadata.format isEqualToString:@"Float"]){
        
        }
        HMCharacteristicWriteAction *action=[[HMCharacteristicWriteAction alloc] initWithCharacteristic:self.selectCharacteristic targetValue:@([value integerValue])];
        [self.actionSet addAction:action completionHandler:^(NSError * _Nullable error) {
            if (error==nil) {
                NSLog(@"add action success");
                weakSelf.ad();
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }else{
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
        }];
        
    }
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGPoint p=[self.view convertPoint:textField.frame.origin fromView:textField.superview];
    CGFloat offset=self.view.frame.size.height-(p.y+textField.frame.size.height+50+216);
    if (offset<=0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=self.actionMakeTable.frame;
            frame.origin.y=offset;
            self.actionMakeTable.frame=frame;
        }];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=self.actionMakeTable.frame;
            frame.origin.y=0;
            self.actionMakeTable.frame=frame;
        }];
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.targetValue]) {
        [self.targetValue resignFirstResponder];
        return YES;
    }else{
        return NO;
    }
}

-(void)resign{
    [self.accessoryName resignFirstResponder];
    [self.serviceName resignFirstResponder];
    [self.characteristicName resignFirstResponder];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag==10000) {
        return self.home.accessories.count;
    }else if (pickerView.tag==10001){
        return self.selectAccessory.services.count-1;
    }else if (pickerView.tag==10002){
        return self.selectService.characteristics.count-1;
    }else{
        return 0;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag==10000) {
        if (self.home.accessories.count!=0) {
            if (![self.selectAccessory isEqual:self.home.accessories[row]]) {
                self.selectService=nil;
                self.serviceName.text=nil;
                self.selectCharacteristic=nil;
                self.characteristicName.text=nil;
                self.targetValue.placeholder=nil;
                self.targetValue.text=nil;
            }
            self.selectAccessory=self.home.accessories[row];
            self.accessoryName.text=self.selectAccessory.name;
        }
        
    }else if (pickerView.tag==10001){
        if (self.selectAccessory.services.count>1) {
            if (![self.selectService isEqual:self.selectAccessory.services[row+1]]) {
                self.selectCharacteristic=nil;
                self.characteristicName.text=nil;
                self.targetValue.placeholder=nil;
                self.targetValue.text=nil;
            }
            self.selectService=self.selectAccessory.services[row+1];
            self.serviceName.text=self.selectService.name;
        }
    }else if (pickerView.tag==10002){
        if (![self.selectCharacteristic isEqual:self.selectService.characteristics[row+1]]) {
            self.targetValue.text=nil;
        }
        self.selectCharacteristic=self.selectService.characteristics[row+1];
        self.characteristicName.text=self.selectCharacteristic.localizedDescription;
        if (self.selectCharacteristic.metadata.minimumValue!=nil&&self.selectCharacteristic.metadata.maximumValue!=nil) {
            self.targetValue.placeholder=[NSString stringWithFormat:@"%@~%@之间%@的整数倍",self.selectCharacteristic.metadata.minimumValue,self.selectCharacteristic.metadata.maximumValue,self.selectCharacteristic.metadata.stepValue];
        }else if ([self.selectCharacteristic.metadata.format isEqualToString:@"bool"]){
            self.targetValue.placeholder=[NSString stringWithFormat:@"0为否 1为是"];
        }else if ([self.selectCharacteristic.metadata.format isEqualToString:@"string"]){
            self.targetValue.placeholder=[NSString stringWithFormat:@"字符串"];
        }
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag==10000) {
        return self.home.accessories[row].name;
    }else if (pickerView.tag==10001){
        return self.selectAccessory.services[row+1].name;
    }else if (pickerView.tag==10002){
        return self.selectService.characteristics[row+1].localizedDescription;
    }else{
        return nil;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"设备";
            break;
        case 1:
            return @"服务";
            break;
        case 2:
            return @"特性";
            break;
        case 3:
            return @"目标值";
            break;
        default:
            return nil;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:actionMakeCell];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:actionMakeCell];
    }
    switch (indexPath.section) {
        case 0:
            [cell.contentView addSubview:self.accessoryName];
            break;
        case 1:
            [cell.contentView addSubview:self.serviceName];
            break;
        case 2:
            [cell.contentView addSubview:self.characteristicName];
            break;
        case 3:
            [cell.contentView addSubview:self.targetValue];
            break;
        case 4:
            [cell.contentView addSubview:self.back];
            [cell.contentView addSubview:self.b];
            break;
        default:
            break;
    }
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
