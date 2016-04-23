//
//  TimeTriggerViewController.m
//  homedp
//
//  Created by GYJ on 16/4/18.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "TimeTriggerViewController.h"
#import "UUDatePicker.h"
#import <HomeKit/HomeKit.h>
@interface TimeTriggerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIAlertAction *action;
    NSArray *weeks;
    NSArray *days;
    NSArray *hours;
    NSArray *minutes;
}
@property(nonatomic,strong)UITableView *timeTrigger;
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
static NSString *timeTrigger=@"timeTrigger";

@implementation TimeTriggerViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.week=@"0周";
    self.day=@"0天";
    self.hour=@"00小时";
    self.minute=@"00分";
    
    weeks=[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4", nil];
    days=[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6", nil];
    hours=[NSArray arrayWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];
    minutes=[NSArray arrayWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", @"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60", nil];
    
    
    
    self.timeTrigger=[[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.timeTrigger.delegate=self;
    self.timeTrigger.dataSource=self;
    [self.view addSubview:self.timeTrigger];
    
    
    
    self.tf=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)complement{
    if (self.name.length==0||self.date==nil) {
        UIAlertController *a=[UIAlertController alertControllerWithTitle:@"提示" message:@"请填写完整" preferredStyle:(UIAlertControllerStyleAlert)];
        [a addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:a animated:YES completion:nil];
    }else{
        HMTimerTrigger *trigger=[[HMTimerTrigger alloc] initWithName:self.name fireDate:self.date timeZone:self.timeZone recurrence:self.dateComponent recurrenceCalendar:[NSCalendar currentCalendar]];
        self.addT(trigger);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:timeTrigger];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:timeTrigger];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text=self.name;
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            break;
        case 1:
        {
            [cell.contentView addSubview:_tf];
        }
            break;
        case 2:
            [cell.contentView addSubview:self.tz];
            break;
        case 3:
            [cell.contentView addSubview:self.re];
            break;
        case 4:
            [cell.contentView addSubview:self.b];
            [cell.contentView addSubview:self.back];
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
            return nil;
            break;
        default:
            return nil;
            break;
    }

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
                [weakSelf.timeTrigger reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
            }];
            action.enabled=NO;
            [a addAction:action];
            [a addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
            [self presentViewController:a animated:YES completion:nil];
        }
            break;
        case 1:
        {
            
            
        }
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
             
            break;
        default:
            break;
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
