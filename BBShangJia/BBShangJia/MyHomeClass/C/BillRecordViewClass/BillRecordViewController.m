//
//  BillRecordViewController.m
//  BBShangJia
//
//  Created by 李志明 on 16/9/27.
//  Copyright © 2016年 CYT. All rights reserved.
//
#import "PayViewController.h"//支付界面

#import "BillRecordViewController.h"
#import "PublicSouurce.h"
#import "BillRecordViewCell.h"
#import "billRecordViewModel.h"
#define normalColor [UIColor colorWithRed:0.5333 green:0.4588 blue:0.6471 alpha:1.0]
#define whiteColor [UIColor whiteColor]
@interface BillRecordViewController ()<UITableViewDelegate,UITableViewDataSource,billRecrdViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *_totalOrderArray;
    NSArray *_searchData;
    NSMutableArray *_filterData;
    UIButton *_searchBtn;
    int _btnMove;//扫码搜索按钮移动
    int _pageIndex;//分页大小
    int _type;//当前类型
    float lastContentOffset;
    
    /**
     *  送货列表请求网络参数
     */
    int _status;//0全部 1待付款 2待接单 3已接单
    int _offset;//分页查询起始值
    int _page_size;//分页大小
    NSString *_word;//模糊查询字段
    NSString *_word_scan;//模糊查询字段
    
    /**
     *  存储配送状态
     */
    int _sending_count;//配送中订单量
    int _expt_count;//异常件数量
    int _sign_count;//已签收数量
}

@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UITableView *goodsTableview;
@property(nonatomic,strong)NSMutableArray *dataList;
@property (nonatomic, strong) NSDate *date;

///头部类型选择按钮view
@property (nonatomic, strong) UIView *headView;
@property(nonatomic,strong)UIButton *allBtn;//全部
@property (nonatomic, strong) UIButton *obligationBtn;//待付款
@property (nonatomic, strong) UIButton *delayBtn;//待接单
@property(nonatomic,strong)UIButton *distributionBtn;//配送中
//@property (nonatomic, strong) UIButton *finishBtn;

@property(nonatomic,strong)billRecordViewModel *viewModel;
@end

@implementation BillRecordViewController

