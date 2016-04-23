//
//  CharacteristicInfoViewController.h
//  homedp
//
//  Created by GYJ on 16/4/23.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMService;
@class HMAccessory;
@interface CharacteristicInfoViewController : UIViewController
@property(nonatomic,strong)HMService *service;
@property(nonatomic,strong)HMAccessory *accessory;
@end
