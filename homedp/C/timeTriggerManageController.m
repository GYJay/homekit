//
//  timeTriggerManageController.m
//  homedp
//
//  Created by GYJ on 16/4/21.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "timeTriggerManageController.h"
#import <HomeKit/HomeKit.h>
#import "UUDatePicker.h"
#import "ActionAddViewController.h"
@interface timeTriggerManageController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIAlertAction *action;
    NSArray *weeks;
    NSArray *days;
    NSArray *hours;
    NSArray *minutes;
}
@property(nonatomic,strong)UITableView *triggerManage;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSDate *date;
@property(nonatomic,strong)NSDateComponents *dateComponent;
@property(nonatomic,strong)NSTimeZone *timeZone;
@property(nonatomic,strong)UITextField *tf;
@property(nonatomic,strong)UITextField *tz;
@property(nonatomic,strong)UITextField *re;
@property(nonatomic,strong)UUDatePicker *udataPicker;
@property(nonatomic,strong)UIPickerView *recourTime;
@property(nonatomic,copy)NSString *week;
@property(nonatomic,copy)NSString *day;
@property(nonatomic,copy)NSString *hour;
@property(nonatomic,copy)NSString *minute;
@property(nonatomic,strong)UIButton *b;
@property(nonatomic,strong)UIButton *back;
@end

static NSString *tcell=@"tcell";

@implementation timeTriggerManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.triggerManage=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.triggerManage.delegate=self;
    self.triggerManage.dataSource=self;
    [self.view addSubview:self.triggerManage];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(backto)];
    
    self.week=@"0周";
    self.day=@"0天";
    self.hour=@"00小时";
    self.minute=@"00分";
    
    weeks=[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4", nil];
    days=[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6", nil];
    hours=[NSArray arrayWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];
    minutes=[NSArray arrayWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", @"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60", nil];
    self.tf=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    
    self.name=self.trigger.name;
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"yyyy年MM月dd日HH时mm分";
    self.tf.text=[formatter stringFromDate:self.trigger.fireDate];
    
    __weak __typeof (self) weakSelf = self;
    self.udataPicker=[[UUDatePicker alloc] initWithframe:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200) PickerStyle:0 didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        weakSelf.tf.text=[NSString stringWithFormat:@"%@年%@月%@日%@时%@分",year,month,day,hour,minute];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        formatter.dateFormat=@"yyyyMMddHHmm";
        weakSelf.date=[formatter dateFromString:[NSString stringWithFormat:@"%@%@%@%@%@",year,month,day,hour,minute]];
    }];
    self.udataPicker.minLimitDate=[NSDate dateWithTimeIntervalSinceNow:0];
    
    
    
    UIToolbar *b=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    UIBarButtonItem *bitem=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:self action:@selector(resign)];
    b.items=@[bitem];
    
    
    _tf.inputView=self.udataPicker;
    _tf.inputAccessoryView=b;
    _tf.textAlignment=NSTextAlignmentCenter;
    
    
    self.tz=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.tz.textAlignment=NSTextAlignmentCenter;
    UIPickerView *pick=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    pick.backgroundColor=[UIColor whiteColor];
    pick.delegate=self;
    pick.dataSource=self;
    pick.tag=10000;
    self.tz.inputView=pick;
    self.tz.inputAccessoryView=b;
    self.tz.text=self.trigger.timeZone.name;
    
    
    self.re=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.re.textAlignment=NSTextAlignmentCenter;
    self.recourTime=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    _recourTime.backgroundColor=[UIColor whiteColor];
    _recourTime.delegate=self;
    _recourTime.dataSource=self;
    _recourTime.tag=10001;
    [_recourTime selectRow:5 inComponent:3 animated:YES];
    self.re.inputView=_recourTime;
    self.re.inputAccessoryView=b;
    if (self.trigger.recurrence==nil) {
        self.re.text=nil;
    }else{
        self.re.text=[NSString stringWithFormat:@"%ld周%ld天%ld小时%ld分",self.trigger.recurrence.weekOfMonth,self.trigger.recurrence.day,self.trigger.recurrence.hour,self.trigger.recurrence.minute];
    }
    
    
    
    self.b=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2, 44)];
    [self.b setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.b setTitle:@"完成" forState:(UIControlStateNormal)];
    [self.b addTarget:self action:@selector(complement) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.back=[[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 0, [UIScreen mainScreen].bounds.size.width/2, 44)];
    [self.back setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.back setTitle:@"返回" forState:(UIControlStateNormal)];
    [self.back addTarget:self action:@selector(backto)
        forControlEvents:(UIControlEventTouchUpInside)];

}


