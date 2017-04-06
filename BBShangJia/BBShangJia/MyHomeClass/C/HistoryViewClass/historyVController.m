//
//  historyVController.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/19.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "historyVController.h"
#import "PublicSouurce.h"
#import "historyAndMoneyTableViewCell.h"
//#import "AHRuler.h"
#import "XBRuleView.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@interface historyVController ()<UITableViewDelegate,UITableViewDataSource,RuleEndScrollDelegate,UIGestureRecognizerDelegate>
{
    int _offset;//分页查询起始值
    int _page_size;//分页大小
    UILabel *showLabel;
    UIImageView *_timeBG;
    Out_historyOrderBody * _model;
    XBRuleView *_ruleView;//刻度尺
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic,strong) UILabel *date;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, strong) NSMutableDictionary *dicData;
@property(nonatomic,strong)NSMutableArray *tmpArray;
@property (nonatomic, strong) NSMutableArray *dayArray;

//@property (nonatomic, strong) Out_historyOrderBody *model;
@property (nonatomic, strong) NSMutableArray *keyArray;
@property(nonatomic,strong)UILabel *label;//刻度尺

@end

@implementation historyVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _offset=0;
    _page_size=10;
    _dataAry = [NSMutableArray array];
    _orders = [NSMutableArray array];
    _dicData=[[NSMutableDictionary alloc]init];
    _keyArray=[NSMutableArray array];
    _dayArray =[[NSMutableArray alloc]init];
    self.view.backgroundColor =  backGroud;
    
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 64, 150, 36)];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 36)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = LargeFont;
        _titleLabel.textColor = TextMainCOLOR;
        _titleLabel.text = @"历史订单";
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleView addSubview:_titleLabel];
    }
    self.navigationItem.titleView = _titleView;
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    [ self.view addSubview:[self initpersonTableView]];
    
    [self getSendOrderList];
    
    [self setupRefresh];
    [self initKeDu];
    [self creactRightGesture];
}
#pragma mark 右滑返回上一级_________
///右滑返回上一级
-(void)creactRightGesture{
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}
-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
    [self leftItemClick];
}
-(void)setDate:(UILabel *)date{
    
    
}
#pragma mark --------------刷新表格-------------------
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _offset=0;
            [self.dataAry removeAllObjects];
            [self.dicData removeAllObjects];
            [self.keyArray removeAllObjects];
            [self getSendOrderList];
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
            
        });
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //进入后自动刷新
    [self.tableView.mj_footer
     beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _offset = _offset+10;
            [self getSendOrderList];
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
            
        });
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}
#pragma mark tableView delegate
//初始化下单table
-(UITableView *)initpersonTableView
{
    if (_tableView != nil) {
        return _tableView;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 10;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT -64-70;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = backGroud;
    _tableView.tag=100;
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
//    if (_dicData.count>0) {
    
//        return [[_dicData allKeys] count];
//    }
    if (_keyArray.count>0){
        return _keyArray.count;
    }
    else{
        return 0;
        //#warning ceshi --------
        //    return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dicData.count>0){
        
//        NSArray *ary=[_dicData objectForKey:_keyArray[section]];
//        return ary.count;
        NSString *dicTmp=_keyArray[section];
        NSArray *tmp=_dicData[dicTmp];
        
        return tmp.count;
    }
    else{
        return 0;
    }
    //#warning ceshi -------------
    //
    //    return _tmpArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    _headerView=[[UIView alloc]init];
    _headerView.backgroundColor = [UIColor whiteColor];
    //    _headerView.backgroundColor=ViewBgColor;
    _headerView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 35);
    //
    _date=[[UILabel alloc]init];
    //
    if ([_dicData allKeys].count > 0) {
        _date.text=_keyArray[section];
        
    }
    //
    
    //#warning ceshi--------------------
    //    _date.text = @"7月26日";
    _date.textAlignment = 1;
    _date.font = LargeFont;
    _date.textColor = [UIColor whiteColor];
    _date.backgroundColor = [UIColor colorWithRed:0.3137 green:0.1882 blue:0.4627 alpha:1.0];
    _date.frame = CGRectMake((SCREEN_WIDTH-100)/2, 10, 100, 26);
    _date.clipsToBounds = YES;
    _date.layer.cornerRadius = 10;
    [_headerView addSubview:self.date];
    
    return _headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    historyAndMoneyTableViewCell *cell=[historyAndMoneyTableViewCell historyTableViewCellWith:tableView indexPath:indexPath msg:nil];
    
    if ([_dicData allKeys].count >0) {
        NSString *dicTmp=_keyArray[indexPath.section];
        NSArray *tmp=_dicData[dicTmp];
        
        _model= [[Out_historyOrderBody alloc]initWithDictionary:tmp[indexPath.row] error:nil];
        
        [cell historySetModel:_model];
    }
    
    
    return cell;
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -----------获取历史订单数据--------------------------
- (void)getSendOrderList{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",_offset],[NSString stringWithFormat:@"%d",_page_size],nil];
    
    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    
    In_historyOrderModel *inModel = [[In_historyOrderModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.offset = [NSString stringWithFormat:@"%d",_offset];
    
    inModel.page_size = [NSString stringWithFormat:@"%d",_page_size];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[communcat sharedInstance]getHistoryOrderlInforWithMsg:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                DLog(@"历史订单数%@",dic);
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                    
                    
                }
                else if (code == 1000){
                    
                    NSArray *data =[dic objectForKey:@"data"];
                    for (int i=0;i< data.count;i++) {
                        NSDictionary *tmp2 =data[i];
                        //如果数组没有值
                        if ([[_dicData allKeys] count]==0) {
                            
                            _orders =[tmp2 objectForKey:@"orders"] ;
                            if ([[tmp2 objectForKey:@"orders"]count ]<=0) {
                                return ;
                            }
                            [_dicData setValue:[tmp2 objectForKey:@"orders"] forKey:[tmp2 objectForKey:@"date"]];
                            [_keyArray addObject:[tmp2 objectForKey:@"date"]];
                            //                                    挑选日期
                            for (NSDictionary *everyData in data) {
                                NSString *time=everyData[@"date"] ;
                                if (![self.dayArray containsObject:time])
                                {
                                    [self.dayArray addObject:time];
                                }
                            }
                            
                        }
                        else{
                            if ([[tmp2 objectForKey:@"orders"] count]<=0) {
                                return ;
                            }
                            if ([[_dicData allKeys] containsObject:[tmp2 objectForKey:@"date"]]) {
                                NSArray *tmpAry=[_dicData objectForKey:[tmp2 objectForKey:@"date"]];
                                NSArray *temAry2 = [tmp2 objectForKey:@"orders"];
                                NSMutableArray *ary=[[NSMutableArray alloc]init];
                                [ary addObjectsFromArray:tmpAry];
                                [ary addObjectsFromArray:temAry2];
                                [_dicData setValue:ary forKey:[tmp2 objectForKey:@"date"]];
                                
                            }else{//不包含Key
                                [_dicData setValue:[tmp2 objectForKey:@"orders"] forKey:[tmp2 objectForKey:@"date"]];
                                
                                if (![_keyArray containsObject:[tmp2 objectForKey:@"date"]]){
                                    [_keyArray addObject:[tmp2 objectForKey:@"date"]];
                                }
                            }
                            
                            //挑选日期
                            for (NSDictionary *everyData in data) {
                                DLog(@"笨笨狗%@",everyData);
                                NSString *time=everyData[@"date"];
                                if (![self.dayArray containsObject:time])
                                {
                                    [self.dayArray addObject:time];
                                }
                            
                            
                            
                        }
                        for (NSDictionary *everyData in data) {//挑选日期
                            NSString *time=everyData[@"date"] ;
                            if (![self.dayArray containsObject:time])
                            {
                                [self.dayArray addObject:time];
                            }
                        }
                    
                 
                            
                        }
                    }
                    DLog(@"lishiding历史订单的时间%@",_dayArray);
                    if (_dayArray.count>0){
                        [self initKeDu];
                        
                        [_tableView reloadData];
                        
                    }
                }
                else{
                    [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                    
                }
                
            } );
            
        }];
    });
    
    
}

