//
//  citySelectVController.m
//  BBShangJia
//
//  Created by cbwl on 16/9/28.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "citySelectVController.h"
#import "PublicSouurce.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
@interface citySelectVController ()<UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    NSString *_name;//城市名
    
}
@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *loctionCity;
@property (nonatomic, strong)  BMKLocationService *locService ;

@property(nonatomic,strong)NSMutableArray *allArray;
@property(nonatomic,strong)NSMutableArray *listArray;

@end

@implementation citySelectVController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=false;
    
    self.hidesBottomBarWhenPushed=YES;
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.listArray =[[NSMutableArray alloc]init];

    self.view.backgroundColor =[UIColor grayColor];
    
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationController.navigationBar setBarTintColor:MainColor];//设置navigationbar的颜色
    
    UIButton *leftItem =[UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 64, 150, 36)];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 36)];
        _titleLabel.backgroundColor = MainColor;
        _titleLabel.font = LargeFont;
        _titleLabel.textColor = TextMainCOLOR;
        _titleLabel.text = @"选择城市";
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleView addSubview:_titleLabel];
    }
    self.navigationItem.titleView = _titleView;
    [self.view addSubview:[self initpersonTableView]];
    [self getCity];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    _loctionCity=@"";

}

#pragma mark 初始化下单table
-(UITableView *)initpersonTableView
{
    if (self.tableView != nil) {
        return self.tableView ;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT-64;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView .delegate = self;
    self.tableView .dataSource = self;
    self.tableView .backgroundColor = backGroud;
    self.tableView .showsVerticalScrollIndicator = NO;
    return self.tableView ;
}

#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  _allArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 2;
        
    }
       return [_allArray[section-1] count] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        
        return  _allArray[section-1][0][@"letter"];
        
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    if (indexPath.section==0){
        if (indexPath.row==0) {
            cell.textLabel.text=@"当前城市";
        }else {
            if ([_loctionCity isEqualToString:@""] || -_loctionCity.length == 0){
                if ([self.listArray containsObject:_name]) {
                   cell.textLabel.text= _name;
                }else{
                 cell.textLabel.text=[NSString stringWithFormat:@"%@(该城市暂未开放)",_name];
                }
            }
        }
    }
    else{
    NSArray *array=_allArray[indexPath.section-1];
    NSDictionary *dic=array [indexPath.row];
    cell.textLabel.text =dic[@"name"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0){
        if(indexPath.row == 0){
        return;
        }else{
            if ([self.listArray containsObject:_name]) {
                _loctionCity = _name;
            }else{
                return;
            }
        }
    }else{
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    _loctionCity = cell.textLabel.text;
    
    }
    [self leftItemClick];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_status==2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"citySelect2" object:_loctionCity];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"city" object:_loctionCity];
    }
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark 获取开放城市

