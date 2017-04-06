//
//  SendOrderViewCell.h
//  BBShangJia
//
//  Created by cbwl on 16/9/26.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicSouurce.h"
@interface SendOrderViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *fanwei;
@property (weak, nonatomic) IBOutlet UILabel *priceAndNumb;//价格or数量

@property (weak, nonatomic) IBOutlet UITextField *price;

@property (weak, nonatomic) IBOutlet UILabel *distrLabel;//配送范围

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


@property (weak, nonatomic) IBOutlet UILabel *units;//单位
@property(nonatomic,assign)CGFloat cellHeight1;

-(void)resultWithText:(NSString*)text;
@end
