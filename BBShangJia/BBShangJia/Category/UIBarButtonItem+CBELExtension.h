//
//  UIBarButtonItem+CBELExtension.h
//  CYZhongBao
//
//  Created by 李志明 on 16/8/24.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CBELExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
