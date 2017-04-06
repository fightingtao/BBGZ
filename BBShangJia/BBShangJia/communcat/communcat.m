//
//  communcat.m
//  BBShangJia
//
//  Created by cbwl on 16/9/27.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "communcat.h"
#import "PublicSouurce.h"
//#import "AFHTTPRequestOperation.h"
@implementation communcat
//***************************************************************************
#pragma mark 倒计时
-(void)startCodeTimeWithTime:(int)time during:(void(^)(int timeDuring))timeDuring outTime:(void(^)(int outTime))outTime
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
                    outTime(timeout);
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //倒计时期间 设置界面的按钮显示 根据自己需求设置
                    
                    timeDuring(timeout);
                });
                timeout--;
                
            }
        });
        dispatch_resume(_timer);
    }


//创建图片
- (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}


//加密
-(NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key
{
    
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    return HMAC;
}
//数组排序 和加密
- (NSString*)ArrayCompareAndHMac:(NSArray*)array
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    
    // 返回一个排好序的数组，原来数组的元素顺序不会改变
    // 指定元素的比较方法：compare:
    NSString *tempContent = @"";
    NSArray *array2 = [array sortedArrayUsingSelector:@selector(compare:)];
    for (int i = 0; i<[array2 count]; i++) {
        NSString *temp = [array2 objectAtIndex:i];
        tempContent = [NSString stringWithFormat:@"%@%@",tempContent,temp];
    }
    if (userInfoModel&&userInfoModel.key&&![userInfoModel.key isEqualToString:@""]&& userInfoModel.key.length!=0)
    {
        const char *cKey  = [userInfoModel.primary_key cStringUsingEncoding:NSASCIIStringEncoding];
        const char *cData = [tempContent cStringUsingEncoding:NSUTF8StringEncoding];
        unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
        CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
        NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
        const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
        NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
        for (int i = 0; i < HMACData.length; ++i){
            [HMAC appendFormat:@"%02x", buffer[i]];
        }
        return HMAC;
    }else
    {
        return tempContent;
    }
}
#pragma 正则匹配用户身份证号15或18位
- (BOOL)checkUserIdCard: (NSString *) identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
#pragma mark 验证手机号码
- (BOOL)checkTel:(NSString *)str

{
    if ([str length] == 0) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"data_null_prompt", nil) message:NSLocalizedString(@"tel_no_null", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return NO;
        
    }
    
    NSString *regex =  @"^1+[3578]+\\d{9}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        
        [alert show];
        return NO;
        
    }
    return YES;
}
//
////md5加密
//- (NSString *) getmd5:(NSString *)str
//
//{
//    
//    const char *cStr = [str UTF8String];
//    
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    
//    CC_MD5( cStr, strlen(cStr), result );
//    
//    return [NSString
//            
//            stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
//            
//            result[0], result[1],
//            
//            result[2], result[3],
//            
//            result[4], result[5],
//            
//            result[6], result[7],
//            
//            result[8], result[9],
//            
//            result[10], result[11],
//            
//            result[12], result[13],
//            
//            result[14], result[15]
//            
//            ];
//}
//
+ (id)sharedInstance
{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark 网络请求时对AFnetWork的封装
-(void)getMessageUsePostWithDic:(NSDictionary *)dic url:(NSString *)url result:(void(^)(NSDictionary * resultDic))resultDic{
    if ([[dic objectForKey:@"digest"] isEqualToString:@""]) {
        return;
    }
    _manager =[AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSData *data=[responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dicJson=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;

        DLog(@"dic***%@",allHeaders);
        resultDic(dicJson);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"失败%@",error);
        
    }];
    
}

