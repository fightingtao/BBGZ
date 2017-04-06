//
//  BillRecordViewCell.m
//  BBShangJia
//
//  Created by 李志明 on 16/9/27.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "BillRecordViewCell.h"

@implementation BillRecordViewCell

-(void)setCellModel:(Out_billRecordBody *)model{
   
//    if (![model.status isEqualToString:@"4"]){
        self.time.text=model.publish_time;
        self.addressLabel1.text=model.grid_name;
        self.orderNumLabel1.text=[NSString stringWithFormat:@"%@单",model.order_amount];
        self.moneyLabel1.text=[NSString stringWithFormat:@"%.2f元",[model.price floatValue]];
        if ([model.requirment_type isEqualToString:@"0"])
        {
            self.formLabel1.text=@"需求发单";
            
        }
        else if([model.requirment_type isEqualToString:@"1"])
        {
            self.formLabel1.text=@"网点发单";
            
        }
        else if([model.requirment_type isEqualToString:@"2"])
        {
            self.formLabel1.text=@"网格发单";
        }
        //status	int	"需求状态 0发布中 1已完结 2拦截
        //    3.已发送 4.未支付"
        if ([model.status isEqualToString:@"0"]){
            self.statusLabel.text=@"发布中";
        }else  if ([model.status isEqualToString:@"1"]){
            self.statusLabel.text=@"配送中";
            self.statusLabel.textColor = [UIColor colorWithRed:0/255.0 green:170/255.0 blue:40/255.0 alpha:1.0];
        }else  if ([model.status isEqualToString:@"2"]){
            self.statusLabel.text=@"已完结";
        }else  if ([model.status isEqualToString:@"3"]){
            self.statusLabel.text=@"待接单";
        }else  if ([model.status isEqualToString:@"4"]){
            self.statusLabel.text=@"未支付";
        }else  if ([model.status isEqualToString:@"5"]){
            self.statusLabel.text=@"超时未付款,订单已关闭";
            self.statusLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];

        }else  if ([model.status isEqualToString:@"6"]){
            self.statusLabel.text=@"已完成";
            self.statusLabel.textColor=[UIColor greenColor];
        }else if([model.status isEqualToString:@"7"]){
            self.statusLabel.text=@"已取消";
        }
//    }
}

-(void)setNoPayCellModel:(Out_billRecordBody *)model index:(int)section date:(NSDate *)date;
{
   
    if ([model.status isEqualToString:@"4"]){
        self.time2.text=model.publish_time;

        self.addressLabel2.text=model.grid_name;
        self.orderNumLabel2.text=[NSString stringWithFormat:@"%@单",model.order_amount];
        self.mondeyLabel2.text=[NSString stringWithFormat:@"%.2f元",[model.price floatValue]];
        if ([model.requirment_type isEqualToString:@"0"])
        {
            self.formLabel2.text=@"需求发单";
            
        }
        else if([model.requirment_type isEqualToString:@"1"])
        {
            self.formLabel2.text=@"网点发单";
        }
        else if([model.requirment_type isEqualToString:@"2"])
        {
            self.formLabel2.text=@"网格发单";
            
        }
        self.payBtn.tag=section;
        self.cancellBtn.hidden = YES;
        self.payBtn.hidden = NO;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *date1= [dateFormatter dateFromString:model.publish_time];
        int time=(int)[date timeIntervalSinceDate:date1]; //登录的时间查
        
        int time1=15*60-(time+8*60*60);
        
        if (time1>0){
            [self startCodeTime:time1];

            [self.payBtn setBackgroundColor:MainColor];
            
        }else{
            self.statusLabel2.text=[NSString stringWithFormat:@"支付超时,订单已关闭"];
            self.payBtn.enabled=NO;
           self.statusLabel2.textColor = [UIColor grayColor];
            [self.payBtn setBackgroundColor:[UIColor grayColor]];
        }
    }else if([model.status isEqualToString:@"3"]){
        self.time2.text=model.publish_time;
        
        self.addressLabel2.text=model.grid_name;
        self.orderNumLabel2.text=[NSString stringWithFormat:@"%@单",model.order_amount];
        self.mondeyLabel2.text=[NSString stringWithFormat:@"%.2f元",[model.price floatValue]];
        if ([model.requirment_type isEqualToString:@"0"])
        {
            self.formLabel2.text=@"需求发单";
            
        }
        else if([model.requirment_type isEqualToString:@"1"])
        {
            self.formLabel2.text=@"网点发单";
        }
        else if([model.requirment_type isEqualToString:@"2"])
        {
            self.formLabel2.text=@"网格发单";
        }
        self.statusLabel2.text = @"待接单";
        self.payBtn.hidden = YES;
        self.cancellBtn.hidden = NO;
        self.statusLabel2.textColor = [UIColor blackColor];
        [[self.cancellBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"是否确认取消订单？" message:nil cancelBtnTitle:@"否" otherBtnTitle:@"是" clickIndexBlock:^(NSInteger clickIndex) {
                if (clickIndex == 200) {
                         [self.subject sendNext:model.requirment_id];
                }
            }];
            [alert showLXAlertView];
        }];
    }
}

//倒计时
- (void)startCodeTime:(int)time
{
    __block int timeout=time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.statusLabel2.text=[NSString stringWithFormat:@"支付超时,订单已关闭"];
                self.statusLabel2.textColor = [UIColor grayColor];
                [self.payBtn setEnabled:NO];
                [self.upSubject sendNext:@1];

            });
        }else{
            int minutes = timeout / 60;
            int seconds = timeout%60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.statusLabel2.text=[NSString stringWithFormat:@"请在%d分%@秒内支付",minutes,strTime];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)noPayClick:(UIButton *)sender {
    [self.delegate billRecordGoAlipyClick:sender];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
