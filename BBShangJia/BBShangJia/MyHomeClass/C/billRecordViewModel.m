//
//  billRecordViewModel.m
//  BBShangJia
//
//  Created by 李志明 on 17/3/28.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "billRecordViewModel.h"

@implementation billRecordViewModel
-(instancetype)init{
    self = [super init];
    if(self){
        [self bingViewModel];
    }
    return self;
}

-(void)bingViewModel{
    self.cancellCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [SVProgressHUD showWithStatus:@"加载中"];
        NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
        UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSString *hmacString = [[communcat sharedInstance] hmac:input withKey:userInfoModel.primary_key];
        NSMutableDictionary *indic = [[NSMutableDictionary alloc]init];
        [indic setObject:userInfoModel.key forKey:@"key"];
        [indic setObject:hmacString forKey:@"digest"];
        [indic setObject:input forKey:@"requirment_id"];
        NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/seller/publish/cancle",kUrlTest];
        RACSignal *signal = [BBJDRequestManger postWithURL:url withParamater:indic];
        [signal subscribeNext:^(id x){
            [SVProgressHUD dismiss];
            if ([x isKindOfClass:[NSError class]]) {
                [[KNToast shareToast] initWithText:@"网络异常！" duration:2 offSetY:(SCREEN_HEIGHT-100)];
            }else{
                int code = [[x objectForKey:@"code"] intValue];
                if (code == 1000) {
                     [[KNToast shareToast] initWithText:@"订单已取消" duration:2 offSetY:(SCREEN_HEIGHT-60)];
                    [self.subject sendNext:@1];
                    
                }else{
                      [[KNToast shareToast] initWithText: x[@"message"] duration:2 offSetY:(SCREEN_HEIGHT-100)];
                }
            }
            
        }];
        return signal;
    }];
}
@end
