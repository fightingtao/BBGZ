//
//  orderTableView.m
//  BBShangJia
//
//  Created by 李志明 on 17/3/27.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "orderTableView.h"
#import "PublicSouurce.h"
#import "DetialTableViewCell.h"
#define DetialTableCellID @"DetialTable"
@interface orderTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation UIView (category)


- (void)borderColor:(UIColor *)borderColor borderWidth:(float)borderWidth cornerRadius:(float)cornerRadius{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}
@end

@implementation orderTableView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
 
    }
    return self;
    
}

-(UITableView*)tableView{
    return HT_LAZY(_tableView, ({
        UITableView *tab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        tab.delegate = self;
        tab.dataSource = self;
        tab.backgroundColor=backGroud;

        tab.separatorStyle = UITableViewCellSeparatorStyleNone;
        tab;
    }));
}

-(NSMutableDictionary*)dataList{
    return HT_LAZY(_dataList, ({
        NSMutableDictionary * array = [[NSMutableDictionary alloc] init];
        array;
    }));
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0.01;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Out_orderDetialModel *model = [[Out_orderDetialModel alloc] initWithDictionary:self.dataList error:nil];
  
    if ([model.order_status isEqualToString:@"1"]) {
        return 1;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Out_orderDetialModel *model = [[Out_orderDetialModel alloc] initWithDictionary:self.dataList error:nil];
   
    if ([model.order_status isEqualToString:@"1"]) {
        NSString *sending=[NSString stringWithFormat:@"达人:%@ %@ 正在配送",model.broker_username,model.broker_mobile];
        return [DetialTableViewCell cellHeightWithString:sending];
        
    }else if([model.order_status isEqualToString:@"2"]){
        if (indexPath.row == 0) {
            NSString *sign;
            if ([model.sign_type containsString:@"1"]) {
                sign=@"订单状态: 本人签收";
            }
            else{
                sign=[NSString stringWithFormat:@"订单状态: %@ 签收",model.sign_man];
            }
           return [DetialTableViewCell cellHeightWithString:sign];
        }else{
            NSString *sending=[NSString stringWithFormat:@"达人:%@ %@ 正在配送",model.broker_username,model.broker_mobile];
           
            return [DetialTableViewCell cellHeightWithString:sending];
        }
        
    }else if([model.order_status isEqualToString:@"3"]){
        if (indexPath.row == 0) {

                NSString *stringTmp=[model.next_delivery_time substringWithRange:NSMakeRange(0, 10)];
                NSString *failure=[NSString stringWithFormat:@"异常说明: %@，请于%@重新配送\n此订单费用将于今晚24:00前返回您的账户",model.expt_msg,stringTmp];
                CGFloat height = [DetialTableViewCell cellHeightWithString:failure];
                // 1.文字的最大尺寸
                CGSize maxSize = CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT);
                // 2.计算文字的高度
                CGFloat textH = [@"此订单费用将于今晚24:00前返回您的账户" boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.height;
                return height+textH;
        }
      else{
            NSString *sending=[NSString stringWithFormat:@"达人:%@ %@ 正在配送",model.broker_username,model.broker_mobile];
           ;
            return [DetialTableViewCell cellHeightWithString:sending];
        }
      
    }else{
        if (indexPath.row == 0) {
             NSString *failure=[NSString stringWithFormat:@"此订单费用将于今晚24:00前返回您的账户" ];
            return [DetialTableViewCell cellHeightWithString:failure];
        }else{
            NSString *sending=[NSString stringWithFormat:@"达人:%@ %@ 正在配送",model.broker_username,model.broker_mobile];
            return [DetialTableViewCell cellHeightWithString:sending];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    DetialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetialTableCellID];
    Out_orderDetialModel *model = [[Out_orderDetialModel alloc] initWithDictionary:self.dataList error:nil];
    
    if (!cell) {
        cell = [[DetialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetialTableCellID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    BOOL isFirst;
    BOOL isLast;
    if ([model.order_status isEqualToString:@"1"]){//配送中
        isFirst = 1 ;
        isLast  =1;
        NSString *sending=[NSString stringWithFormat:@"达人:%@ %@ 正在配送",model.broker_username,model.broker_mobile];
        [ cell  setDataSource:sending  date:model.linghuo_time   isFirst:(BOOL)isFirst isLast:isLast];
   
    }else if([model.order_status isEqualToString:@"2"]){//已完成
        if (indexPath.row == 0) {
            bool isFirst =  1;
            bool isLast =  0;
            NSString *sign;
            if ([model.sign_type containsString:@"1"]) {
                sign=@"订单状态: 本人签收";
            }else{
                sign=[NSString stringWithFormat:@"订单状态: %@ 签收",model.sign_man];
            }
        [cell setDataSource:sign date:model.sign_time    isFirst:(BOOL)isFirst isLast:isLast];
            NSMutableAttributedString *string2=[[NSMutableAttributedString alloc]initWithString:sign];
            [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
           cell.showLabel.attributedText = string2;
            
        }else{
            bool isFirst =  0;
            bool isLast =  1;
            NSString *sending=[NSString stringWithFormat:@"达人:%@ %@ 正在配送",model.broker_username,model.broker_mobile];
           [ cell  setDataSource:sending date:model.linghuo_time  isFirst:(BOOL)isFirst isLast:isLast];
        }
        
    }else if([model.order_status isEqualToString:@"3"]){//配送滞留
        if (indexPath.row == 0) {
            bool isFirst = 1;
            bool isLast  =  0;
            [ cell  setExptDataSource:model.expt_msg date:model.sign_time nextTime:model.next_delivery_time  isFirst:(BOOL)isFirst isLast:isLast];
           
        }else{
            bool isFirst = indexPath.row == 0;
            bool isLast = indexPath.row == 1;
            NSString *sending=[NSString stringWithFormat:@"达人:%@ %@ 正在配送",model.broker_username,model.broker_mobile];
            
            [ cell setDataSource:sending date:model.linghuo_time    isFirst:(BOOL)isFirst isLast:isLast];
        }
    }else if([model.order_status isEqualToString:@"4"]){//拒收
        if (indexPath.row == 0) {
            bool isFirst  = 1;
            bool isLast   = 0;
            NSString *failure=[NSString stringWithFormat:@"%@",model.expt_msg ];
            [cell setExptDataSource:failure date:model.sign_time  nextTime:@"" isFirst:isFirst isLast:isLast];
        }else{
            bool isFirst =  0;
            bool isLast  =  1;
            NSString *sending=[NSString stringWithFormat:@"达人:%@ %@ 正在配送",model.broker_username,model.broker_mobile];
            [ cell  setDataSource:sending date:model.linghuo_time isFirst:(BOOL)isFirst isLast:isLast];
        }
    }
    return cell;
}

@end
