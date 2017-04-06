//
//  binDingVController.h
//  CYZhongBao
//
//  Created by cbwl on 16/8/18.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChangePhoneDelegate <NSObject>
-(void)hadChangePhone:(NSString *)phone;
@end

@interface binDingVController : UIViewController
@property (nonatomic,strong)id <ChangePhoneDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *textPhone;
@property (weak, nonatomic) IBOutlet UITextField *textCode;
@property (weak, nonatomic) IBOutlet UIButton *btnCode;


@end
