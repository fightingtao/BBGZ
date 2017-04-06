//
//  NetModel.h
//  CYZhongBao
//
//  Created by xc on 15/12/2.
//  Copyright © 2015年 xc. All rights reserved.
//

#import "JSONModel.h"

@interface NetModel : JSONModel

@end

///通用返回model
@interface Out_AllSameModel : JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*message;
@property (nonatomic, strong) NSString <Optional>*data;

@end

//-------------------------------------------------------------




///获取登录验证码Model
@interface In_LoginCodeModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*telephone;

@end

@interface Out_LoginCodeModel : JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*message;
@property (nonatomic, strong) NSString <Optional>*data;

@end
//-------------------------------------------------------------


///用户登录Model
@interface In_LoginModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*telephone;
@property (nonatomic, strong) NSString <Optional>*code;
@property (nonatomic, strong) NSString <Optional>*userType;

@end

@protocol OutLoginBody <NSObject>
@end

@interface OutLoginBody : JSONModel
/*
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
@property (nonatomic, strong) NSString <Optional>*user_status	;//int	用户状态 1启用 0禁用
@property (nonatomic, strong) NSString <Optional>*gender;//	int	性别 0女 1男
@property (nonatomic, strong) NSString <Optional>*level	;//int	用户等级
@property (nonatomic, strong) NSString <Optional>*pay_amount;//	double	已交押金金额
@property (nonatomic, strong) NSString <Optional>*telephone	;//string	手机号码
@property (nonatomic, strong) NSString <Optional>*authen_status	;//int	认证状态 0申请中 1审核通过 2审核失败
@property (nonatomic, strong) NSString <Optional>*primary_key	;//string	加密秘钥
@property (nonatomic, strong) NSString <Optional>*point;//	int	用户积分
@property (nonatomic, strong) NSString <Optional>*realname;//	string	用户真实姓名
@property (nonatomic, strong) NSString <Optional>*city_name	;//string	城市名
@property (nonatomic, strong) NSString <Optional>*pay_status;//	int	押金交付状态 0未交 1已交
@property (nonatomic, strong) NSString <Optional>*user_type	;//int	用户类型 0达人 5个人商家
@property (nonatomic, strong) NSString <Optional>*notify_switch;//	string	推送开关通知
@property (nonatomic, strong) NSString <Optional>*nickname	;//string	昵称
@property (nonatomic, strong) NSString <Optional>*header;//	string	头像地址
@property (nonatomic, strong) NSString <Optional>*tag	;//string	极光推送标签
@property (nonatomic, strong) NSString <Optional>*key	;//string	用户id@end
@property (nonatomic, strong) NSString <Optional>* opposite_idcard;//	string	身份证反面照
@property (nonatomic, strong) NSString <Optional>* positive_idcard;//	string	身份证正面照
@property (nonatomic, strong) NSString <Optional>* hand_idcard	;//string	身份证手持照
@property (nonatomic,strong)NSString <Optional> *idcard_no;//身份证号码
@property(nonatomic,strong)NSString <Optional>*hotline;//re热线电话
@end
@interface Out_LoginModel : JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*message;
@property (nonatomic, strong) OutLoginBody <Optional>*data;

@end


//------------------------------------------------------------
#pragma mark 个人中心首页
@interface OutPersonerBody: JSONModel
@property (nonatomic, strong) NSString <Optional>*today_profit;//	double	今日收益（单位：元）
@property (nonatomic, strong) NSString <Optional>*level	;//int	用户等级
@property (nonatomic, strong) NSString <Optional>*total_profit	;//double	平台总首页（单位：元）
@property (nonatomic, strong) NSString <Optional>*withdraw_profit;//	double	可提现收益（单位：元）
@property (nonatomic, strong) NSString <Optional>*is_payed;//	int	是否支付押金（0未支付 1支付成功 2支付失败）
@property (nonatomic, strong) NSString <Optional>*authen_status	;//int	邦办达人认证状态 0申请中 1审核通过 2审核失败
@property (nonatomic, strong) NSString <Optional>*header;//	string	用户头像
@property (nonatomic, strong) NSString <Optional>*mobile	;//string	用户绑定手机号码

@property (nonatomic, strong) NSString <Optional>*company_contact;

@end

@interface Out_personerModel : JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*message;
@property (nonatomic, strong) OutPersonerBody <Optional>*data;

@end
#pragma mark  修改认证信息
@interface changeAapprove_InModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>* degist;
@property (nonatomic, strong) NSString <Optional>* city_name;//	string	工作城市
@property (nonatomic, strong) NSString <Optional>* alipay_account;//	string	手机号码

@end
//----------------------------------------------------

@interface approve_InModel : JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>* degist;
@property (nonatomic, strong) NSString <Optional>* city_name;//	string	工作城市
@property (nonatomic, strong) NSString <Optional>* positive_idcard	;//string	身份证正面照url
@property (nonatomic, strong) NSString <Optional>* opposite_idcard	;//string	身份证反面照url
@property (nonatomic, strong) NSString <Optional>* username	;//string	用户真实姓名
@property (nonatomic, strong) NSString <Optional>* idcardno;//	string	身份证号
@property (nonatomic, strong) NSString <Optional>* hand_idcard	;//string	手持身份证照url
@property (nonatomic, strong) NSString <Optional>* update_city;// 雇主更新城市 固定传1

@end

#pragma mark  获取网格数据信息
@interface getZhanDianMsg_inModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>* digest;
@property (nonatomic, strong) NSString <Optional>* city_name;//	string	工作城市
@end
#pragma mark 生成支付订单并支付model
///生成支付订单并支付model
@interface In_OrderPayModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*trade_amount;//	double	支付宝交易金额
@property (nonatomic, strong) NSString <Optional>*reduced_amount;//	double	平台账号扣取金额
@property (nonatomic, strong) NSString <Optional>*service_amount;//服务费  5%

@property (nonatomic, strong) NSString <Optional>*trade_way	;//int	交易方式 0扣除平台账号余额 1支付宝 2支付宝+余额
@property (nonatomic, strong) NSString <Optional>*trade_type	;//int	交易类型 1收入 2提现 3交押金 4交罚金 5平台服务费 6发单缴费
@property (nonatomic, strong) NSString <Optional>*requirment_id;//	long	需求id trade_type 为6时必选
@property (nonatomic, strong) NSString <Optional>*order_id;//	string	订单号，非必选可以为空

@end

@interface Out_OrderPayAllBody :JSONModel
//@property (nonatomic, strong) NSString <Optional>*pay_order_id;//	int	支付订单号
//@property (nonatomic, strong) NSString <Optional>*notify_url;//	string	支付回调地址
//@property (nonatomic, strong) NSString <Optional>*alipay_config;//		支付宝配置信息如下
@property (nonatomic, strong) NSString <Optional>*ali_public_key;//	string	支付宝的公钥，无需修改该值
@property (nonatomic, strong) NSString <Optional>*private_key;//	string	商户的私钥
@property (nonatomic, strong) NSString <Optional>*appid;//	string	appid
@property (nonatomic, strong) NSString <Optional>*partner	;//string	合作身份者ID，以2088开头由16位纯数字组成的字符串
@property (nonatomic, strong) NSString <Optional>*seller;//	string	收款方


@end
@interface out_OrderPayDataModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*pay_order_id;//	int	支付订单号
@property (nonatomic, strong) NSString <Optional>*notify_url;//	string	支付回调地址
@property (nonatomic, strong) Out_OrderPayAllBody<Optional> *alipay_config;//		支付宝配置信息如下
@end

@interface out_OrderPayModel : JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*message;
@property (nonatomic, strong) out_OrderPayDataModel<Optional> *data;

@end

@interface in_senderOrderModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*grid_id	;//long	网格id
@property (nonatomic, strong) NSString <Optional>*requirment_type	;//int	需求类型 1网点发单 2网格发单
@property (nonatomic, strong) NSString <Optional>*commission	;//double	每单佣金
@property (nonatomic, strong) NSString <Optional>*order_amount	;//string	订单号集合（多个订单以逗号分割）
@property (nonatomic, strong) NSString <Optional>*city_name	;//string	订单号集合（多个订单以逗号分割）


@end

///chaxun查询支付结果
@interface In_afterPayModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*pay_order_id;//	double	支付宝订单号
@end


#pragma mark ---------送货列表－－－－－－－－－－－－－－－－
@interface In_sendGoodsModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*status;//1待抢单 2配送中 3已完成
@property (nonatomic, strong) NSString <Optional>*offset;//分页查询起始值

@property (nonatomic, strong) NSString <Optional>*page_size;//分页大小
@property (nonatomic, strong) NSString <Optional>*word;//模糊查询字符串
@end

@interface Out_sendGoodsBody: JSONModel
@property (nonatomic, strong) NSString <Optional>*username;//	string	达人姓名
@property (nonatomic, strong) NSString <Optional>*order_original_id;//	string	订单号
@property (nonatomic, strong) NSString <Optional>*expt_msg	;//string	异常配送原因
@property (nonatomic, strong) NSString <Optional>*order_status;//	int	"订单状态 0待抢单 1已领货 2配送成功 3配送异常 4回调成功 5回调异常 6取消订单扫描 ;7订单拦截 8已分配 9达人释放"
@property (nonatomic, strong) NSString <Optional>*mobile	;//string	达人手机号码
@property (nonatomic, strong) NSString <Optional>*grid_name	;//string	网格名称
@property (nonatomic, strong) NSString <Optional>*per_oder_commission;//	double	订单每单价格
@property (nonatomic, strong) NSString <Optional>*time	;//string	"status=1 发单时间 / status=2 抢单时间 / status=3 订单反馈时间"
@property (nonatomic, strong) NSString <Optional>*avgevaluate_level;//评分



@end
#pragma mark--------------历史订单---------------------

@interface In_historyOrderModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;//用户id
@property (nonatomic, strong) NSString <Optional>*digest;

@property (nonatomic, strong) NSString <Optional>*offset;//分页起始值（默认0）
@property (nonatomic, strong) NSString <Optional>*page_size;//分页大小（默认10）

@end
@interface Out_historyOrderBody: JSONModel
@property (nonatomic, strong) NSString <Optional>*status;//1配送成功 2配送异常
@property (nonatomic, strong) NSString <Optional>*broker_username;//收入

@property (nonatomic, strong) NSString <Optional>*order_id;//订单号
//@property (nonatomic, strong) NSString <Optional>*date;//交易日期

@end

@interface Out_historyOrderModel: JSONModel

@property int code;
@property (nonatomic, strong) NSString <Optional>*message;//success
@property (nonatomic, strong) Out_historyOrderBody <Optional>*data;

@end

#pragma mark---------------账单流水-----------------


@interface Out_billStreamBody: JSONModel

@property (nonatomic, strong) NSString <Optional>*trade_amount;//流水金额
@property (nonatomic, strong) NSString <Optional>*trade_desc;//交易描述

@property (nonatomic, strong) NSString <Optional>*trade_time;//交易时间
@property (nonatomic, strong) NSString <Optional>*month;//账单月份

@end

@interface Out_billStreamModel: JSONModel
@property int code;
@property (nonatomic, strong) NSString <Optional>*message;//success
@property (nonatomic, strong) Out_billStreamBody <Optional>*data;

@end

#pragma mark---------------发单记录-----------------


@interface Out_billRecordBody: JSONModel

@property (nonatomic, strong) NSString <Optional>*grid_name;//网格名称
@property (nonatomic, strong) NSString <Optional>*order_amount;//订单数量

@property (nonatomic, strong) NSString <Optional>*price;//需求价格  总价
@property (nonatomic, strong) NSString <Optional>*publish_time;//发布时间
@property (nonatomic, strong) NSString <Optional>*requirment_id;//需求id  
@property (nonatomic, strong) NSString <Optional>*requirment_type;//需求类型 0需求发单 1网点发单 2网格发单
@property (nonatomic, strong) NSString <Optional>*status;//"需求状态 0发布中 1已完结 2拦截 3.已发送 4.未支付"
@end



#pragma mark -------------修改绑定手机号
@interface In_changePhoneModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;
@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*header;//接收短信的手机号码
@property (nonatomic, strong) NSString <Optional>*mobile;//	string	原绑定手机号码
@property (nonatomic, strong) NSString <Optional>*newmobile	;//string	新绑定手机号码
@property (nonatomic, strong) NSString <Optional>*code	;//string	验证码
@end

#pragma mark ------------用户反馈--------------
@interface In_opinionBackModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*key;//用户id
@property (nonatomic, strong) NSString <Optional>*digest;

@property (nonatomic, strong) NSString <Optional>*suggestion_text;//反馈内容
@property (nonatomic, strong) NSString <Optional>*suggestion_version;//当前版本
@property(nonatomic,assign)int suggestion_source;//0 android 1 ios
@end


#pragma mark --------订单物流详情-------
@interface Out_orderDetialModel: JSONModel
@property (nonatomic, strong) NSString <Optional>*linghuo_time;//领货时间
@property (nonatomic, strong) NSString <Optional>*sign_time;//签收反馈时间

@property (nonatomic, strong) NSString <Optional>*order_status;//订单状态 1领货 2配送成功 3配送滞留 4配送拒收
@property (nonatomic, strong) NSString <Optional>*expt_msg;//滞留原因
@property (nonatomic, strong) NSString <Optional>*next_delivery_time;//下次配送时间 yyyy-MM-dd ios
@property (nonatomic, strong) NSString <Optional>*broker_username;//达人姓名
@property (nonatomic, strong) NSString <Optional>*broker_mobile;//达人手机号码
@property (nonatomic, strong) NSString <Optional>*order_original_id;//订单号
@property (nonatomic, strong) NSString <Optional>*sign_type;//签收类型
@property (nonatomic, strong) NSString <Optional>*sign_man;//签收人
  @end




