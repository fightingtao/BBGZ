//
//  UIBarButtonItem+CBELExtension.m
//  CYZhongBao
//

//  Copyright © 2016年 xc. All rights reserved.
//

#import "UIBarButtonItem+CBELExtension.h"
#import "UIView+extension.h"
@implementation UIBarButtonItem (CBELExtension)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    button.size = button.currentBackgroundImage.size;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
    
}
@end
