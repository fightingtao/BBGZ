//
//  BBJDRequestManger.h
//  BBJD
//
//  Created by 李志明 on 17/3/21.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicSouurce.h"
#import "AFHTTPSessionManager.h"
@interface BBJDRequestManger : NSObject

+ (RACSignal *)postWithURL:(NSString *)urlString
             withParamater:(NSDictionary *)parameter;


@end
