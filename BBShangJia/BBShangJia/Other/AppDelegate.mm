//
//  AppDelegate.m
//  BBShangJia
//
//  Created by cbwl on 16/9/24.
//  Copyright © 2016年 CYT. All rights reserved.
//
#import <TAESDK/TaeSDK.h>

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "RootViewController.h"
#import "KNToast.h"
#import "JPUSHService.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayViewController.h"
#import "FirstUseViewController.h"
#import "UMMobClick/MobClick.h"//友盟统计

@interface AppDelegate ()<btnActionDelegate>
@property (nonatomic,strong)UIAlertView *alertNew;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor clearColor];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunchguzhu"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunchguzhu"];
        FirstUseViewController *vc = [[FirstUseViewController alloc] init];
        vc.delegate = self;
        self.window.rootViewController = vc;
    }else {
        
//        FirstUseViewController *vc = [[FirstUseViewController alloc] init];
//        vc.delegate = self;
//        self.window.rootViewController = vc;
        [self goToMainView];
    }
    //调用键盘方法start
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:0];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    //集成百度地图
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [_mapManager start:@"tEN1e1DS98C4na0CUX4rMio34nuKrGWL"  generalDelegate:self];
    if (!ret) {
        NSLog(@"baidu manager start failed!");
    }
    
    //执行定位功能
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            [self locationClick];
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        [[KNToast shareToast]initWithText:@"定位失败，请检查是否打开定位服务!"  duration:2 offSetY:0];
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前定位不可用，请检查设置中是否打开定位服务?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"设置", nil];
        //        [alert show];
    }
    //阿里百川
    [[TaeSDK sharedInstance] setDebugLogOpen:NO];
    //sdk初始化
    [[TaeSDK sharedInstance] asyncInit:^{
        NSLog(@"初始化成功");
    } failedCallback:^(NSError *error) {
        NSLog(@"初始化失败:%@",error);
    }];
    
    
    //极光推送
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //测试
//    [JPUSHService setupWithOption:launchOptions
//                           appKey:@"3b25876098301227b230c377" channel:@"Test"
//                 apsForProduction:YES advertisingIdentifier:nil];

    //生成
    [JPUSHService setupWithOption:launchOptions
                           appKey:@"f4b3f0ac9f77bf7c88bd4bdf" channel:@"Test"
                 apsForProduction:YES advertisingIdentifier:nil];
    
#pragma mark -------------友盟统计---------------------

    UMConfigInstance.appKey = @"584f4f2bc895767d460006f3";
     UMConfigInstance.channelId = @"App Store";
     //    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
     
     [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
     NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
     [MobClick setAppVersion:version];
     
     [MobClick setLogEnabled:YES];

   // [self getAppStore];
    
    return YES;
}

#pragma mark -------------定位---------------------
//定位
- (void)locationClick;
{
    if (!_locService){
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];

    }
    _locService.delegate = self;
    //    _locService.distanceFilter =10.0;
    _locService.desiredAccuracy =kCLLocationAccuracyBest;
    
    //启动LocationService
    [_locService startUserLocationService];
}


- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    NSLog(@"heading is %@",userLocation.heading);
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_locService stopUserLocationService];
    
    //    _staticlat = userLocation.location.coordinate.latitude;
    //    _staticlng = userLocation.location.coordinate.longitude;
    
    BMKGeoCodeSearch *bmGeoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    bmGeoCodeSearch.delegate = self;
    
    BMKReverseGeoCodeOption *bmOp = [[BMKReverseGeoCodeOption alloc] init];
    bmOp.reverseGeoPoint = userLocation.location.coordinate;
    
    BOOL geoCodeOk = [bmGeoCodeSearch reverseGeoCode:bmOp];
    if (geoCodeOk) {
        NSLog(@"ok");
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    BMKAddressComponent *city = result.addressDetail;
    NSString * loctionCity = [NSString stringWithFormat:@"%@",city.city];
    [[NSUserDefaults standardUserDefaults]setObject:loctionCity forKey:@"loctionCity"];
    NSLog(@"ok %@",loctionCity);
    
    if ([result.poiList count] > 0) {
        //        BMKPoiInfo *tempAddress = [result.poiList objectAtIndex:0];
        
    }else
    {
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    [[KNToast shareToast]initWithText:@"定位失败，请检查是否打开定位服务!" duration:2.0 offSetY:0];
}
#pragma mark 极光推送 ------------
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    DLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    DLog(@"极光推送第一个的 %@",notification);
    //     Required
    //    NSDictionary *user=notification.userinfo;
    //    NSDictionary * userInfo = notification.request.content.userInfo;
    // if([notification.request.trigger isKindOfClass:/[UNPushNotificationTrigger class]]) {
    //    [JPUSHService handleRemoteNotification:userInfo];
    //  }
    // completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    //    NSNotification *notification = [NSNotification notificationWithName:PushNotifyName object:userInfo];
    //    [[NSNotificationCenter defaultCenter] postNotification:notification];
    //
    
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    DLog(@"极光推送第二个的 %@",response);
    //    NSNotification *notification = [NSNotification notificationWithName:PushNotifyName object:userInfo];
    //    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    // Required
    //    NSDictionary * userInfo = response.notification.request.content.userInfo;
    //    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //        [JPUSHService handleRemoteNotification:userInfo];
    //    }
    //    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    NSNotification *notification = [NSNotification notificationWithName:PushNotifyName object:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}
#pragma mark   支付宝配置信息
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            ;
            if (![resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"noAlipay" object:[NSString stringWithFormat:@"%@",resultDic[@"memo"]]];
                DLog(@"duo数十年单  %@",[NSString stringWithFormat:@"%@",resultDic[@"memo"]]);
                
                //                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"支付结果" message:[NSString stringWithFormat:@"%@",resultDic[@"memo"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //                [alert show];
                //
            }
            else{
                NSArray *result=[resultDic[@"result"] componentsSeparatedByString:@"&"] ;
                NSArray *out_trade_no=[result[2] componentsSeparatedByString:@"="] ;
                _orderId=[[out_trade_no lastObject] substringWithRange:NSMakeRange(1, [[out_trade_no lastObject] length]-2)];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"alipay" object:_orderId];
                
            }
            
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            
            
            if (![resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                //                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"支付结果" message:[NSString stringWithFormat:@"%@",resultDic[@"memo"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //                [alert show];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"noAlipay" object:[NSString stringWithFormat:@"%@",resultDic[@"memo"]]];
            }
            else{
                
                NSArray *result=[resultDic[@"result"] componentsSeparatedByString:@"&"] ;
                
                NSArray *out_trade_no=[result[2] componentsSeparatedByString:@"="] ;
                //            NSLog(@"result4444444 = %@",[out_trade_no lastObject]);
                _orderId=[[out_trade_no lastObject] substringWithRange:NSMakeRange(1, [[out_trade_no lastObject] length]-2)];
                //            NSLog(@"result55555 = %@",_orderId);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"alipay" object:_orderId];
            }
        }];
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_AlertViewOne==alertView) {
        
        [[PayViewController alloc]init].tabBarController.selectedIndex=0;
        [[[PayViewController alloc]init]afterAlipayCreateOrderWithOrderId:_orderId];
        [[[PayViewController alloc]init] leftItemClick];
        
        
    }
    if (_AlertViewTwo==alertView) {
        [[PayViewController alloc]init].tabBarController.selectedIndex=0;
        
        [[[PayViewController alloc]init]afterAlipayCreateOrderWithOrderId:_orderId];
        
    }
}
#pragma mark -------当前版本号--------
-(void)getAppStore{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]getVerisonFromAppStoreWithResultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DLog(@"当前版本号%@",dic);
                NSDictionary *data=[[dic objectForKey:@"results"] firstObject];
                
                ///AppStore最新的版本号
                NSString *version=[data objectForKey:@"version"];
                [[NSUserDefaults standardUserDefaults]setObject:version forKey:@"banbenhao"];
                //       获取当前本地的版本号
                NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
                NSString * localVersion =[localDic objectForKey:@"CFBundleShortVersionString"] ;
                if (version){
                if (![localVersion isEqualToString: version])//如果本地版本比较低 证明要更新版本
                {
                    _alertNew = [[UIAlertView alloc]initWithTitle:@"有更新了" message:@"有最新版本了" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                    [_alertNew show];
                }
                }
            });
            
        }];
    });
}

-(void)goToMainView{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = @"cube";//吸入
    transition.subtype = kCAGravityBottomLeft;//动画方向从左向右
    [[UIApplication sharedApplication].delegate.window.layer addAnimation:transition forKey:@"transition"];
    RootViewController *vc = [[RootViewController alloc] init];
    self.window.rootViewController = vc;
}

#pragma mark  ------------------------------------------------

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    application.applicationIconBadgeNumber=0;
//    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self locationClick];
     [JPUSHService setBadge:0];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
