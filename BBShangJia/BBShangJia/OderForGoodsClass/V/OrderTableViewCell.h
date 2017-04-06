//
//  OrderTableViewCell.h
//  BBShangJia
//
//  Created by cbwl on 16/9/26.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicSouurce.h"
#import "CWStarRateView.h"
@protocol telePhoneBtnClickDelegate  <NSObject>
-(void)callTelePhone:(NSString *)phone;
@end
@interface OrderTableViewCell : UITableViewCell
@property (nonatomic,strong) id <telePhoneBtnClickDelegate>delegate;
//cell1
@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel1;

@property (weak, nonatomic) IBOutlet UILabel *distruLabel1;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel1;

//cell2
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel2;
@property (weak, nonatomic) IBOutlet UILabel *distruLabel2;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel2;
@property (weak, nonatomic) IBOutlet UILabel *markiLabel2;

@property (weak, nonatomic) IBOutlet UIButton *telBtn2;
@property(nonatomic,strong)CWStarRateView *star;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;



//cell3

@property (weak, nonatomic) IBOutlet UILabel *timeLabel3;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel3;
@property (weak, nonatomic) IBOutlet UILabel *distruLabel3;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel3;
@property (weak, nonatomic) IBOutlet UILabel *markiLabel3;

@property (weak, nonatomic) IBOutlet UIButton *telBtn3;
@property (weak, nonatomic) IBOutlet UILabel *problemLabel;

@property (weak, nonatomic) IBOutlet UILabel *problemDeLabel;

@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIView *startView;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;

-(void)setModel:(Out_sendGoodsBody *)model;///待接单
-(void)setCell2Model:(Out_sendGoodsBody *)model;//配送中
-(void)setCell3Model:(Out_sendGoodsBody *)model;//已完成

@end