#pragma mark 初始化刻度尺
-(void)initKeDu{
    if (_dayArray.count<=0) {
        return;
    }
    
    NSMutableArray *tmpAry=[NSMutableArray arrayWithCapacity:0];
    for (NSString *tmpDate in _dayArray) {
        NSString *str1=[tmpDate stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
        NSString *str2=[str1 stringByReplacingOccurrencesOfString:@"日" withString:@""];
        
        [tmpAry addObject:str2];
    }
    
    if (_ruleView){
        [_ruleView removeFromSuperview];
    }
    _ruleView = [[XBRuleView alloc]initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height-70-64, [UIScreen mainScreen].bounds.size.width - 40, 70)];
    _ruleView.delegate = self;
    _ruleView.backgroundColor = [UIColor clearColor];
    _ruleView.textColor = TextMainCOLOR;
    _ruleView.textFont = [UIFont systemFontOfSize:15];
    _ruleView.longSymbolHeight = 40;
    _ruleView.dalist=[NSMutableArray arrayWithCapacity:0];
    
    [_ruleView.dalist addObjectsFromArray: tmpAry];
    
    NSMutableArray *arrayDate = [NSMutableArray array];
    for (int i = 0; i <= 45; i++) {
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60*(45 -i)sinceDate:currentDate ];//前一天
        NSString *dateString = [dateFormatter stringFromDate:lastDay];
        if ([[dateString substringToIndex:1] isEqualToString:@"0"]) {
            dateString = [dateString substringFromIndex:1];
        }
        [arrayDate addObject:dateString];
        
    }
    NSInteger index = [arrayDate indexOfObject:[tmpAry firstObject]];
    
    [ _ruleView setRangeFrom:0 to:45 minScale:1 minScaleWidth:10];
    _ruleView.currentValue = index;
    
    [self.view addSubview: _ruleView];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height,2, 70)];
    view.backgroundColor = [UIColor purpleColor];
    view.center =  _ruleView.center;
    [self.view addSubview:view];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    
}