-(void)backto{
    UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:@"要放弃修改吗？" preferredStyle:(UIAlertControllerStyleAlert)];
    [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [a addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
    [self presentViewController:a animated:YES completion:nil];
}

-(void)complement{
    __weak __typeof(self)weakSelf =self;
    if (self.name!=nil) {
        [self.trigger updateName:self.name completionHandler:^(NSError * _Nullable error) {
            if (error==nil) {
                NSLog(@"update name success");
                [weakSelf.navigationController popViewControllerAnimated:YES];
                weakSelf.addT();
            }else{
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
        }];
    }
    
    if (self.date!=nil) {
        [self.trigger updateFireDate:self.date completionHandler:^(NSError * _Nullable error) {
            if (error==nil) {
                NSLog(@"update fireDate success");
                [weakSelf.navigationController popViewControllerAnimated:YES];
                weakSelf.addT();
            }else{
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
        }];
    }
    
        [self.trigger updateTimeZone:self.timeZone completionHandler:^(NSError * _Nullable error) {
            if (error==nil) {
                NSLog(@"update TimeZone success");
                [weakSelf.navigationController popViewControllerAnimated:YES];
                weakSelf.addT();
            }else{
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
        }];
    
        [self.trigger updateRecurrence:self.dateComponent completionHandler:^(NSError * _Nullable error) {
            if (error==nil) {
                NSLog(@"update Recurrence success");
                [weakSelf.navigationController popViewControllerAnimated:YES];
                weakSelf.addT();
            }else{
                UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                [weakSelf presentViewController:a animated:YES completion:nil];
            }
        }];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag==10000) {
        self.tz.text=[NSTimeZone knownTimeZoneNames][row];
        self.timeZone=[NSTimeZone timeZoneWithName:[NSTimeZone knownTimeZoneNames][row]];
    }else if (pickerView.tag==10001){
        switch (component) {
            case 0:
                self.week=[NSString stringWithFormat:@"%@周",weeks[row]];
                break;
            case 1:
                self.day=[NSString stringWithFormat:@"%@天",days[row]];
                break;
            case 2:
                self.hour=[NSString stringWithFormat:@"%@小时",hours[row]];
                break;
            case 3:
                self.minute=[NSString stringWithFormat:@"%@分",minutes[row]];
                break;
            default:
                break;
        }
        if ([self.week isEqualToString:@"0周"]&&[self.day isEqualToString:@"0天"]&&[self.hour isEqualToString:@"00小时"]&&[self.minute substringToIndex:2].integerValue<5) {
            [self.recourTime selectRow:5 inComponent:3 animated:YES];
            self.minute=@"05分";
        }
        self.re.text=[NSString stringWithFormat:@"%@%@%@%@",self.week,self.day,self.hour,self.minute];
        self.dateComponent=[[NSDateComponents alloc] init];
        [self.dateComponent setWeekOfMonth:[[self.week substringToIndex:1] intValue]];
        [self.dateComponent setDay:[[self.day substringToIndex:1] intValue]];
        [self.dateComponent setHour:[[self.hour substringToIndex:2] intValue]];
        [self.dateComponent setMinute:[[self.minute substringToIndex:2] intValue]];
    }
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView.tag==10000) {
        return 1;
    }else if (pickerView.tag==10001){
        return 4;
    }else{
        return 0;
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag==10000) {
        return [NSTimeZone knownTimeZoneNames].count;
    }else if (pickerView.tag==10001){
        switch (component) {
            case 0:
                return 5;
                break;
            case 1:
                return 7;
                break;
            case 2:
                return 24;
                break;
            case 3:
                return 61;
                break;
            default:
                return 0;
                break;
        }
    }else{
        return 0;
    }
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag==10000) {
        return [NSTimeZone knownTimeZoneNames][row];
    }else if (pickerView.tag==10001){
        switch (component) {
            case 0:
                return weeks[row];
                break;
            case 1:
                return days[row];
                break;
            case 2:
                return hours[row];
                break;
            case 3:
                return minutes[row];
                break;
            default:
                return nil;
                break;
        }
    }else{
        return nil;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==4) {
        return self.trigger.actionSets.count+1;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tcell];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:tcell];
    }
    cell.textLabel.text=nil;
    switch (indexPath.section) {
        case 0:
            if ([cell.contentView isEqual:self.b.superview]) {
                [self.b removeFromSuperview];
                [self.back removeFromSuperview];
            }
            cell.textLabel.text=self.name;
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            break;
        case 1:
        {
            if ([cell.contentView isEqual:self.b.superview]) {
                [self.b removeFromSuperview];
                [self.back removeFromSuperview];
            }
            [cell.contentView addSubview:_tf];
        }
            break;
        case 2:
            if ([cell.contentView isEqual:self.b.superview]) {
                [self.b removeFromSuperview];
                [self.back removeFromSuperview];
            }
            [cell.contentView addSubview:self.tz];
            break;
        case 3:
            if ([cell.contentView isEqual:self.b.superview]) {
                [self.b removeFromSuperview];
                [self.back removeFromSuperview];
            }
            [cell.contentView addSubview:self.re];
            break;
        case 4:
            if ([cell.contentView isEqual:self.b.superview]) {
                [self.b removeFromSuperview];
                [self.back removeFromSuperview];
            }
            if (indexPath.row==self.trigger.actionSets.count) {
                cell.textLabel.text=@"添加动作集";
            }else{
                cell.textLabel.text=self.trigger.actionSets[indexPath.row].name;
            }
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            break;
        case 5:
            cell.textLabel.text=nil;
            [cell.contentView addSubview:self.b];
            [cell.contentView addSubview:self.back];
            self.triggerManage.frame=self.view.bounds;
            break;
        default:
            break;
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"名称";
            break;
        case 1:
            return @"触发时间";
            break;
        case 2:
            return @"时区";
            break;
        case 3:
            return @"重复间隔";
            break;
        case 4:
            return @"动作集";
            break;
        default:
            return nil;
            break;
    }
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.udataPicker.minLimitDate=[NSDate dateWithTimeIntervalSinceNow:0];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.name = textField.text;
}

