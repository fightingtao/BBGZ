//
//  ScannerListTableViewCell.h
//  CYZhongBao
//
//  Created by xc on 16/1/21.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicSouurce.h"

@protocol ScannerGoodsDelegate <NSObject>

- (void)cancelOrderWithIndex:(NSInteger)index;

@end

@interface ScannerListTableViewCell : UITableViewCell

@property (nonatomic, strong) id<ScannerGoodsDelegate>delegate;

@property (nonatomic, strong) UILabel *orderNumLabel;
@property (nonatomic, strong) UIButton *cancelOrderBtn;

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msg:(NSArray *)ary;

@end
