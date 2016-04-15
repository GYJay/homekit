//
//  homesCell.h
//  homedp
//
//  Created by GYJ on 16/4/8.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface homesCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *homeIcon;
@property(nonatomic,strong)UILabel *labelName;
@property(nonatomic,assign)BOOL isAdd;
@property(nonatomic,strong)UIButton *b;
-(void)deleted;
-(void)setLableWithName:(NSString *)name;
-(void)doAnimate;
@end
