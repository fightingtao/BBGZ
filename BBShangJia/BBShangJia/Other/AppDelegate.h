//
//  AppDelegate.h
//  BBShangJia
//
//  Created by cbwl on 16/9/24.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicSouurce.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapManager* _mapManager;
    BMKLocationService* _locService;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)UIAlertView *AlertViewOne;
@property (strong,nonatomic)UIAlertView *AlertViewTwo;
@property (nonatomic,copy)NSString *orderId;
- (void)locationClick;
@end