#pragma mark ---------滑动时候的代理------
-(void)ruleEndScroll:(int)index scroll:(UIScrollView *)scrollView;
{
    if (scrollView.tag==100) {
        
    }else{
        NSMutableArray *arryTmp=[NSMutableArray arrayWithCapacity:0];
        for (NSString *tmpDate in _dayArray) {
            
            NSString *str1=[tmpDate stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
            NSString *str2=[str1 stringByReplacingOccurrencesOfString:@"日" withString:@""];
            
            [arryTmp addObject:str2];
        }
        
        NSMutableArray *arrayDate=[NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i <= 45; i++) {
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd"];
            NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60*(45 -i)sinceDate:currentDate ];//前一天
            NSString *dateString = [dateFormatter stringFromDate:lastDay];
            if ([[dateString substringToIndex:1] isEqualToString:@"0"]) {
                dateString = [dateString substringFromIndex:1];
            }
            [arrayDate addObject:dateString];
            
        }
        NSString *dateSelct = arrayDate[index];
        for (int indeXX = 0; indeXX<arryTmp.count; indeXX++) {
            if ([arryTmp[indeXX] isEqualToString:dateSelct]) {
                NSIndexPath * scrollIndex= [NSIndexPath indexPathForRow:0 inSection:indeXX];
                [_tableView scrollToRowAtIndexPath:scrollIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    }
}

-(void)ruleEndScrollWithOutRusult;
{
//    _offset = _offset+10;
//
//    [self getSendOrderList];
}

@end
