//
//  ApplyBrokerViewController.h
//  CYZhongBao
//
//  Created by xc on 15/11/25.
//  Copyright © 2015年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicSouurce.h"
#import "AppDelegate.h"
//#import "communcation.h"


#import <TAESDK/TAESDK.h>
#import <ALBBMediaService/ALBBMediaService.h>
#import <ALBBMediaService/ALBBMediaServiceProtocol.h>

@interface ApplyBrokerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property BOOL isRootVC;
@property (nonatomic,assign)int status;//1正常认证 2修改认证信息
@end
