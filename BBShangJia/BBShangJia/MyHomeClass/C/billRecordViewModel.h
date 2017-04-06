//
//  billRecordViewModel.h
//  BBShangJia
//
//  Created by 李志明 on 17/3/28.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicSouurce.h"
@interface billRecordViewModel : NSObject
@property(nonatomic,strong)RACCommand *cancellCommand;
@property(nonatomic,strong)RACSubject *subject;

@end
