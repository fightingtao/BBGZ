//
//  PayViewCell.m
//  BBShangJia
//
//  Created by cbwl on 16/9/24.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "PayViewCell.h"
#import "PublicSouurce.h"
@implementation PayViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.yuerBtn.selected = NO;
    self.zhifubaoBtn.selected = YES;
    [self.editorBtn addTarget:self action:@selector(editorBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.yuerBtn addTarget:self action:@selector(yuerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.zhifubaoBtn addTarget:self action:@selector(zhifubaoClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)editorBtnClick{
    if ([self.delegate respondsToSelector:@selector(editorBtnSelect)]) {
        [self.delegate editorBtnSelect];
    }
}

- (IBAction)yuE:(id)sender {
    [self yuerBtnClick];

}

-(void)yuerBtnClick{
   
    self.yuerBtn.selected = !self.yuerBtn.selected;

}
- (IBAction)Alipay:(id)sender {
    [self zhifubaoClick];
}

-(void)zhifubaoClick{

    self.zhifubaoBtn.selected = !self.zhifubaoBtn.selected;
   
}

-(void)requirment_nameText:(NSString*)text{
    self.requirment_name.text = text;
    // 1.文字的最大尺寸
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-150, MAXFLOAT);
    // 计算文字的高度
    CGFloat textH = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    self.requirment_name.frame = CGRectMake(self.requirment_name.x, 15, 160, textH+80);
    [self.requirment_name sizeToFit];
    self.requirment_name.textColor=[UIColor blackColor];
    self.line1.frame = CGRectMake(0, self.requirment_name.y+textH+50, SCREEN_WIDTH, 1);
    self.cellHeight1 = self.requirment_name.height+180;
}

@end
