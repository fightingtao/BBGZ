//
//  UserInfoSaveModel.m
//  Shipper
//
//  Created by xc on 15/9/12.
//  Copyright (c) 2015年 xc. All rights reserved.
//

#import "UserInfoSaveModel.h"

@implementation UserInfoSaveModel
@synthesize user_status	;//int	用户状态 1启用 0禁用
@synthesize gender;//	int	性别 0女 1男
@synthesize level	;//int	用户等级
@synthesize pay_amount;//	double	已交押金金额
@synthesize telephone	;//string	手机号码
@synthesize authen_status	;//int	认证状态 0申请中 1审核通过 2审核失败
@synthesize primary_key	;//string	加密秘钥
@synthesize point	;//int	用户积分
@synthesize realname;//	string	用户真实姓名
@synthesize city_name;//	string	城市名
@synthesize pay_status;//	int	押金交付状态 0未交 1已交
@synthesize user_type	;//int	用户类型 0达人 5个人商家  1 企业商家
@synthesize notify_switch	;//string	推送开关通知
@synthesize nickname;//	string	昵称
@synthesize header	;//string	头像地址
@synthesize tag;//	string	极光推送标签
@synthesize key	;//string	用户id
@synthesize opposite_idcard;//string	身份证反面照
@synthesize positive_idcard;//	string	身份证正面照
@synthesize hand_idcard	;//string	身份证手持照
@synthesize idcard_no;//身份证号
@synthesize hotline;//热线电话
- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        self.user_status = [coder decodeObjectForKey:@"user_status"];
        self.tag = [coder decodeObjectForKey:@"tag"] ;
        self.level = [coder decodeObjectForKey:@"level"];
        self.pay_amount = [coder decodeObjectForKey:@"pay_amount"] ;
        self.gender = [coder decodeObjectForKey:@"gender"];
        self.telephone = [coder decodeObjectForKey:@"telephone"];
        self.authen_status = [coder decodeObjectForKey:@"authen_status"];
        self.key = [coder decodeObjectForKey:@"key"];
        self.primary_key = [coder decodeObjectForKey:@"primary_key"];
      
        self.point = [coder decodeObjectForKey:@"point"];
        self.realname = [coder decodeObjectForKey:@"realname"];
        self.city_name = [coder decodeObjectForKey:@"city_name"] ;
        self.pay_status = [coder decodeObjectForKey:@"pay_status"] ;
        self.user_type = [coder decodeObjectForKey:@"user_type"];
        self.notify_switch = [coder decodeObjectForKey:@"notify_switch"] ;
        self.nickname = [coder decodeObjectForKey:@"nickname"];
        self.header = [coder decodeObjectForKey:@"header"];
      self.hand_idcard = [coder decodeObjectForKey:@"hand_idcard"];
        self.positive_idcard = [coder decodeObjectForKey:@"positive_idcard"];
        self.opposite_idcard = [coder decodeObjectForKey:@"opposite_idcard"];
        self.idcard_no=[coder decodeObjectForKey:@"idcard_no"];
        self.hotline=[coder decodeObjectForKey:@"hotline"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.user_status forKey:@"user_status"];
    [coder encodeObject:self.gender forKey:@"gender"];
    [coder encodeObject:self.level forKey:@"level"];
    [coder encodeObject:self.pay_amount forKey:@"pay_amount"];
    [coder encodeObject:self.telephone forKey:@"telephone"];
    [coder encodeObject:self.authen_status forKey:@"authen_status"];
    [coder encodeObject:self.primary_key forKey:@"primary_key"];
    [coder encodeObject:self.point forKey:@"point"];
    [coder encodeObject:self.realname forKey:@"realname"];
    [coder encodeObject:self.city_name forKey:@"city_name"];
    
    [coder encodeObject:self.pay_status forKey:@"pay_status"];
    [coder encodeObject:self.user_type forKey:@"user_type"];
    
    [coder encodeObject:self.notify_switch forKey:@"notify_switch"];
    [coder encodeObject:self.nickname forKey:@"nickname"];

    [coder encodeObject:self.header forKey:@"header"];
    [coder encodeObject:self.tag forKey:@"tag"];
    [coder encodeObject:self.key forKey:@"key"];
    [coder encodeObject:self.hand_idcard forKey:@"hand_idcard"];
    [coder encodeObject:self.positive_idcard forKey:@"positive_idcard"];
    [coder encodeObject:self.opposite_idcard forKey:@"opposite_idcard"];
    [coder encodeObject:self.idcard_no forKey:@"idcard_no"];
    [coder encodeObject:self.hotline forKey:@"hotline"];
}


@end
