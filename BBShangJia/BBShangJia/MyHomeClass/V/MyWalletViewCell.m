//
//  MyWalletViewCell.m
//  BBShangJia
//
//  Created by cbwl on 16/9/27.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "MyWalletViewCell.h"

@implementation MyWalletViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(NSDictionary *)dic;
{
    self.canUseLabel.text=[NSString stringWithFormat:@"¥%.2f",[dic[@"balance"] floatValue]];
    self.consumeLabel.text=[NSString stringWithFormat:@"¥%.2f",[dic[@"current_month_consumed"] floatValue]];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
