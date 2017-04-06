//
//  SettingViewController.h
//  CYZhongBao
//
//  Created by xc on 15/11/27.
//  Copyright © 2015年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicSouurce.h"

//#import "UserInfoSaveModel.h"

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic ,copy)NSString * telphone;

@end
