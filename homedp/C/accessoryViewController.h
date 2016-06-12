//
//  accessoryViewController.h
//  homedp
//
//  Created by GYJ on 16/4/10.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMHome;
typedef void(^backReload)();
@interface accessoryViewController : UIViewController
@property(nonatomic,strong)HMHome *home;
@property(nonatomic,copy)backReload br;
@end
