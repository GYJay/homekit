//
//  setMenuViewController.h
//  homedp
//
//  Created by GYJ on 16/4/10.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMHome;
typedef HMHome*(^update)();
@interface setMenuViewController : UIViewController
@property(nonatomic,assign)BOOL isFromRight;
@property(nonatomic,strong)HMHome *home;
@property(nonatomic,copy)update updateHome;
@end
