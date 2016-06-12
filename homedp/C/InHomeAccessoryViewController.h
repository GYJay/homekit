//
//  InHomeAccessoryViewController.h
//  homedp
//
//  Created by GYJ on 16/4/11.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMHome;
@class HMRoom;
typedef void(^backReload)();
@interface InHomeAccessoryViewController : UIViewController
@property(nonatomic,strong)HMHome *home;
@property(nonatomic,strong)HMRoom *room;
@property(nonatomic,assign)BOOL isAssignToRoom;
@property(nonatomic,copy)backReload br;
@end
