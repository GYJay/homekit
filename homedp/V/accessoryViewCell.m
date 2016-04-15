//
//  accessoryViewCell.m
//  homedp
//
//  Created by GYJ on 16/4/10.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "accessoryViewCell.h"

@interface accessoryViewCell ()
@property(nonatomic)UILabel *acName;
@property(nonatomic)UILabel *available;
@end

@implementation accessoryViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.acName=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        self.available=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
//        self.acName.textColor=[UIColor whiteColor];
//        self.available.textColor=[UIColor whiteColor];
        [self.contentView addSubview:self.acName];
        [self.contentView addSubview:self.available];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}


-(void)setAcName:(NSString *)name available:(NSString *)available{
    self.acName.center=CGPointMake(70, self.contentView.center.y);
    self.available.center=CGPointMake(self.contentView.center.x+20, self.contentView.center.y);
    self.acName.text=name;
    self.available.text=available;
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
