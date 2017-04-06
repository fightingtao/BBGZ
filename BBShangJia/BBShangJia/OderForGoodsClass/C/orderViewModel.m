//
//  orderViewModel.m
//  BBShangJia
//
//  Created by 李志明 on 17/3/27.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "orderViewModel.h"
#import "orderTableView.h"
@implementation orderViewModel
-(instancetype)init{
   self = [super init];
    if (self) {
        [self initModel];
    }
    return self;
}


-(void)initModel{
    //加载数据
    self.dataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [SVProgressHUD showWithStatus:@"加载中"];
 
        DLog(@"@@@@@@@@@@@@@%@", input[1]);
        orderTableView *orderTable=input[1];
         NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
         UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSString *hmacString = [[communcat sharedInstance] hmac:input[0] withKey:userInfoModel.primary_key];
         NSMutableDictionary *indic = [[NSMutableDictionary alloc]init];
         [indic setObject:userInfoModel.key forKey:@"key"];
         [indic setObject:hmacString forKey:@"digest"];
        [indic setObject:input[0] forKey:@"order_id"];
        NSString *url=[NSString stringWithFormat:@"%@/crowd-sourcing-consumer/api/v2/seller/order/logistics",kUrlTest];
         RACSignal *signal = [BBJDRequestManger postWithURL:url withParamater:indic];
        
        [signal subscribeNext:^(id x){
            [SVProgressHUD dismiss];
            if ([x isKindOfClass:[NSError class]]) {
                [[KNToast shareToast] initWithText:@"网络异常！" duration:2 offSetY:(SCREEN_HEIGHT-60)];
            }else{
                int code = [[x objectForKey:@"code"] intValue];
                
                if (code == 1000) {
             //   #warning 需要传的数据
                DLog(@"@@@@@@@@@@@@@  %@",x);
                    [self.dataList setValuesForKeysWithDictionary:x[@"data"]];
                    [orderTable.tableView reloadData];
                }else{
                    [[KNToast shareToast] initWithText: x[@"message"] duration:2 offSetY:(SCREEN_HEIGHT-60)];
                }
            }
        }];
        return signal;
    }];
}


-(NSMutableDictionary*)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableDictionary alloc] init];
    }
    return _dataList;
}
@end