#pragma mark 网络请求时对AFnetWork的封装  返回时间
-(void)getMessageUsePostWithDic:(NSDictionary *)dic url:(NSString *)url date:(void(^)(NSDate * date))date result:(void(^)(NSDictionary * resultDic))resultDic{
    if ([[dic objectForKey:@"digest"] isEqualToString:@""]) {
        return;
    }
    _manager =[AFHTTPSessionManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [_manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSData *data=[responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dicJson=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        DLog(@"dic***%@",allHeaders);
        
//        date([self getDateFormatterByMillisecond:allHeaders[@"Date"]]);
         date([self getSysDateFromString:allHeaders[@"Date"]]);
        resultDic(dicJson);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"失败%@",error);
        
    }];
    
}
-(NSDate *)getDateFormatterByMillisecond:(NSString* )millisecond{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    

    //设置源日期时区
//    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [destinationTimeZone  secondsFromGMTForDate:[NSDate date]];
    //目标日期与本地时区的偏移量
//    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:[dateFormatter dateFromString: millisecond]];
        NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:[NSDate date]];

    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:[NSDate date]];
           NSString *dateString = [dateFormatter stringFromDate:destinationDateNow];
    DLog(@"这是几点:%@",dateString);
    return destinationDateNow;
}
-(NSDate*)getSysDateFromString:(NSString*)str{
    
    NSString* string = [str substringToIndex:25];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setLocale:[[NSLocale alloc]
                               initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    return inputDate;
    
}
//- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
//{
//    //设置源日期时区
//    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
//    //设置转换后的目标日期时区
//    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
//    //得到源日期与世界标准时间的偏移量
//    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
//    //目标日期与本地时区的偏移量
//    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
//    //得到时间偏移量的差值
//    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
//    //转为现在时间
//    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
//    return destinationDateNow;
//}

#pragma mark  快捷登录验证码发送
-(void)sendCodeWithPhone:(NSString *)phone resultDic:(void(^)(NSDictionary *dic))dic
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:phone forKey:@"telephone"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/login/code",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        DLog(@"resultDic***%@",resultDic);
        dic(resultDic);
    }];
}

#pragma mark   登录
-(void)LoginbtnClickWithMsg:(In_LoginModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic;
{
    
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:loginInModel.telephone forKey:@"telephone"];
    [indic setObject:loginInModel.code forKey:@"code"];
    [indic setObject:loginInModel.userType forKey:@"user_type"];

    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/login",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        DLog(@"登录成功登录成功登录成功dic%@",resultDic);
        dic(resultDic);
    }];
    
}

#pragma mark  个人信息首页
-(void)getPersonerMsgWithkey:(NSString *)key degist:(NSString *)degist  resultDic:(void (^)(NSDictionary *dic))dic;
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/person/info/index",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        DLog(@"dic%@",[resultDic objectForKey:@"message"]);
        dic(resultDic);
    }];
    
}

