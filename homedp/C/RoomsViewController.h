//
//  RoomsViewController.h
//  homedp
//
//  Created by GYJ on 16/4/8.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMHome;
@interface RoomsViewController : UIViewController
@property(nonatomic,strong)HMHome *home;
-(void)addRoom;
-(void)deleteRoomWithName:(NSString*)name;
@end
