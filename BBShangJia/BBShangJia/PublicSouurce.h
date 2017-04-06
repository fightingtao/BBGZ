//
//  PublicSouurce.h
//  BBShangJia
//
//  Created by cbwl on 16/9/24.
//  Copyright © 2016年 CYT. All rights reserved.

#ifdef DEBUG
#ifndef DLog
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#endif
#ifndef ELog
#   define ELog(err) {if(err) DLog(@"%@", err)}
#endif
#else
#ifndef DLog
#   define DLog(...)
#endif
#ifndef ELog
#   define ELog(err)
#endif
#endif

//#ifdef DEBUG
//
//#define DLog(FORMAT, ...) fprintf(stderr,"类名:%s--行数:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//
//#else
//
//#define NSSLog(...)
//
//#endif




#ifndef PublicSouurce_h
#define PublicSouurce_h

//#define kUrlTest @"http://172.168.35.250:8082"  // Y 内网
//#define kUrlTest @"http://121.41.114.230:8082" // 测试

//#define kUrlTest @"http://192.168.13.247:8082" // 韦永华
//#define kUrlTest @"http://192.168.13.245:8082" // 孙琪珍
#define  kUrlTest @"http://192.168.13.244:8082" // 李月
//#define kUrlTest @"http://192.168.13.246:8082"// Y 内网 姜晓亮
//#define kUrlTest @"http://www.bangbanjida.com"//外网


#import "UIView+SDAutoLayout.h"//自动布局
#import "UIView+extension.h"
#import "CustomAlertView.h"//自定义弹出框
#import "MJRefresh.h"
#import "communcat.h"
#import "KNToast.h"//提示框
#import "MBProgressHUD.h"
#import "NetModel.h"
#import "LoginViewController.h"//登录
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "BBJDRequestManger.h"
#import "SVProgressHUD.h" //加载视图


//主题颜色
#define MainColor [UIColor colorWithRed:0.3059 green:0.1922 blue:0.4667 alpha:1.0]
//textmaincolor(白色)
#define TextMainCOLOR [UIColor colorWithRed:0.9647 green:0.9608 blue:0.9725 alpha:1.0]
#define kTextMainCOLOR [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.8]
//textmaincolor(红色)
#define kTextRedCOLOR [UIColor redColor]
//textmaincolor(黑色）
#define kTextBlackCOLOR [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
//字体颜色
#define LineColor   [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0]
//占位字体颜色
#define kplaceHolderColor   [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]
//提示框背景颜色
#define kTiShiBG   [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0]

//背景颜色(灰色)
#define backGroud [UIColor colorWithRed:0.9608 green:0.9608 blue:0.9608 alpha:1.0]
//字体
#define LargeFont   [UIFont systemFontOfSize:18.0]
#define kTextFont16   [UIFont systemFontOfSize:16.0]
#define MiddleFont   [UIFont systemFontOfSize:15.0]
#define LittleFont   [UIFont systemFontOfSize:14.0]

//屏幕宽度和高度
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

//推送
#define PushNotifyName     @"Push"
//懒加载
#define HT_LAZY(object, assignment) (object = object ?: assignment)


///版本号
#define kVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#endif

