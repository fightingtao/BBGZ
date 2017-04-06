//
//  ApplyBrokerImgTableViewCell.h
//  CYZhongBao
//
//  Created by xc on 15/11/25.
//  Copyright © 2015年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicSouurce.h"

#define ImgCellViewHeight 3*80*(SCREEN_WIDTH/320.0)+70
#define ImgViewHeight 120.0*(SCREEN_WIDTH/320.0)
#define ImgBackWidth 25.0*(SCREEN_WIDTH/320.0)
#define ImgHeight 80.0*(SCREEN_WIDTH/320.0)
#define ImgWidth 120.0*(SCREEN_WIDTH/320.0)

@protocol IdImgDelegate <NSObject>

- (void) idImgChoose:(int)type;

@end


@interface ApplyBrokerImgTableViewCell : UITableViewCell

@property (nonatomic, assign) id<IdImgDelegate> delegate;
@property (nonatomic, strong) UIView *menucontentView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *nameLabel2;
@property (nonatomic, strong) UILabel *nameLabel3;
@property (nonatomic, strong) UIImageView *tempImg;
@property (nonatomic, strong) UIImageView *tempImg2;
@property (nonatomic, strong) UIImageView *tempImg3;
@property (nonatomic, strong) UIImageView *idImg;
@property (nonatomic, strong) UIImageView *idImg2;
@property (nonatomic, strong) UIImageView *idImg3;


- (void)refreshIdImgWithType:(int)type andIdImg:(UIImage*)img;
+(CGFloat)cellHeight;

@end
