//
//  communcat.h
//  BBShangJia
//
//  Created by cbwl on 16/9/27.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoSaveModel.h"
#import <UIKit/UIKit.h>
#import "NetModel.h"
#import <CommonCrypto/CommonHMAC.h>
#import "AFHTTPSessionManager.h"

@interface communcat : NSObject
@property (nonatomic,strong)   AFHTTPSessionManager *manager;
+ (id)sharedInstance;
//////////////////////////////////////////////////////////
///颜色创建图片
- (UIImage *) createImageWithColor: (UIColor *) color;
///加密
-(NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;
///检查手机号
- (BOOL)checkTel:(NSString *)str;
///排序和加密
- (NSString*)ArrayCompareAndHMac:(NSArray*)array;
///md5加密
//- (NSString *) getmd5:(NSString *)str;
#pragma mark 倒计时
-(void)startCodeTimeWithTime:(int)time during:(void(^)(int timeDuring))timeDuring outTime:(void(^)(int outTime))outTime;
#pragma 正则匹配用户身份证号15或18位
- (BOOL)checkUserIdCard: (NSString *) idCard;
#pragma mark  快捷登录验证码发送
-(void)sendCodeWithPhone:(NSString *)phone resultDic:(void(^)(NSDictionary *dic))dic;
#pragma mark   登录
-(void)LoginbtnClickWithMsg:(In_LoginModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark  个人信息首页
-(void)getPersonerMsgWithkey:(NSString *)key degist:(NSString *)degist  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark   修改达人认证
-(void)changeApproveMsgWithModel:(approve_InModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark   达人认证
-(void)getApproveMsgWithModel:(approve_InModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark  获取网格站点信息
-(void)getZhanDianWithMsg:(getZhanDianMsg_inModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark  获取网格站点金额
-(void)getZhanDianMoneyWithKey:(NSString *)key digest :(NSString *)digest  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark 退出登录
-(void)loginOutClickWithKey:(NSString *)key digest:(NSString *)digest resultDic:(void(^)(NSDictionary *dic))dic;
#pragma mark  提交订单
-(void)senderOrdersWithModel:(in_senderOrderModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark  生成支付订单
-(void)createOrderAlipayWithModel:(In_OrderPayModel *)InModel  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark  查询支付结果
-(void)checkOrderAfterAlipayWithModel:(In_afterPayModel *)InModel  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark 获取余额多少
-(void)getYuEMoneyWithKey:(NSString *)key digest:(NSString *)digest resultDic:(void(^)(NSDictionary *dic))dic;
#pragma mark ---------送货列表－－－－－－－－－－－－－－－－
-(void)sendGoodsListWithMsg:(In_sendGoodsModel *)sendGoodsModel  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark ---------FADIANFADAN发单列表－－－－－－－－－－－－－－
-(void)getBillRecordListWithMsg:(In_sendGoodsModel *)sendGoodsModel date:(void (^)(NSDate *outDate))outDate resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark  获取钱包金额
-(void)getMyMoneyWithKey:(NSString *)key digest :(NSString *)digest  userType:(NSString *)usertype resultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark ---------zhangdna 账单列表－－－－－－－－－－－－－－－－
-(void)getBillListWithMsg:(In_sendGoodsModel *)sendGoodsModel  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark--------------历史订单----------------------------
-(void)getHistoryOrderlInforWithMsg:(In_historyOrderModel *)historyOrderModel  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark  修改绑定手机号

-(void)changePersonerPhoneWith:(In_changePhoneModel *)Model  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark  修改绑定手机号 验证码
-(void)changePersonerPhoneMsgWithkey:(NSString *)key degist:(NSString *)degist phone:(NSString *)phone resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark 开放城市
-(void)getCityWithKey:(NSString *)key digest:(NSString *)digest resultDic:(void(^)(NSDictionary *dic))dic;

#pragma mark---------------意见反馈---------------------
-(void)feedBackClickWithModel:(In_opinionBackModel *)InModel  resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark   获取版本更新信息
-(void)getVerisonFromAppStoreWithResultDic:(void (^)(NSDictionary *dic))dic;

#pragma mark----------------更新登录信息
-(void)upDataUserMsgWithkey:(NSString *)key degist:(NSString *)degist resultDic:(void (^)(NSDictionary *dic))dic;
#pragma mark  取消订单
-(void)cancelOrderAlipayWithModel:(In_afterPayModel *)InModel  resultDic:(void (^)(NSDictionary *dic))dic;

@end
