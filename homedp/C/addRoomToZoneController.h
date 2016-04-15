//
//  addRoomToZoneController.h
//  homedp
//
//  Created by GYJ on 16/4/12.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMZone;
@class HMHome;
typedef void (^reload) ();
@interface addRoomToZoneController : UIViewController
@property(nonatomic,strong)HMZone *zone;
@property(nonatomic,strong)HMHome *home;
@property(nonatomic,copy)reload re;
@end
