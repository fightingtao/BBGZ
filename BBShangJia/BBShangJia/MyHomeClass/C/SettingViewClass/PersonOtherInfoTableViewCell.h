//
//  PersonOtherInfoTableViewCell.h
//  CYZhongBao
//
//  Created by xc on 15/11/24.
//  Copyright © 2015年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicSouurce.h"

@interface PersonOtherInfoTableViewCell : UITableViewCell


@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *contentLable;
@property (nonatomic, strong) UIImageView *arrowImg;
@property (nonatomic, strong) UILabel *versionLabel;

- (void)CurrentVersion;

@end
