//
//  ApplyBrokerInfoTableViewCell.h
//  CYZhongBao
//
//  Created by xc on 15/11/25.
//  Copyright © 2015年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicSouurce.h"
#import "AppDelegate.h"
#define CellViewHeight 120.0
#define LeftBackViewHeight 20.0*(SCREEN_WIDTH/320.0)


@protocol ApplyInfoDelegate <NSObject>

- (void)setAgentInfo:(NSString *)string andType:(int)type;
-(void)choceAddressBtnClick;
@end

@interface ApplyBrokerInfoTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UIView *menucontentView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UILabel *phoneLabel;



@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UITextField *idTextField;
@property (nonatomic ,strong) UIButton *address;
@property (nonatomic ,strong) UIImageView *right;

@property (nonatomic, strong) id<ApplyInfoDelegate>delegate;
+(CGFloat)cellHeight;

@end
