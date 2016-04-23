//
//  actionMakeViewController.h
//  homedp
//
//  Created by GYJ on 16/4/22.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMHome;
@class HMActionSet;
//@class HMCharacteristicWriteAction;
typedef void(^addAction)();
@interface actionMakeViewController : UIViewController
@property(nonatomic,strong)HMHome *home;
@property(nonatomic,strong)HMActionSet *actionSet;
@property(nonatomic,copy)addAction ad;
@end
