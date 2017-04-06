//
//  historyAndMoneyTableViewCell.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/19.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "historyAndMoneyTableViewCell.h"

@implementation historyAndMoneyTableViewCell
//历史订单
+ (instancetype)historyTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(NSDictionary *)dic;
{
    NSString *identifier = @"history";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell

    
       historyAndMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"historyAndMoneyTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}
//
-(void)historySetModel:(Out_historyOrderBody *)model;
{
    DLog(@"收入%@",[NSString stringWithFormat:@"%@",model.status]);
    self.name.text=[NSString stringWithFormat:@"%@元",model.broker_username];
    self.orderId.text=model.order_id;
   
    if ([model.status isEqualToString:@"2"]) {//2配送成功 3 异常
        self.status.text = @"已完成";
        self.status.textColor=MainColor;

        self.name.text=[NSString stringWithFormat:@"配送人:%@",model.broker_username];
        
    }else {//if([model.status isEqualToString:@"9"])
        self.status.text = @"配送异常";
        self.status.textColor=[UIColor redColor];
        self.name.text=@"达人释放";

    }
//    else {
//        self.name.text=@"异常";
//
//    }
}
//
////账单
//+ (instancetype)billTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(NSDictionary *)dic;
//{
//    NSString *identifier = @"bill";//对应xib中设置的identifier
//    NSInteger index = 1; //xib中第几个Cell
//    
//    
//    historyAndMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"historyAndMoneyTableViewCell" owner:self options:nil] objectAtIndex:index];
//    }
//    
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    return cell;
//    
//
//}
//
-(void)billSetModel:(Out_billStreamBody *)model;
{
    self.year.text=[model.trade_time substringWithRange:NSMakeRange(0, 10)];
    
    self.hour.text=[model.trade_time substringWithRange:NSMakeRange(11, 5)];
  
    self.billMoney.text=[NSString stringWithFormat:@"%.2f元",[model.trade_amount floatValue]];
    
    self.billStatus.text = model.trade_desc;

}



@end
