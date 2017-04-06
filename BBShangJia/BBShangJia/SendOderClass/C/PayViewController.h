//
//  PayViewController.h
//  BBShangJia
//
//  Created by cbwl on 16/9/24.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicSouurce.h"
#import "PayViewCell.h"
#import "PayFinishViewController.h"
#import <AlipaySDK/AlipaySDK.h>

#import "Order.h"
#import "MD5DataSigner.h"
@interface PayViewController : UIViewController
@property (nonatomic,assign) float money;//订单单价
@property (nonatomic,assign) int numble;//订单数量
@property (nonatomic,copy)NSString *requirment_id;//	long	需求id trade_type 为6时必选
@property (nonatomic,copy)NSString *orders;
@property (nonatomic,copy) NSString * requirment_name;//网格名字
@property (nonatomic,copy) NSString *  requirment_type;//1.网点发单  2.网格发单
@property (nonatomic,copy) NSString *  gridId;//网格Id
@property (nonatomic,strong) in_senderOrderModel *InModel;
@property (nonatomic,assign) int kind;//1.发单界面  2记录界面
@property (nonatomic,copy) NSString *  publish_time;//发单时间呢
-(void)afterAlipayCreateOrderWithOrderId:(NSString *)order ;
-(void)leftItemClick;
-(void)payBtnClick;//去支付
@end
