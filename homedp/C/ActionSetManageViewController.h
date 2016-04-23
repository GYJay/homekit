//
//  ActionSetManageViewController.h
//  homedp
//
//  Created by GYJ on 16/4/22.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMActionSet;
@class HMHome;
@interface ActionSetManageViewController : UIViewController
@property(nonatomic,strong)HMActionSet *actionSet;
@property(nonatomic,strong)HMHome *home;
@end
