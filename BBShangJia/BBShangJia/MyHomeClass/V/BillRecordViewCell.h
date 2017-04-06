//
//  BillRecordViewCell.h
//  BBShangJia
//
//  Created by 李志明 on 16/9/27.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicSouurce.h"
@protocol  billRecrdViewDelegate  <NSObject>
-(void)billRecordGoAlipyClick:(UIButton *)btn;

@end

@interface BillRecordViewCell : UITableViewCell
@property(nonatomic,strong) id <billRecrdViewDelegate> delegate;

//cell1
@property (weak, nonatomic) IBOutlet UILabel *addressLabel1;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel1;
@property (weak, nonatomic) IBOutlet UILabel *formLabel1;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel1;

//cell2
@property (weak, nonatomic) IBOutlet UILabel *addressLabel2;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel2;
@property (weak, nonatomic) IBOutlet UILabel *formLabel2;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel2;
@property (weak, nonatomic) IBOutlet UILabel *mondeyLabel2;

@property (weak, nonatomic) IBOutlet UILabel *time2;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancellBtn;
@property(nonatomic,strong)RACSubject *subject;

@property(nonatomic,strong)RACSubject *upSubject;

-(void)setNoPayCellModel:(Out_billRecordBody *)model index:(int)section date:(NSDate *)date;
-(void)setCellModel:(Out_billRecordBody *)model;
@end
