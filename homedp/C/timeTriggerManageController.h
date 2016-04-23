//
//  timeTriggerManageController.h
//  homedp
//
//  Created by GYJ on 16/4/21.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMTimerTrigger;
@class HMHome;
typedef void(^updateTrigger)();
@interface timeTriggerManageController : UIViewController
@property(nonatomic,strong)HMTimerTrigger *trigger;
@property(nonatomic,copy)updateTrigger addT;
@property(nonatomic,strong)HMHome *home;
@end
