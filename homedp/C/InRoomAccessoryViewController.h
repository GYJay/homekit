//
//  InRoomAccessoryViewController.h
//  homedp
//
//  Created by GYJ on 16/4/11.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMRoom;
@class HMHome;
@interface InRoomAccessoryViewController : UIViewController
@property(nonatomic,strong)HMRoom *room;
@property(nonatomic,strong)HMHome *home;
@end
