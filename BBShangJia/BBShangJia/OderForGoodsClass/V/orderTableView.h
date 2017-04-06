//
//  orderTableView.h
//  BBShangJia
//
//  Created by 李志明 on 17/3/27.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicSouurce.h"
@interface orderTableView : UIView
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableDictionary *dataList;
-(instancetype)initWithFrame:(CGRect)frame;
@end
