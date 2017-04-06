//
//  MyWalletViewCell.h
//  BBShangJia
//
//  Created by cbwl on 16/9/27.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *canUseLabel;//可用余额
@property (weak, nonatomic) IBOutlet UILabel *consumeLabel;//已消费
-(void)setModel:(NSDictionary *)dic;

@end
