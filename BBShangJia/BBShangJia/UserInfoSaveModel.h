//
//  UserInfoSaveModel.h
//  Shipper
//
//  Created by xc on 15/9/12.
//  Copyright (c) 2015年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>
#define UserKey  @"UserInfoMsg"


/**
 *  登录后，序列化一些身份相关信息
 user_status	int	用户状态 1启用 0禁用
 gender	int	性别 0女 1男
 level	int	用户等级
 pay_amount	double	已交押金金额
 telephone	string	手机号码
 authen_status	int	认证状态 0申请中 1审核通过 2审核失败
 primary_key	string	加密秘钥
 point	int	用户积分
 realname	string	用户真实姓名
 city_name	string	城市名
 pay_status	int	押金交付状态 0未交 1已交
 user_type	int	用户类型 0达人 5个人商家
 notify_switch	string	推送开关通知
 nickname	string	昵称
 header	string	头像地址
 tag	string	极光推送标签
 key	string	用户id
 */
@interface UserInfoSaveModel : NSObject<NSCoding>

@property (copy ,nonatomic)NSString * user_status ;//	int	用户状态 1启用 0禁用
@property (copy ,nonatomic)NSString *gender	;//int	性别 0女 1男
@property (copy ,nonatomic)NSString *level;//	int	用户等级
@property (copy ,nonatomic)NSString *pay_amount;//	double	已交押金金额
@property (copy ,nonatomic)NSString *telephone	;//string	手机号码
@property (copy ,nonatomic)NSString *authen_status;//	int	认证状态 0申请中 1审核通过 2审核失败
@property (copy ,nonatomic)NSString *primary_key	;//string	加密秘钥
@property (copy ,nonatomic)NSString *point;//	int	用户积分
@property (copy ,nonatomic)NSString *realname;//	string	用户真实姓名
@property (copy ,nonatomic)NSString *city_name	;//string	城市名
@property (copy ,nonatomic)NSString *pay_status	;//int	押金交付状态 0未交 1已交
@property (copy ,nonatomic)NSString *user_type	;//int	用户类型 0达人 5个人商家 1 企业商家
@property (copy ,nonatomic)NSString *notify_switch;//	string	推送开关通知
@property (copy ,nonatomic)NSString *nickname	;//string	昵称
@property (copy ,nonatomic)NSString *header;//	string	头像地址
@property (copy ,nonatomic)NSString *tag	;//string	极光推送标签
@property (copy ,nonatomic)NSString *key;//	string	用户id
@property (nonatomic, strong) NSString *opposite_idcard;//	string	身份证反面照
@property (nonatomic, strong) NSString * positive_idcard;//	string	身份证正面照
@property (nonatomic, strong) NSString * hand_idcard	;//string	身份证手持照
@property (nonatomic, strong) NSString *idcard_no;//身份证号
@property (nonatomic, strong) NSString *hotline;//热线电话
@end