-(void)getCity{
    
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    
    NSString *hmac=[[communcat sharedInstance ]hmac:@"" withKey:userInfoModel.primary_key];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] getCityWithKey:userInfoModel.key digest:hmac resultDic:^(NSDictionary *dic) {
             dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //            _outModel=[[Out_personerModel alloc]initWithDictionary:dic error:nil];
            DLog(@"个人信息信息%@",dic);
            int code=[[dic objectForKey:@"code"] intValue];
            if (!dic)
            {
                 [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];

            }else if (code ==1000)
            {
                
                
                NSDictionary *data=[dic objectForKey:@"data"];
                NSArray *citys=[data objectForKey:@"opencitys"];
                for (NSDictionary *city in citys) {
                    [self.listArray addObject:city[@"name"]];
                }
                
                _allArray = [NSMutableArray array];
                NSMutableArray *arrayA = [NSMutableArray array];
                NSMutableArray *arrayB = [NSMutableArray array];
                NSMutableArray *arrayC = [NSMutableArray array];
                NSMutableArray *arrayD = [NSMutableArray array];
                NSMutableArray *arrayE = [NSMutableArray array];
                NSMutableArray *arrayF = [NSMutableArray array];
                NSMutableArray *arrayG = [NSMutableArray array];
                NSMutableArray *arrayH = [NSMutableArray array];
                NSMutableArray *arrayI = [NSMutableArray array];
                NSMutableArray *arrayJ = [NSMutableArray array];
                NSMutableArray *arrayK = [NSMutableArray array];
                NSMutableArray *arrayL = [NSMutableArray array];
                NSMutableArray *arrayM = [NSMutableArray array];
                NSMutableArray *arrayN = [NSMutableArray array];
                NSMutableArray *arrayO = [NSMutableArray array];
                NSMutableArray *arrayP = [NSMutableArray array];
                NSMutableArray *arrayQ = [NSMutableArray array];
                NSMutableArray *arrayR = [NSMutableArray array];
                NSMutableArray *arrayS = [NSMutableArray array];
                NSMutableArray *arrayT = [NSMutableArray array];
                NSMutableArray *arrayU = [NSMutableArray array];
                NSMutableArray *arrayV = [NSMutableArray array];
                NSMutableArray *arrayW = [NSMutableArray array];
                NSMutableArray *arrayX = [NSMutableArray array];
                NSMutableArray *arrayY = [NSMutableArray array];
                NSMutableArray *arrayZ = [NSMutableArray array];
                for (NSDictionary *dict in citys) {
                  
                    if ([dict[@"letter"] isEqualToString:@"A"]) {
                       
                        [arrayA addObject:dict];
                    }else if ([dict[@"letter"] isEqualToString:@"B"]){
                        [arrayB addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"C"]){
                        [arrayC addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"D"]){
                        [arrayD addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"E"]){
                        [arrayE addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"F"]){
                        [arrayF addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"G"]){
                        [arrayG addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"H"]){
                        [arrayH addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"I"]){
                        [arrayI addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"J"]){
                        [arrayJ addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"K"]){
                        [arrayK addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"L"]){
                        [arrayL addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"M"]){
                        [arrayM addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"N"]){
                        [arrayN addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"O"]){
                        [arrayO addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"P"]){
                        [arrayP addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"Q"]){
                        [arrayQ addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"R"]){
                        [arrayR addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"S"]){
                        [arrayS addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"T"]){
                        [arrayT addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"U"]){
                        [arrayU addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"V"]){
                        [arrayV addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"W"]){
                        [arrayW addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"X"]){
                        [arrayX addObject:dict];
                    }else if([dict[@"letter"] isEqualToString:@"Y"]){
                        [arrayY addObject:dict];
                    }else{
                        [arrayZ addObject:dict];
                    }
                }
                if (arrayA.count >0) {
                    [_allArray addObject:arrayA];
                }
                if (arrayB.count >0) {
                    [_allArray addObject:arrayB];
                }
                if (arrayC.count >0) {
                    [_allArray addObject:arrayC];
                }
                if (arrayD.count >0) {
                    [_allArray addObject:arrayD];
                }
                if (arrayE.count >0) {
                    [_allArray addObject:arrayE];
                }
                if (arrayF.count >0) {
                    [_allArray addObject:arrayF];
                }
                if (arrayG.count >0) {
                    [_allArray addObject:arrayG];
                }
                if (arrayH.count >0) {
                    [_allArray addObject:arrayH];
                }
                if (arrayI.count >0) {
                    [_allArray addObject:arrayI];
                }
                if (arrayJ.count >0) {
                    [_allArray addObject:arrayJ];
                }
                if (arrayK.count >0) {
                    [_allArray addObject:arrayK];
                }
                if (arrayL.count >0) {
                    [_allArray addObject:arrayL];
                }
                if (arrayM.count >0) {
                    [_allArray addObject:arrayM];
                }
                if (arrayN.count >0) {
                    [_allArray addObject:arrayN];
                } if (arrayO.count >0) {
                    [_allArray addObject:arrayO];
                }
                if (arrayP.count >0) {
                    [_allArray addObject:arrayP];
                }
                if (arrayQ.count >0) {
                    [_allArray addObject:arrayQ];
                }
                if (arrayR.count >0) {
                    [_allArray addObject:arrayR];
                }
                if (arrayS.count >0) {
                    [_allArray addObject:arrayS];
                }
                if (arrayT.count >0) {
                    [_allArray addObject:arrayT];
                }
                if (arrayU.count >0) {
                    [_allArray addObject:arrayU];
                }
                if (arrayV.count >0) {
                    [_allArray addObject:arrayV];
                }
                if (arrayW.count >0) {
                    [_allArray addObject:arrayW];
                }
                if (arrayX.count >0) {
                    [_allArray addObject:arrayX];
                }
                if (arrayY.count >0) {
                    [_allArray addObject:arrayY];
                }
                if (arrayZ.count >0) {
                    [_allArray addObject:arrayZ];
                }
                [_tableView reloadData];
        
            }else{
               
                [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
}
             });
        }];
    });
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
        DLog(@"ok");
    }
}


- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    BMKAddressComponent *city = result.addressDetail;
    
   _name = [NSString stringWithFormat:@"%@",city.city];
  
    NSIndexPath *ind=[NSIndexPath indexPathForRow:1 inSection:0 ];
    
    [_tableView reloadRowsAtIndexPaths:@[ind] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
  [[KNToast shareToast]initWithText:@"定位失败，请检查是否打开定位服务!" duration:1.5 offSetY:0];

}
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    DLog(@"heading is %@",userLocation.heading);
}
//tableView右侧数组索引
-(NSArray<NSString *>*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i <_allArray.count; i++) {
        [array addObject:_allArray[i][0][@"letter"]];
    }
    return array;
}
@end
