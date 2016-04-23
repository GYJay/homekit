//
//  TriggerCell.m
//  homedp
//
//  Created by GYJ on 16/4/18.
//  Copyright © 2016年 GYJ. All rights reserved.
//

#import "TriggerCell.h"

@interface TriggerCell ()
@end

@implementation TriggerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.s=[[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-90, 5, 60, 30)];
        [self.contentView addSubview:self.s];
    }
    return self;
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
