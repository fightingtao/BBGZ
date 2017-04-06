//
//  billVController.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/19.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "billVController.h"
#import "PublicSouurce.h"
#import "historyAndMoneyTableViewCell.h"

//#import "AHRuler.h"
#import "XBRuleView.h"

#define HOMECOLOR [UIColor colorWithRed:53/255.0 green:153/255.0 blue:54/255.0 alpha:1]
#define degreesToRadian(x) (M_PI * (x) / 180.0)
@interface billVController ()<UITableViewDelegate,UITableViewDataSource,RuleEndScrollDelegate,UIGestureRecognizerDelegate>
{
    int _offset;//分页查询起始值
    int _page_size;//分页大小
    NSMutableArray *_array;
    UILabel *showLabel;
    UIImageView *_timeBG;
    XBRuleView *_ruleView;//刻度尺
    
}
@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *date;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) NSMutableArray *bills;
@property (nonatomic, strong) NSMutableDictionary *dicData;
@property (nonatomic, strong) NSMutableArray *dayArray;

@property (nonatomic, strong) NSMutableArray *orders;

@property (nonatomic, strong) NSMutableArray * keyArray;

//@property (nonatomic, strong) Out_billStreamBody *model;
@property(nonatomic,strong)NSMutableArray *tmpArray;
@property(nonatomic,strong)UILabel *label;//刻度尺
@end

@implementation billVController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ self.view addSubview:[self initpersonTableView]];
    self.view.backgroundColor = backGroud;
    
    _offset=0;
    _page_size=10;
    
    _dataAry=[[NSMutableArray alloc]init];
    
    _keyArray=[[NSMutableArray alloc]init];
    
    _dicData=[[NSMutableDictionary alloc]init];
    _dayArray=[[NSMutableArray alloc]init];
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 64, 150, 36)];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 36)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = LargeFont;
        _titleLabel.textColor = TextMainCOLOR;
        _titleLabel.text = @"账单";
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
    [self getSendOrderList];
    [self setupRefresh];
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
            //            [self.dataAry removeAllObjects];
            [self.dicData removeAllObjects];
            [self.keyArray removeAllObjects];
            _offset = 0;
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
            _offset = _offset +10;
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
    rect.origin.y = 0.0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT-64-70;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = backGroud;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tag=100;
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dicData.count>0) {
        
        return [[_dicData allKeys] count];
    }
    return 0;
    
    //    return 1;
}

