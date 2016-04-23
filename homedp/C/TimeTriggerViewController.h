//
//  TimeTriggerViewController.h
//  homedp
//
//  Created by GYJ on 16/4/18.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMTimerTrigger;

typedef void(^addTrigger)(HMTimerTrigger *trigger);

@interface TimeTriggerViewController : UIViewController
@property(nonatomic,copy)addTrigger addT;

@end
