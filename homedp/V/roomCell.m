//
//  roomCell.m
//  homedp
//
//  Created by GYJ on 16/4/9.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "roomCell.h"
#import "RoomsViewController.h"
@implementation roomCell

-(void)deleted{
    [((RoomsViewController*)((UICollectionView*)self.superview).delegate) deleteRoomWithName:self.labelName.text];
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
        self.homeIcon.image=[UIImage imageNamed:@"room"];
    }else{
        self.labelName.text=nil;
        UIButton *b=[[UIButton alloc] initWithFrame:self.contentView.bounds];
        b.backgroundColor=[UIColor clearColor];
        b.tag=10001;
        [b addTarget:(RoomsViewController*)((UICollectionView*)self.superview).delegate action:@selector(addRoom) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:b];
        self.homeIcon.image=[UIImage imageNamed:@"added"];
    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