-(billRecordViewModel*)viewModel{
    if (!_viewModel) {
        _viewModel = [[billRecordViewModel alloc] init];
        _viewModel.subject = [RACSubject subject];
        [_viewModel.subject subscribeNext:^(id x) {
            [self.dataList removeAllObjects];
            [self getSendOrderList];
        }];
    }
    return _viewModel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroud;
    _offset = 0;
    _page_size=10;
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 0, 150, 36)];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 36)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = LargeFont;
        _titleLabel.textColor = TextMainCOLOR;
        _titleLabel.text = @"发单记录";
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleView addSubview:_titleLabel];
    }
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    [self initWithSubViews];
    [self inithomeTableView];
    [self assignment];
    [self setupRefresh];//刷新
    [self allBtnClick];
    self.navigationItem.titleView = _titleView;
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
#pragma mark -----------刷新----------------------
- (void)setupRefresh
{
    self.goodsTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.dataList removeAllObjects];
            
            _offset = 0;
            [self getSendOrderList];

            // 结束刷新
            [self.goodsTableview.mj_header endRefreshing];
            
        });
    }];
    
    //进入后自动刷新
    [self.goodsTableview.mj_footer
     beginRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.goodsTableview.mj_header.automaticallyChangeAlpha = YES;
    self.goodsTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _offset = _offset +10;
            [self getSendOrderList];

            
            // 结束刷新
            [self.goodsTableview.mj_footer endRefreshing];
            
        });
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.goodsTableview.mj_footer.automaticallyChangeAlpha = YES;
}
-(void)initWithSubViews{
    //加载头部选择功能
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 55)];
        _headView.backgroundColor = MainColor;
        [self.view addSubview:_headView];
    }
    //全部
    if(!_allBtn){
        _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allBtn.frame = CGRectMake(10, 10, (SCREEN_WIDTH-60)/4, 30);
//        [_allBtn setTitleColor:whiteColor forState:UIControlStateSelected];
        [_allBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [_allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _allBtn.titleLabel.font = LittleFont;
        _allBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _allBtn.layer.cornerRadius=10;
        _allBtn.clipsToBounds=YES;
        [_headView addSubview:_allBtn];
    }
    
    //待付款
    if (!_obligationBtn) {
        _obligationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_obligationBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [_obligationBtn addTarget:self action:@selector(obligationBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _obligationBtn.frame = CGRectMake(_allBtn.x+_allBtn.width+10, 10, (SCREEN_WIDTH-60)/4, 30);
        _obligationBtn.titleLabel.font = LittleFont;
        _obligationBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _obligationBtn.layer.cornerRadius=10;
        _obligationBtn.clipsToBounds=YES;
        [_headView addSubview:_obligationBtn];
    }
    //待接单
    if (!_delayBtn) {
        _delayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delayBtn setTitleColor:normalColor forState:UIControlStateNormal];
        
        [_delayBtn addTarget:self action:@selector(delayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _delayBtn.frame = CGRectMake(_obligationBtn.x+_obligationBtn.width+10,10, (SCREEN_WIDTH-60)/4, 30);
        _delayBtn.titleLabel.font = LittleFont;
        _delayBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _delayBtn.layer.cornerRadius=10;
        _delayBtn.clipsToBounds=YES;
        [_headView addSubview:_delayBtn];
    }
    //已接单
    if (!_distributionBtn) {
        _distributionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _distributionBtn.frame = CGRectMake(_delayBtn.x +_delayBtn.width +10, 10, (SCREEN_WIDTH-60)/4, 30);
        [_distributionBtn setTitleColor:normalColor forState:UIControlStateNormal];
        
        [_distributionBtn addTarget:self action:@selector(distributionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _distributionBtn.titleLabel.font = LittleFont;
        _distributionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _distributionBtn.layer.cornerRadius=10;
        _distributionBtn.clipsToBounds=YES;
        [_headView addSubview:_distributionBtn];
    }
   }

//初始化tableView
-(void)inithomeTableView
{
    _dataList = [NSMutableArray array];
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 55.0;
    rect.size.width = self.view.frame.size.width;
    rect.size.height = self.view.frame.size.height-119;
    self.goodsTableview = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    self.goodsTableview.delegate = self;
    self.goodsTableview.dataSource = self;
    self.goodsTableview.backgroundColor = backGroud;
    self.goodsTableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.goodsTableview];
    
}

-(void)assignment{
    
    [_allBtn setTitle:@"全部" forState:UIControlStateNormal];  //1全部
    [_allBtn setBackgroundImage:[[communcat sharedInstance]createImageWithColor:whiteColor] forState:UIControlStateSelected];
    [_obligationBtn setTitle:@"待付款" forState:UIControlStateNormal];//2.待付款
    [_obligationBtn setBackgroundImage:[[communcat sharedInstance]createImageWithColor:whiteColor] forState:UIControlStateSelected];

    [_delayBtn setTitle:@"待接单" forState:UIControlStateNormal];//3.待接单
    [_delayBtn setBackgroundImage:[[communcat sharedInstance]createImageWithColor:whiteColor] forState:UIControlStateSelected];

    [_distributionBtn setTitle:@"已接单" forState:UIControlStateNormal];//4.配送中
    [_distributionBtn setBackgroundImage:[[communcat sharedInstance]createImageWithColor:whiteColor] forState:UIControlStateSelected];

    //    [_finishBtn setTitle:@"已完成" forState:UIControlStateNormal];//5.已完成
}

#pragma mark 全部按钮
-(void)allBtnClick{
    [self.dataList removeAllObjects];
    _allBtn.selected = YES;
    _distributionBtn.selected = NO;
    _obligationBtn.selected = NO;
    _delayBtn.selected = NO;
    //    _finishBtn.selected = NO;
    _status=0;
    _offset = 0;
    _page_size=10;
    [self getSendOrderList];
}

#pragma mark 待付款
- (void)obligationBtnClick
{
    [self.dataList removeAllObjects];
    _obligationBtn.selected = YES;
    _delayBtn.selected = NO;
    //    _finishBtn.selected = NO;
    _distributionBtn.selected = NO;
    _allBtn.selected = NO;
    _status=1;
    _offset = 0;
    _page_size=10;
    [self getSendOrderList];
    

}


#pragma mark 待接单
- (void)delayBtnClick
{
    [self.dataList removeAllObjects];
    _delayBtn.selected = YES;
    _obligationBtn.selected = NO;;
    //    _finishBtn.selected = NO;
    _distributionBtn.selected = NO;
    _allBtn.selected = NO;
    _status=2;
    _offset = 0;
    _page_size=10;
    [self getSendOrderList];
    
}

#pragma mark 已接单
-(void)distributionBtnClick{
    [self.dataList removeAllObjects];

    _distributionBtn.selected = YES;
    _obligationBtn.selected = NO;
    _delayBtn.selected = NO;
    //    _finishBtn.selected = NO;
    _allBtn.selected = NO;
    _status=3;
    _offset = 0;
    _page_size=10;
    [self getSendOrderList];
    
}


#pragma  mark -------tableView delegate-------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataList count];
    //#warning ceshi
    //
    //    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataList.count>0){
        
        Out_billRecordBody *model=[ [Out_billRecordBody alloc]initWithDictionary:self.dataList[indexPath.section] error:nil];
        if ([model.status isEqualToString:@"4"] || [model.status isEqualToString:@"3"] ){
            return 200;
        }else{
            return 134;
            
        }
    }
    return 0.01;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"identifier";
    BillRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (self.dataList.count>0){
        Out_billRecordBody *model=[ [Out_billRecordBody alloc]initWithDictionary:self.dataList[indexPath.section] error:nil];
        
        if ([model.status isEqualToString:@"4"]){
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BillRecordViewCell" owner:self options:nil] lastObject];
            }
            cell.upSubject = [RACSubject subject];
            
            [cell.upSubject subscribeNext:^(id x) {
                
                dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    [self.dataList removeAllObjects];
                    [self getSendOrderList];//刷新数据
                });
               
            }];
            
            cell.delegate=self;
            [cell setNoPayCellModel:model index:(int)indexPath.section date:_date];
            
        }else if([model.status isEqualToString:@"3"]){
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BillRecordViewCell" owner:self options:nil] lastObject];
                
            }
            [cell setNoPayCellModel:model index:(int)indexPath.section date:nil];
            cell.subject = [RACSubject subject];
            [cell.subject subscribeNext:^(id x) {
                [self.viewModel.cancellCommand execute:model.requirment_id];//订单号
            }];
        }else{
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BillRecordViewCell" owner:self options:nil] firstObject];
            }
            [cell setCellModel:model];
        }

    }else{
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BillRecordViewCell" owner:self options:nil] firstObject];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

//左侧按钮点击
-(void)leftItemClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -----------获取发单列表列表--------------------------
- (void)getSendOrderList{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",_status],[NSString stringWithFormat:@"%d",_offset],[NSString stringWithFormat:@"%d",_page_size],nil];
    
    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    
    In_sendGoodsModel *inModel = [[In_sendGoodsModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.status = [NSString stringWithFormat:@"%d",_status];
    inModel.offset = [NSString stringWithFormat:@"%d",_offset];
    inModel.page_size = [NSString stringWithFormat:@"%d",_page_size];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] getBillRecordListWithMsg:inModel date:^(NSDate *outDate) {
            _date = outDate;
            
        } resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                DLog(@"发单记录%@",dic);
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                    
                }else if (code == 1000){
                 
                    NSArray *array = dic[@"data"];
                  
                    for(NSDictionary*dic in array){
                        
                        if (![_dataList containsObject:dic]) {
                            
                            [self.dataList addObject:dic];
                            
                        }
                    }
                    
                    
                    [self.goodsTableview reloadData];
                    
                }else{
                    [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                    
                }
                DLog(@"modeldata%@",[dic objectForKey:@"message"]);
            } );
        }];

    });
}
#pragma mark  待支付订单去支付
-(void)billRecordGoAlipyClick:(UIButton *)btn;
{
    if (self.dataList.count>0){
        in_senderOrderModel *InModel = [[ in_senderOrderModel alloc]init];

        Out_billRecordBody *model=[ [Out_billRecordBody alloc]initWithDictionary:self.dataList[btn.tag] error:nil];
        PayViewController *VC = [[PayViewController alloc] init];
        VC.money=[model.price floatValue]/1.05;
        VC.numble=[model.order_amount intValue];
        VC.requirment_name=model.grid_name;
       VC.requirment_type=model.requirment_type;
    
        VC.requirment_id=model.requirment_id;
        VC.kind=2;
        
        InModel.commission=[NSString stringWithFormat:@"%.2f",[model.price floatValue]];
        //        VC.=model.grid_name;
       InModel.requirment_type=model.requirment_type;
       InModel.order_amount=model.order_amount;
//        VC.=model.grid_name;
        VC.InModel=InModel;

        self.hidesBottomBarWhenPushed = YES;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.1;
        transition.type = @"fade";//翻转
        transition.subtype = kCAGravityTopLeft;
        [[UIApplication sharedApplication].delegate.window.layer addAnimation:transition forKey:@"transition"];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    
}
@end
