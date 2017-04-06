//
//  PayViewCell.h
//  BBShangJia
//
//  Created by cbwl on 16/9/24.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol editorBtnDelegate<NSObject>
-(void)editorBtnSelect;
@end

@interface PayViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UILabel *saverMoney;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;
@property (weak, nonatomic) IBOutlet UILabel *requirment_name;

@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;//订单量
@property (weak, nonatomic) IBOutlet UILabel *totalNumLabel;//总计

@property (weak, nonatomic) IBOutlet UIButton *yuerBtn;//余额
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoBtn;//选择支付宝
@property (weak, nonatomic) IBOutlet UILabel *yuerLabel;//余额

@property (weak, nonatomic) IBOutlet UIButton *editorBtn;//编辑按钮

@property(nonatomic,weak)id<editorBtnDelegate>delegate;
@property (nonatomic,assign)float cellHeight1;
-(void)requirment_nameText:(NSString*)text;

@end