-(void)resign{
    [self.tf resignFirstResponder];
    [self.tz resignFirstResponder];
    [self.re resignFirstResponder];
}

//监听textField
-(void)textFieldChanged:(UITextField *)textField{
    if (textField.text.length==0) {
        action.enabled=NO;
    }else{
        action.enabled=YES;
    }
}


//-(void)setDateWithPick:(UIDatePicker *)datePicker{
//    self.date=datePicker.date;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof (self) weakSelf = self;
    switch (indexPath.section) {
        case 0:
        {
            UIAlertController *a=[UIAlertController alertControllerWithTitle:@"触发器名称" message:@"输入触发器名称" preferredStyle:(UIAlertControllerStyleAlert)];
            [a addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.delegate=self;
                [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
            }];
            action=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
                        [weakSelf.triggerManage reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
                
            }];
            action.enabled=NO;
            [a addAction:action];
            [a addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
            [self presentViewController:a animated:YES completion:nil];
        }
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
        {
            if (indexPath.row==self.trigger.actionSets.count) {
                ActionAddViewController *avc=[[ActionAddViewController alloc] init];
                avc.trigger=self.trigger;
                avc.home=self.home;
                avc.addsuccess=^(){
                    [self.triggerManage reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:(UITableViewRowAnimationFade)];
                    self.triggerManage.frame=self.view.bounds;
                };
                [self.navigationController pushViewController:avc animated:YES];
            }
            
        }
            break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self)weakSelf=self;
    if (indexPath.section==4) {
        if (indexPath.row<self.trigger.actionSets.count) {
            [tableView beginUpdates];
            [self.trigger removeActionSet:self.trigger.actionSets[indexPath.row]completionHandler:^(NSError * _Nullable error) {
                if (error==nil) {
                    NSLog(@"remove actionSet success");
                    [self.triggerManage deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:(UITableViewRowAnimationFade)];
                    [self.triggerManage endUpdates];
                }else{
                    [tableView endUpdates];
                    UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:[error.userInfo allValues][0] preferredStyle:(UIAlertControllerStyleAlert)];
                    [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
                    [weakSelf presentViewController:a animated:YES completion:nil];
                }
            }];
        }
    }else if (indexPath.section==3){
        self.re.text=nil;
        self.dateComponent=nil;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:(UITableViewRowAnimationFade)];
        [tableView endUpdates];
    }else if(indexPath.section==2){
        self.tz.text=nil;
        self.timeZone=nil;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:(UITableViewRowAnimationFade)];
        [tableView endUpdates];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==4&&indexPath.row<self.trigger.actionSets.count) {
        return UITableViewCellEditingStyleDelete;
    }else if (indexPath.section==3||indexPath.section==2){
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
