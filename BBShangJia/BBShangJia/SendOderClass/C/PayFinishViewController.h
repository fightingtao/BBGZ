//
//  PayFinishViewController.h
//  BBShangJia
//
//  Created by cbwl on 16/9/24.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayFinishViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UILabel *discrp;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (nonatomic,assign)int status;//1 支付完成 2未支付
@property (nonatomic,copy)NSString *noPayMsg;//支付失败原因
@property (nonatomic,copy)NSString *time;//支付时间
@end
