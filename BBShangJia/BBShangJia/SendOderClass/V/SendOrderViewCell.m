//
//  SendOrderViewCell.m
//  BBShangJia
//
//  Created by cbwl on 16/9/26.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "SendOrderViewCell.h"

@implementation SendOrderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.price.delegate=self;
}
//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    textField.textColor=kTextRedCOLOR;
//    self.price.textColor=kTextRedCOLOR;
//
//}
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    textField.textColor=kTextRedCOLOR;
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resultWithText:(NSString*)text{
    self.distrLabel.text = text;
    // 1.文字的最大尺寸
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT);
    // 计算文字的高度
    CGFloat textH = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    self.distrLabel.frame = CGRectMake(self.fanwei.x+110, 15, 160, textH);
    [self.distrLabel sizeToFit];
    self.distrLabel.textColor=[UIColor blackColor];
    self.lineView.frame = CGRectMake(0, self.distrLabel.y+self.distrLabel.height+5, SCREEN_WIDTH, 1);
    self.cellHeight1 = self.distrLabel.height+40;
}

@end