#pragma mark   修改达人认证
-(void)changeApproveMsgWithModel:(approve_InModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic;
{
    
    NSMutableDictionary *in_dic=[[NSMutableDictionary alloc]init];
    [in_dic setObject:loginInModel.key  forKey:@"key"];
    [in_dic setObject:loginInModel.degist forKey:@"digest"];
    [in_dic setObject:loginInModel.positive_idcard  forKey:@"positive_idcard"];
    [in_dic setObject:loginInModel.opposite_idcard forKey:@"opposite_idcard"];
    [in_dic setObject:loginInModel.hand_idcard  forKey:@"hand_idcard"];
    [in_dic setObject:loginInModel.username  forKey:@"seller_admin_name"];
    [in_dic setObject:loginInModel.idcardno forKey:@"idcard_no"];
    [in_dic setObject:loginInModel.city_name forKey:@"city_name"];
    [in_dic setObject:loginInModel.update_city forKey:@"update_city"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/seller/authenticate",kUrlTest];
    [self getMessageUsePostWithDic:in_dic url:url result:^(NSDictionary *resultDic) {
        DLog(@"达人认证成功dic%@",resultDic);
        dic(resultDic);
    }];
    
}
#pragma mark   达人认证
-(void)getApproveMsgWithModel:(approve_InModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic;
{
   
    NSMutableDictionary *in_dic=[[NSMutableDictionary alloc]init];
    [in_dic setObject:loginInModel.key  forKey:@"key"];
    [in_dic setObject:loginInModel.degist forKey:@"digest"];
    [in_dic setObject:loginInModel.positive_idcard  forKey:@"positive_idcard"];
    [in_dic setObject:loginInModel.opposite_idcard forKey:@"opposite_idcard"];
    [in_dic setObject:loginInModel.hand_idcard  forKey:@"hand_idcard"];
    [in_dic setObject:loginInModel.username  forKey:@"seller_admin_name"];
    [in_dic setObject:loginInModel.idcardno forKey:@"idcard_no"];
    [in_dic setObject:loginInModel.city_name forKey:@"city_name"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/seller/authenticate",kUrlTest];
    [self getMessageUsePostWithDic:in_dic url:url result:^(NSDictionary *resultDic) {
        DLog(@"达人认证成功dic%@",resultDic);
        dic(resultDic);
    }];
    
}

#pragma mark  获取网格站点信息
-(void)getZhanDianWithMsg:(getZhanDianMsg_inModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic;
{
    
    NSMutableDictionary *in_dic=[[NSMutableDictionary alloc]init];
    [in_dic setObject:loginInModel.key  forKey:@"key"];
    [in_dic setObject:loginInModel.digest forKey:@"digest"];

            [in_dic setObject:loginInModel.city_name forKey:@"city_name"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/seller/get/grid/list",kUrlTest];
    [self getMessageUsePostWithDic:in_dic url:url result:^(NSDictionary *resultDic) {
        DLog(@"站点信息数据dic%@",resultDic);
        dic(resultDic);
    }];
    
}
#pragma mark  获取网格站点金额
-(void)getZhanDianMoneyWithKey:(NSString *)key digest :(NSString *)digest  resultDic:(void (^)(NSDictionary *dic))dic;
{
    
    NSMutableDictionary *in_dic=[[NSMutableDictionary alloc]init];
    [in_dic setObject:key  forKey:@"key"];
    [in_dic setObject:digest forKey:@"digest"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/seller/publish/page",kUrlTest];
    [self getMessageUsePostWithDic:in_dic url:url result:^(NSDictionary *resultDic) {
        DLog(@"站点信息数据dic%@",resultDic);
        dic(resultDic);
    }];
    
}

#pragma mark 退出登录
-(void)loginOutClickWithKey:(NSString *)key digest:(NSString *)digest resultDic:(void(^)(NSDictionary *dic))dic;
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:key forKey:@"key"];
    [indic setObject:digest forKey:@"digest"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/logout",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
    
}
#pragma mark  提交订单
-(void)senderOrdersWithModel:(in_senderOrderModel *)loginInModel  resultDic:(void (^)(NSDictionary *dic))dic;
{
    
    NSMutableDictionary *in_dic=[[NSMutableDictionary alloc]init];
    [in_dic setObject:loginInModel.key  forKey:@"key"];
    [in_dic setObject:loginInModel.digest forKey:@"digest"];
    [in_dic setObject:loginInModel.grid_id forKey:@"grid_id"];
    [in_dic setObject:loginInModel.requirment_type forKey:@"requirment_type"];
    [in_dic setObject:loginInModel.commission forKey:@"commission"];
    [in_dic setObject:[NSString stringWithFormat:@"%@",loginInModel.order_amount] forKey:@"order_amount"];
    [in_dic setObject:[NSString stringWithFormat:@"%@",loginInModel.city_name] forKey:@"city_name"];

    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/seller/publish",kUrlTest];
    [self getMessageUsePostWithDic:in_dic url:url result:^(NSDictionary *resultDic) {
        DLog(@"站点信息数据dic%@",resultDic);
        dic(resultDic);
    }];

}
#pragma mark  生成支付订单
-(void)createOrderAlipayWithModel:(In_OrderPayModel *)InModel  resultDic:(void (^)(NSDictionary *dic))dic;
{
    
    NSMutableDictionary *in_dic=[[NSMutableDictionary alloc]init];
    [in_dic setObject:InModel.key  forKey:@"key"];
    [in_dic setObject:InModel.digest forKey:@"digest"];
    [in_dic setObject:InModel.trade_amount  forKey:@"trade_amount"];
    [in_dic setObject:InModel.reduced_amount forKey:@"reduced_amount"];
     [in_dic setObject:InModel.trade_way  forKey:@"trade_way"];
    [in_dic setObject:InModel.trade_type forKey:@"trade_type"];
    [in_dic setObject:InModel.requirment_id  forKey:@"requirment_id"];
    [in_dic setObject:InModel.order_id forKey:@"order_id"];
    [in_dic setObject:InModel.service_amount forKey:@"service_amount"];

    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/pay/build/pay/order",kUrlTest];
    [self getMessageUsePostWithDic:in_dic url:url result:^(NSDictionary *resultDic) {
        DLog(@"生成支付订单dic%@",resultDic);
        dic(resultDic);
    }];
    
}
#pragma mark  查询支付结果
-(void)checkOrderAfterAlipayWithModel:(In_afterPayModel *)InModel  resultDic:(void (^)(NSDictionary *dic))dic;
{
    
    NSMutableDictionary *in_dic=[[NSMutableDictionary alloc]init];
    [in_dic setObject:InModel.key  forKey:@"key"];
    [in_dic setObject:InModel.digest forKey:@"digest"];
    [in_dic setObject:InModel.pay_order_id  forKey:@"pay_order_id"];
   
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/pay/query/pay/order",kUrlTest];
    [self getMessageUsePostWithDic:in_dic url:url result:^(NSDictionary *resultDic) {
        DLog(@"生成支付订单dic%@",resultDic);
        dic(resultDic);
    }];
    
}
#pragma mark  取消订单
-(void)cancelOrderAlipayWithModel:(In_afterPayModel *)InModel  resultDic:(void (^)(NSDictionary *dic))dic;
{
    
    NSMutableDictionary *in_dic=[[NSMutableDictionary alloc]init];
    [in_dic setObject:InModel.key  forKey:@"key"];
    [in_dic setObject:InModel.digest forKey:@"digest"];
    [in_dic setObject:InModel.pay_order_id  forKey:@"requirment_id"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer//api/v2/seller/publish/cancle",kUrlTest];
    [self getMessageUsePostWithDic:in_dic url:url result:^(NSDictionary *resultDic) {
        DLog(@"取消支付订单dic%@",resultDic);
        dic(resultDic);
    }];
    
}
#pragma mark 获取余额多少
-(void)getYuEMoneyWithKey:(NSString *)key digest:(NSString *)digest resultDic:(void(^)(NSDictionary *dic))dic;
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:key forKey:@"key"];
    [indic setObject:digest forKey:@"digest"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/pay/get/wallet/balance",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
    
}

#pragma mark ---------送货列表－－－－－－－－－－－－－－－－
-(void)sendGoodsListWithMsg:(In_sendGoodsModel *)sendGoodsModel  resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:sendGoodsModel.key forKey:@"key"];
    [indic setObject:sendGoodsModel.digest forKey:@"digest"];
    [indic setObject:sendGoodsModel.status forKey:@"status"];
    [indic setObject:sendGoodsModel.offset forKey:@"offset"];
    [indic setObject:sendGoodsModel.page_size forKey:@"page_size"];
    [indic setObject:sendGoodsModel.word forKey:@"word"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/seller/order/list",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        DLog(@"登录成功dic%@",resultDic);
        dic(resultDic);
    }];
}

#pragma mark ---------FADIANFADAN发单列表－－－－－－－－－－－－－－－－
-(void)getBillRecordListWithMsg:(In_sendGoodsModel *)sendGoodsModel date:(void (^)(NSDate *outDate))outDate resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:sendGoodsModel.key forKey:@"key"];
    [indic setObject:sendGoodsModel.digest forKey:@"digest"];
    [indic setObject:sendGoodsModel.status forKey:@"status"];
    [indic setObject:sendGoodsModel.offset forKey:@"offset"];
    [indic setObject:sendGoodsModel.page_size forKey:@"page_size"];
//    [indic setObject:sendGoodsModel.word forKey:@"word"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/seller/get/publish/list",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url date:^(NSDate *date) {
        
        outDate(date);
    } result:^(NSDictionary *resultDic) {
        
        DLog(@"FADIANFADANdic   %@",resultDic);
        dic(resultDic);

    }];
