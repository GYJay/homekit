//
//  setViewCell.m
//  homedp
//
//  Created by GYJ on 16/4/10.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "setViewCell.h"

@interface setViewCell ()
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *title;
@end

@implementation setViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        self.imageV.userInteractionEnabled=YES;
        self.title=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [self.contentView addSubview:self.imageV];
        [self.contentView addSubview:self.title];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.title.textColor=[UIColor whiteColor];
    }
    return self;
}

-(void)setIcon:(UIImage *)image Title:(NSString *)title{
    self.imageV.image=image;
    self.title.text=title;
    self.imageV.center=CGPointMake(self.contentView.center.x-25, self.contentView.center.y);
    self.title.center=CGPointMake(self.contentView.center.x+35, self.contentView.center.y);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
