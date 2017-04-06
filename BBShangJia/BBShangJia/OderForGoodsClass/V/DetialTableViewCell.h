//
//  DetialTableViewCell.h
//  BBShangJia
//  Created by 李志明 on 17/2/27.
//  Copyright © 2017年 CYT. All rights reserved.

#import <UIKit/UIKit.h>

@interface DetialTableViewCell : UITableViewCell
@property(nonatomic,strong)UIView *verticalLineTopView;
@property(nonatomic,strong)UIView *dotView;
@property(nonatomic,strong)UIView *verticalLineBottomView;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *showLabel;
@property(nonatomic,strong)UILabel *status;

@property(nonatomic,assign)CGFloat height;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setDataSource:(NSString *)content date:(NSString*)time   isFirst:(BOOL)isFirst isLast:(BOOL)isLast;

- (void)setExptDataSource:(NSString *)content date:(NSString*)time  nextTime:(NSString *)nextTime isFirst:(BOOL)isFirst isLast:(BOOL)isLast;

+ (CGFloat)cellHeightWithString:(NSString *)str;

@end
