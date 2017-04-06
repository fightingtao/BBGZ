//
//  ourVController.h
//  RCYunMaApp
//
//  Created by cbwl on 16/8/12.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ourVController : UIViewController
@property (nonatomic ,copy)NSString * telphone;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *version;

@end