#pragma mark 初始化刻度尺
-(void)initKeDu{
    if (_dayArray.count<=0) {
        return;
    }
    //  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    //    [dateFormatter setDateFormat:@"MM-dd"];
    
    NSMutableArray *tmpAry=[NSMutableArray arrayWithCapacity:0];
    for (NSString *tmpDate in _dayArray) {
        //        NSDate *date2=[dateFormatter dateFromString:tmpDate];
        //        NSString *time=[dateFormatter stringFromDate:date2];
        
        NSString *str1=[tmpDate stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
        NSString *str2=[str1 stringByReplacingOccurrencesOfString:@"日" withString:@""];
        if ([[str2 substringToIndex:1] isEqualToString:@"0"]) {
            str2 = [str2 substringFromIndex:1];
        }
        [tmpAry addObject:str2];
    }
    
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
    
    if (!_ruleView) {
        _ruleView = [[XBRuleView alloc]initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height-70-64, [UIScreen mainScreen].bounds.size.width - 40, 60)];
        _ruleView.delegate = self;
        _ruleView.backgroundColor = [UIColor clearColor];
        _ruleView.textColor = TextMainCOLOR;
        _ruleView.textFont = [UIFont systemFontOfSize:15];
        _ruleView.longSymbolHeight = 40;
        _ruleView.dalist=[NSMutableArray arrayWithCapacity:0];
        
        
    }
    [_ruleView.dalist addObjectsFromArray: tmpAry];
    [ _ruleView setRangeFrom:0 to:45 minScale:1 minScaleWidth:10];
    _ruleView.currentValue = index;
    
    
    [self.view addSubview: _ruleView];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height,2, 70)];
    view.backgroundColor = [UIColor purpleColor];
    view.center =  _ruleView.center;
    [self.view addSubview:view];
    
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    
    
    
}
-(void)ruleEndScroll:(int)index scroll:(UIScrollView *)scrollView;
{
    if (scrollView.tag==100) {
        
    }
    else{
        NSMutableArray *tmpAry=[NSMutableArray arrayWithCapacity:0];
        for (NSString *tmpDate in _dayArray) {
            
            NSString *str1=[tmpDate stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
            NSString *str2=[str1 stringByReplacingOccurrencesOfString:@"日" withString:@""];
            
            [tmpAry addObject:str2];
        }
        
        NSMutableArray *   timeArray =[[NSMutableArray array]init];
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        
        for (int i = 0; i <= 45 ; i++) {
            NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60*i sinceDate:currentDate ];//前一天
            NSString *dateString = [dateFormatter stringFromDate:lastDay];
            [timeArray addObject:dateString];
        }
        
        for (int i=0;i<_keyArray.count;i++){
            NSString *time11 =timeArray[45-index];
            NSString *keystr=_keyArray[i];//key 索引
            for (NSDictionary *shijianDic in _dicData[keystr]) {
                
                NSString *bendiTime=[shijianDic[@"trade_time"] substringWithRange:NSMakeRange(5, 5)];
                if ([time11 isEqualToString:bendiTime] ) {
                    [_dicData[keystr] indexOfObject:shijianDic];
                    
                    NSIndexPath *index22=[NSIndexPath indexPathForRow:[_dicData[keystr] indexOfObject:shijianDic] inSection:i];
                    [_tableView scrollToRowAtIndexPath:index22 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    break;
                }
                
            }
        }
        
    }
}
-(void)ruleEndScrollWithOutRusult;
{
//        _offset = _offset+10;
////
//        [self getSendOrderList];
    DLog(@"结束的美术家");
//    [self.tableView.mj_footer
//     beginRefreshing];
    }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *ary=[_dicData objectForKey:_keyArray[section]];
    return ary.count;
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    _headerView = [[UIView alloc]init];
    _headerView.backgroundColor = backGroud;
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    
    _date = [[UILabel alloc]init];

    _date.text = _keyArray[section];
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
    historyAndMoneyTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"historyAndMoneyTableViewCell" owner:self options:nil] objectAtIndex:1];
    
    if (_dicData.count>0) {
        
        NSString *key=_keyArray[indexPath.section];
        NSArray *dataTmp=[_dicData objectForKey:key];
        Out_billStreamBody * model= [[Out_billStreamBody alloc]initWithDictionary:dataTmp[indexPath.row] error:nil];
        
        [cell billSetModel:model];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark -----------获取账单流水--------------------------
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
    
    In_sendGoodsModel *inModel = [[In_sendGoodsModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.offset = [NSString stringWithFormat:@"%d",_offset];
    inModel.page_size = [NSString stringWithFormat:@"%d",_page_size];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[communcat sharedInstance]getBillListWithMsg:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                DLog(@"列表数据账单%@",dic);
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                }else if (code == 1000){
                    NSArray *data =[dic objectForKey:@"data"];
                    for (NSDictionary *tmp2 in data) {
                        if ([[_dicData allKeys] count]==0) {
                            [_dicData setValue:[tmp2 objectForKey:@"bills"] forKey:[tmp2 objectForKey:@"month"]];
                         //   [_keyArray addObject:[tmp2 objectForKey:@"month"]];
                            [_keyArray insertObject:[tmp2 objectForKey:@"month"] atIndex:0];
                            if ([[tmp2 objectForKey:@"bills"] count]<=0) {
                                return ;
                            }
                            //                                    挑选日期
                            for (NSDictionary *everyData in [tmp2 objectForKey:@"bills"]) {
                                
                                //                                        NSString *time=everyData[@"trade_time"];
                                NSString *time=[everyData[@"trade_time"] substringWithRange:NSMakeRange(5, 5)];
                                if (![self.dayArray containsObject:time])
                                {
                                    DLog(@"shijian time %@",time);
                                    [self.dayArray addObject:time];
                                }
                            }
                        }else{
                            if ([[tmp2 objectForKey:@"bills"] count]<=0) {
                                return ;
                            }
                            for (NSString *key in [_dicData allKeys]) {
                                
                                if ([[tmp2 objectForKey:@"month"] isEqualToString:key]) {
                                    NSArray *tmpAry=[_dicData objectForKey:key];
                                    NSArray *temAry2=[tmp2 objectForKey:@"bills"];
                                    NSMutableArray *ary=[[NSMutableArray alloc]init];
                                    [ary addObjectsFromArray:tmpAry];
                                    [ary addObjectsFromArray:temAry2];
                                    [_dicData setValue:ary forKey:key];
                                    
//                                    挑选日期
                                    for (NSDictionary *everyData in ary) {
                                        
//                                        NSString *time=everyData[@"trade_time"];
                                       NSString *time=[everyData[@"trade_time"] substringWithRange:NSMakeRange(5, 5)];
                                        if (![self.dayArray containsObject:time])
                                        {
                                        [self.dayArray addObject:time];
                                    }
                                    }
                                }
                                else{
                                    [_dicData setValue:[tmp2 objectForKey:@"bills"] forKey:[tmp2 objectForKey:@"month"]];
                                    if (![_keyArray containsObject:[tmp2 objectForKey:@"month"]]){
                                    //    [_keyArray addObject:[tmp2 objectForKey:@"month"]];
                                        [_keyArray insertObject:[tmp2 objectForKey:@"month"] atIndex:0];

                                    }
                                    //                                    挑选日期
                                    for (NSDictionary *everyData in [tmp2 objectForKey:@"bills"]) {
                                        
                                        //                                        NSString *time=everyData[@"trade_time"];
                                        NSString *time=[everyData[@"trade_time"] substringWithRange:NSMakeRange(5, 5)];
                                        if (![self.dayArray containsObject:time])
                                        {
                                            [self.dayArray addObject:time];
                                        }
                                    }

                                }
                                
                            }
                            
                        }
                    }
//                    DLog(@"生成刻度尺的时间数组%@",self.dayArray[0]);
//                    DLog(@"生成刻度尺的时间数组%@",_keyArray[0]);
                    if (_dicData.count>0){
                        [self initKeDu];

                        [_tableView reloadData];
                        
                    }
                }else{
                    [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                    
                }
                DLog(@"modeldata%@",[dic objectForKey:@"message"]);
            } );
        }];
    });
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
