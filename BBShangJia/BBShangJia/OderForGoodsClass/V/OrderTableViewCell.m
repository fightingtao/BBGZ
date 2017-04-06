//
//  OrderTableViewCell.m
//  BBShangJia
//
//  Created by cbwl on 16/9/26.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}


-(void)setModel:(Out_sendGoodsBody *)model{

    self.timeLabel2.text=model.time;
    self.distruLabel2.text=model.username;
    self.orderNumLabel2.text=model.order_original_id;
    self.distruLabel2.text=model.grid_name;
    self.priceLabel2.text=[NSString stringWithFormat:@"%.2f元",[model.per_oder_commission floatValue]];
    self.markiLabel2.text=model.username;
    self.telBtn2.tag=[model.mobile longLongValue];

    for (UIView *view in self.startView.subviews) {
        if ([view isKindOfClass:[self.startView class]]) {
            [view removeFromSuperview];
        }
    }
    self.star = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0,80,25) numberOfStars:5];
    [self.startView addSubview:self.star];
    ;
    
    NSString *str = [self decimalwithFormat:@"0.0" floatV:[model.avgevaluate_level floatValue]];
    NSString *str1 = [str substringFromIndex:2];
    float numberToRound;
    float result;
    if ([str1 intValue] == 5) {
        self.star.scorePercent =[str floatValue] *0.2;
        
    }else if([str1 intValue] > 5 ){
        NSString *str2 = [str substringToIndex:1];
        float a = [str2 floatValue] + 0.5;
 self.star.scorePercent =  a*0.2;
    }else{
        numberToRound = [str floatValue];
        result = roundf(numberToRound);
         self.star.scorePercent = result *0.2;
    }
    self.startLabel.text =  [self decimalwithFormat:@"0.0" floatV:[model.avgevaluate_level floatValue]];
}

- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}



-(void)setCell2Model:(Out_sendGoodsBody *)model{
    self.timeLabel2.text=model.time;
    self.distruLabel2.text=model.username;
    self.orderNumLabel2.text=model.order_original_id;
    self.distruLabel2.text=model.grid_name;
    self.priceLabel2.text=[NSString stringWithFormat:@"%.2f元",[model.per_oder_commission floatValue]];
    self.markiLabel2.text=model.username;
    self.telBtn2.tag=[model.mobile longLongValue];
}

-(void)setCell3Model:(Out_sendGoodsBody *)model;//已完成
{
    self.timeLabel3.text=model.time;
    self.distruLabel3.text=model.username;
    self.orderNumLabel3.text=model.order_original_id;
    self.distruLabel3.text=model.grid_name;
    self.priceLabel3.text=[NSString stringWithFormat:@"%.2f元",[model.per_oder_commission floatValue]];
    self.markiLabel3.text=model.username;
    self.telBtn3.tag=[model.mobile longLongValue];

    if ([model.order_status isEqualToString:@"3"] ||[model.order_status isEqualToString:@"6"] ||[model.order_status isEqualToString:@"7"] ||[model.order_status isEqualToString:@"9"]){
        self.signLabel.hidden=YES;
        NSString * responseString = [model.expt_msg stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        self.problemDeLabel.text=responseString;
    }
    else if ([model.order_status isEqualToString:@"2"]){
        self.problemLabel.hidden=YES;
        self.problemDeLabel.hidden=YES;
    }
}
- (IBAction)onSendingTelClick:(UIButton *)sender {
        [self.delegate callTelePhone:[NSString stringWithFormat:@"%ld",(long)sender.tag]];

}
- (IBAction)onCompletTelClick:(UIButton *)sender {
    [self.delegate callTelePhone:[NSString stringWithFormat:@"%ld",(long)sender.tag]];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
