//
//  orderViewModel.h
//  BBShangJia
//
//  Created by 李志明 on 17/3/27.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicSouurce.h"
@interface orderViewModel : NSObject
@property(nonatomic,strong)RACCommand *dataCommand;
//@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,strong)NSMutableDictionary *dataList;
@end
