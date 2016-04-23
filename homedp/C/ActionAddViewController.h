//
//  ActionSetManageViewController.h
//  homedp
//
//  Created by GYJ on 16/4/22.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMTimerTrigger;
@class HMHome;
typedef void(^success)();
@interface ActionAddViewController : UIViewController
@property(nonatomic,strong)HMTimerTrigger *trigger;
@property(nonatomic,strong)HMHome *home;
@property(nonatomic,copy)success addsuccess;
@end