//    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
//
//       
//        dic(resultDic);
//    }];
}
#pragma mark  获取钱包金额
-(void)getMyMoneyWithKey:(NSString *)key digest :(NSString *)digest  userType:(NSString *)usertype resultDic:(void (^)(NSDictionary *dic))dic;
{
    
    NSMutableDictionary *in_dic=[[NSMutableDictionary alloc]init];
    [in_dic setObject:key  forKey:@"key"];
    [in_dic setObject:digest forKey:@"digest"];
    [in_dic setObject:usertype forKey:@"user_type"];

    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/user/my/wallet",kUrlTest];
    [self getMessageUsePostWithDic:in_dic url:url result:^(NSDictionary *resultDic) {
        DLog(@"站点信息数据dic%@",resultDic);
        dic(resultDic);
    }];
    
}

#pragma mark ---------zhangdna 账单列表－－－－－－－－－－－－－－－－
-(void)getBillListWithMsg:(In_sendGoodsModel *)sendGoodsModel  resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:sendGoodsModel.key forKey:@"key"];
    [indic setObject:sendGoodsModel.digest forKey:@"digest"];
    [indic setObject:sendGoodsModel.offset forKey:@"offset"];
    [indic setObject:sendGoodsModel.page_size forKey:@"page_size"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/seller/get/wallet/log",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        DLog(@"登录成功dic%@",resultDic);
        dic(resultDic);
    }];
}

