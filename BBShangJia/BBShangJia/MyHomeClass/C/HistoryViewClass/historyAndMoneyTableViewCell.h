//
//  historyAndMoneyTableViewCell.h
//  CYZhongBao
//
//  Created by cbwl on 16/8/19.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicSouurce.h"
@interface historyAndMoneyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UILabel *billMoney;

@property (weak, nonatomic) IBOutlet UILabel *billStatus;





-(void)historySetModel:(Out_historyOrderBody *)model;
-(void)billSetModel:(Out_billStreamBody *)model;

+ (instancetype)historyTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(NSDictionary *)dic;//1 历史订单 2账单

//+ (instancetype)billTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(NSDictionary *)dic;
@end
