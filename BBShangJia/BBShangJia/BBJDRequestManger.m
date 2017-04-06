//
//  BBJDRequestManger.m
//  BBJD
//
//  Created by 李志明 on 17/3/21.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "BBJDRequestManger.h"

@implementation BBJDRequestManger

+ (RACSignal *)postWithURL:(NSString *)urlString withParamater:(NSDictionary *)parameter
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
   
    RACSubject *sub =[ RACSubject subject];
    [manager POST:urlString parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSData *data=[responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dicJson=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [sub sendNext:dicJson];
        [sub sendCompleted];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [sub sendNext:error];
        [sub sendCompleted];
    }];
    return sub;
}

@end
