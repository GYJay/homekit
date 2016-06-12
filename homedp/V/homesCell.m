//
//  homesCell.m
//  homedp
//
//  Created by GYJ on 16/4/8.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "homesCell.h"
#import "ViewController.h"
#define angelToRandian(x) ((x)/180.0*M_PI)
@interface homesCell ()


@end

@implementation homesCell
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
//        self.layer.borderWidth=0.5;
//        self.layer.borderColor=[[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
        
        
        self.homeIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@" 2"]];
        [self.homeIcon setFrame:CGRectMake(30, 30, [UIScreen mainScreen].bounds.size.width/2-60, [UIScreen mainScreen].bounds.size.width/2-60)];
        self.homeIcon.alpha=0.75;
        self.homeIcon.userInteractionEnabled=YES;
        
        self.labelName=[[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.width/2-30, [UIScreen mainScreen].bounds.size.width/2, 30)];
        self.labelName.enabled=NO;
        [self.contentView addSubview:self.labelName];
        self.labelName.textColor=[UIColor whiteColor];
        self.labelName.adjustsFontSizeToFitWidth=YES;
        self.labelName.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.homeIcon];
        
        
        self.b=[[UIButton alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
        [self.b setBackgroundImage:[UIImage imageNamed:@"cha"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:self.b];
        [self.b addTarget:self action:@selector(deleted) forControlEvents:(UIControlEventTouchUpInside)];
        self.b.hidden=YES;
        
        
        self.nameB=[[UIButton alloc] initWithFrame:self.labelName.frame];
        self.nameB.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.nameB];
        
    }
    return self;
}

-(void)deleted{
    [((ViewController*)((UICollectionView*)self.superview).delegate) deleteHomeWithName:self.labelName.text];
}



-(void)setLableWithName:(NSString *)name{
    UIButton *b;
    for (UIView *v in self.contentView.subviews) {
        if ([v isKindOfClass:[UIButton class]]&&v.tag==10001) {
            b=(UIButton*)v;
        }
    }
    [b removeFromSuperview];
    if (self.isAdd==NO) {
        self.labelName.text=name;
        self.homeIcon.image=[UIImage imageNamed:@" 2"];
    }else{
        self.labelName.text=nil;
        UIButton *b=[[UIButton alloc] initWithFrame:self.contentView.bounds];
        b.backgroundColor=[UIColor clearColor];
        b.tag=10001;
        [b addTarget:(ViewController*)((UICollectionView*)self.superview).delegate action:@selector(addHome) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:b];
        self.homeIcon.image=[UIImage imageNamed:@"added"];
    }    
}

-(void)doAnimate{
    if (self.isAdd==NO) {
        [self.contentView.layer removeAllAnimations];
        self.b.hidden=NO;
        self.labelName.enabled=YES;
        CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
        anim.delegate=self;
        anim.keyPath=@"transform.rotation";
        anim.values=@[@(angelToRandian(-1.5)),@(angelToRandian(arc4random()%1+1)),@(angelToRandian((arc4random()%1+1))),@(angelToRandian(arc4random()%1+1)),@(angelToRandian(-1.5))];
        anim.repeatCount=MAXFLOAT;
        anim.duration=0.11;
        [self.contentView.layer addAnimation:anim forKey:nil];
    }
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.layer removeAllAnimations];
    self.b.hidden=YES;
}



@end