#pragma mark--------------历史订单---------------------
-(void)getHistoryOrderlInforWithMsg:(In_historyOrderModel *)historyOrderModel  resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:historyOrderModel.key forKey:@"key"];
    [indic setObject:historyOrderModel.digest forKey:@"digest"];
    [indic setObject:historyOrderModel.offset forKey:@"offset"];
    [indic setObject:historyOrderModel.page_size forKey:@"page_size"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/history/order",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        DLog(@"登录成功dic%@",resultDic);
        dic(resultDic);
    }];
    
}

#pragma mark---------------修改绑定手机号----------------------------

-(void)changePersonerPhoneWith:(In_changePhoneModel *)Model  resultDic:(void (^)(NSDictionary *dic))dic
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:Model.key forKey:@"key"];
    [indic setObject:Model.digest forKey:@"digest"];
    [indic setObject:Model.header forKey:@"header"];
    [indic setObject:Model.mobile forKey:@"mobile"];
    [indic setObject:Model.newmobile forKey:@"newmobile"];
    [indic setObject:Model.code forKey:@"code"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/update/user/info",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        DLog(@"登录成功dic%@",resultDic);
        dic(resultDic);
    }];
    
}
#pragma mark  修改绑定手机号
-(void)changePersonerPhoneMsgWithkey:(NSString *)key degist:(NSString *)degist phone:(NSString *)phone resultDic:(void (^)(NSDictionary *dic))dic;
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    [indic setObject:phone forKey:@"telephone"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/update/mobile/code",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        DLog(@"dic%@",[resultDic objectForKey:@"message"]);
        dic(resultDic);
    }];
    
}
#pragma mark 开放城市
-(void)getCityWithKey:(NSString *)key digest:(NSString *)digest resultDic:(void(^)(NSDictionary *dic))dic;
{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    [indic setObject:key forKey:@"key"];
    [indic setObject:digest forKey:@"digest"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/requirement/open/city/list",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        DLog(@"定位到当前城市%@",resultDic);
        dic(resultDic);
    }];
    
}

#pragma mark---------------意见反馈---------------------
-(void)feedBackClickWithModel:(In_opinionBackModel *)InModel  resultDic:(void (^)(NSDictionary *dic))dic{
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:InModel.key forKey:@"key"];
    [indic setObject:InModel.digest forKey:@"digest"];
    [indic setObject:InModel.suggestion_text  forKey:@"suggestion_text"];
    [indic setObject:InModel.suggestion_version  forKey:@"suggestion_version"];
    [indic setObject:[NSString stringWithFormat:@"%d",InModel.suggestion_source] forKey:@"suggestion_source"];
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/suggest",kUrlTest];
    
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        DLog(@"登录成功dic%@",resultDic);
        dic(resultDic);
    }];
}
#pragma mark   获取更新信息
-(void)getVerisonFromAppStoreWithResultDic:(void (^)(NSDictionary *dic))dic;
{
    
    NSString *url=[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup"];
    
    [self getMessageUsePostWithDic:nil url:url result:^(NSDictionary *resultDic) {
        DLog(@"登录成功dic%@",resultDic);
        dic(resultDic);
    }];
    
}
#pragma mark----------------更新登录信息
-(void)upDataUserMsgWithkey:(NSString *)key degist:(NSString *)degist resultDic:(void (^)(NSDictionary *dic))dic{
    
    NSMutableDictionary *indic=[[NSMutableDictionary alloc]init];
    
    [indic setObject:key forKey:@"key"];
    [indic setObject:degist forKey:@"digest"];
    
    NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/user/login/info",kUrlTest];
    [self getMessageUsePostWithDic:indic url:url result:^(NSDictionary *resultDic) {
        dic(resultDic);
    }];
}




@end
