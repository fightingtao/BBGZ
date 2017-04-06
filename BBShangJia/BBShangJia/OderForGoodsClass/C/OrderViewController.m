//
//  LSendGoodsViewController.m
//  CYZhongBao
//
//  Created by xc on 16/1/25.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "OrderViewController.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
#import "ApplyBrokerViewController.h"//去认证详情

#import "OrderTableViewCell.h"
#import "DimChectViewController.h"
#import "detialViewController.h"
#define sendOrderListCell @"sendOrderListCell"
#define normalColor [UIColor colorWithRed:0.5333 green:0.4588 blue:0.6471 alpha:1.0]
#define whiteColor [UIColor whiteColor]


@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,telePhoneBtnClickDelegate,UIAlertViewDelegate,ScannerGoodsDelegate>
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
    int _status;//1待抢单 2已完成 3异常件
    int _offset;//分页查询起始值
    int _page_size;//分页大小
    NSString *_word;//模糊查询字段
    NSString *_word_scan;//模糊查询字段 扫描
    
    /**
     *  存储配送状态
     */
    int _sending_count;//配送中订单量
    int _expt_count;//异常件数量
    int _sign_count;//已完成数量
}

@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UITextField *searchText;
@property (nonatomic, strong) UITableView *goodsTableview;
@property(nonatomic,strong)NSMutableArray *dataList;
@property (nonatomic,strong)  UIAlertView *approve;//去雇主认证


///头部类型选择按钮view
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIButton *sendIngBtn;
@property (nonatomic, strong) UIButton *alreadySendBtn;
@property (nonatomic, strong) UIButton *problemBtn;


@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIImageView *searchImgview;
@property (nonatomic, strong) UIButton *scannerBtn;
@property (nonatomic,strong ) Out_sendGoodsBody *model;

@end

@implementation OrderViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel;
    if (data && data.length>0){
        
        userInfoModel   = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
    }
    ///判断请登录
    if (userInfoModel.key.length==0||[userInfoModel.key isEqualToString:@""]||!userInfoModel.key){
        //        [[KNToast shareToast]initWithText:@"您还没有登录,请登录!" duration:1.5 offSetY:0];
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    if ([userInfoModel.user_status isEqualToString:@"0"]){
        [[KNToast shareToast]initWithText:@"您的账号已被冻结!" duration:1.5 offSetY:0];
        
        return;
        
    }
    if (![userInfoModel.user_type isEqualToString:@"1"]){
        
        if ([userInfoModel.authen_status isEqualToString:@"-1"]||[userInfoModel.authen_status isEqualToString:@"2"]){
            _approve=[[UIAlertView alloc]initWithTitle:@"用户提示" message:@"经过雇主认证之后就可以赚钱了!" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"马上去", nil];
            [_approve show];
            return;
            
        }
        
    }
    
    if (_word_scan.length==0||!_word_scan||[_word_scan isEqualToString:@""]) {
       // [self button1Click];
        
    }
 
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _word_scan=@"";
    //[self.dataList removeAllObjects];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =  whiteColor;
    self.navigationItem.title = @"我的订单";
    
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    
    [self initWithSubViews];
    [self inithomeTableView];
    [self assignment];
    
   [self button1Click];
    self.navigationItem.titleView = _titleView;
    [self setupRefresh];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(outLoginDoit:) name:@"login-out" object:nil];
}
-(void)outLoginDoit:(NSNotification *)notif{
    [self.dataList removeAllObjects];
    [self assignment];
    
    if (_goodsTableview) {
        [_goodsTableview reloadData];
    }
}
-(void)notifChange:(NSNotification*) notification
{
    _word_scan= [notification object];//通过这个获取到传递的对象
    _offset = 0;
    _page_size = 10;
    _word = [notification object];
    [self.dataList removeAllObjects];
    [self getSendOrderList];
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark ------------模糊查询-------------
-(void)getOrder_id:(NSString *)order_id{
    _word_scan = order_id;
    _offset = 0;
    _page_size = 10;
    _word = _word_scan;
    [self.dataList removeAllObjects];
    [self getSendOrderList];
}

//初始化tableView
-(void)inithomeTableView
{
    _dataList = [NSMutableArray array];
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 100.0;
    rect.size.width = self.view.frame.size.width;
    rect.size.height = self.view.frame.size.height-164-49;
    
    self.goodsTableview = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    self.goodsTableview.delegate = self;
    self.goodsTableview.dataSource = self;
    self.goodsTableview.backgroundColor =  [UIColor colorWithRed:0.9608 green:0.9608 blue:0.9608 alpha:1.0];
 
    [self.view addSubview:self.goodsTableview];
    
}

#pragma  mark -------tableView delegate-------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataList.count;
    
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
    
    if (_searchBtn.isSelected==YES){
        return 160;
    }
    else if (_alreadySendBtn.isSelected==YES){
        return 170;
    }
    else if (_problemBtn.isSelected==YES){
        return 200;
    }
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *identifier = @"cell";//对应xib中设置的
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (_sendIngBtn.isSelected==YES){//配送中
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil]  objectAtIndex:1];
            cell.signLabel.hidden = YES;
        }
        if(self.dataList.count >0){
            NSDictionary *dic = self.dataList[indexPath.section];
            _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
        }
        [cell setModel:_model];
        cell.delegate=self;
        cell.startView.hidden = NO;
        cell.startLabel.hidden = NO;
        cell.gradeLabel.hidden = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (_alreadySendBtn.isSelected==YES){//已完成
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil]  objectAtIndex:1];
            cell.signLabel.hidden = YES;
        }
        if(self.dataList.count >0){
            NSDictionary *dic = self.dataList[indexPath.section];
            _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
        }
        [cell setCell2Model:_model];
        cell.delegate = self;
        cell.startView.hidden = YES;
        cell.startLabel.hidden = YES;
        cell.gradeLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (_problemBtn.isSelected==YES){
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil]  objectAtIndex:2];
            cell.signLabel.hidden = YES;
        }
        if(self.dataList.count >0){
            NSDictionary *dic = self.dataList[indexPath.section];
            _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
        }
        [cell setCell3Model:_model];
        cell.delegate=self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
#pragma mark ------------tableViewSelect------------------

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( self.dataList.count >0) {
    
    NSDictionary *dic = self.dataList[indexPath.section];
    _model = [[Out_sendGoodsBody alloc]initWithDictionary:dic error:nil];
    
    detialViewController *vc = [[detialViewController alloc] init];
    vc.order_id=_model.order_original_id;
    [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark 打电话
-(void)callTelePhone:(NSString *)phone;
{
    if (phone.length>0){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
    else{
        [[KNToast shareToast]initWithText:@"抱歉!无法获取电话信息" duration:1.5 offSetY:0];
    }
}


-(void)backBtnClick:(NSString*)status{
    
    if ([status isEqualToString:@"1"]) {
        [self button1Click];
        
    }else if ([status isEqualToString:@"2"]){
        [self button2Click];
    }else{
        [self button3Click];
    }
    
}


//已完成按钮点击
- (void)button1Click
{
    [self.dataList removeAllObjects];
    _offset = 0;
    _page_size = 10;
    _status = 1;
    _word = @"";
    _sendIngBtn.selected = YES;
    _alreadySendBtn.selected = NO;
    _problemBtn.selected = NO;
    
//    [_sendIngBtn setBackgroundColor:whiteColor];
    [self getSendOrderList];
}

//已签收按钮点击
#pragma mark-----------已签收----------------
- (void)button2Click
{
     [self.dataList removeAllObjects];
     _offset = 0;
     _page_size = 10;
     _status = 2;
     _word = @"";
     _sendIngBtn.selected = NO;;
     _alreadySendBtn.selected = YES;
     _problemBtn.selected = NO;
    
    [self getSendOrderList];
 }

//异常件按钮点击
#pragma mark ------------异常件------------
- (void)button3Click
{
    [self.dataList removeAllObjects];
    _offset = 0;
    _page_size = 10;
    _status = 3;
    _word = @"";
    [self getSendOrderList];
    _sendIngBtn.selected = NO;;
    _alreadySendBtn.selected = NO;;
    _problemBtn.selected = YES;
//    [_problemBtn setBackgroundColor:whiteColor];
}

#pragma mark -----------获取送货列表--------------------------
- (void)getSendOrderList{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    
    NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",_status],[NSString stringWithFormat:@"%d",_offset],[NSString stringWithFormat:@"%d",_page_size],[NSString stringWithFormat:@"%@",_word],nil];
    
    NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
    In_sendGoodsModel *inModel = [[In_sendGoodsModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.status = [NSString stringWithFormat:@"%d",_status];
    inModel.offset = [NSString stringWithFormat:@"%d",_offset];
    inModel.page_size = [NSString stringWithFormat:@"%d",_page_size];
    inModel.word = [NSString stringWithFormat:@"%@",_word];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[communcat sharedInstance] sendGoodsListWithMsg:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                DLog(@"woe我的订单 列表数据%@",dic);
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                }
                else if (code == 1000){
                    _sending_count = [dic[@"data"][@"deliving_cnt"] intValue];
                    _expt_count = [dic[@"data"][@"expt_cnt"] intValue];
                    
                    _sign_count = [dic[@"data"][@"finished_cnt"] intValue];
                    //1.
                    [_sendIngBtn setTitle:[NSString stringWithFormat:@"配送中(%d)",_sending_count] forState:UIControlStateNormal];
                    
                    //2.
                    [_alreadySendBtn setTitle:[NSString stringWithFormat:@"已完成(%d)",_sign_count] forState:UIControlStateNormal];
                    
                    //3.
                    [_problemBtn setTitle:[NSString stringWithFormat:@"异常件(%d)",_expt_count] forState:UIControlStateNormal];
                    NSArray *array = dic[@"data"][@"order_list"];
                    if (array.count==0){
                        
                        [[KNToast shareToast]initWithText:@"没有更多订单信息了!" duration:1.5 offSetY:0];
                        
                        //                        return ;
                        
                    }
                    if (_dataList.count==0){
                        [_dataList addObjectsFromArray:array];
                    }
                    else{
                        if (_word_scan.length!=0|| _searchText.text.length!=0) {
                            [[KNToast shareToast]initWithText:@"没有找到订单信息,换个订单号试试吧!" duration:1.5 offSetY:0];
                        }
                        else
                        {
                            if (_word_scan.length!=0|| _searchText.text.length!=0) {
                                [[KNToast shareToast]initWithText:[NSString stringWithFormat:@"搜索成功"] duration:1.5 offSetY:0];
                            }
                            
                        }
                        
//                        NSArray *tmpary=[[NSArray alloc]initWithArray:self.dataList];
                        
                        for (int i=0; i<[array count]; i++) {
                            NSDictionary *newDic=array[i];
                            if (![self.dataList containsObject:newDic]) {
                                [self.dataList addObject:newDic];

                            }

                        }
                        
                    }
                    _word_scan=@"";
                    
                    [self.goodsTableview reloadData];
                    
                }else{
                    [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                    if (code == 1002){
                        LoginViewController *login = [[LoginViewController alloc] init];
                        [self.navigationController pushViewController:login animated:YES];
                    }
                }
                DLog(@"modeldata%@",[dic objectForKey:@"message"]);
            } );
        }];
    });
}

-(void)assignment{
    
    //1.
    [_sendIngBtn setTitle:@"配送中(0)" forState:UIControlStateNormal];
    
    //2.
    [_alreadySendBtn setTitle:@"已完成(0)" forState:UIControlStateNormal];
    
    //3.
    [_problemBtn setTitle:@"异常件(0)" forState:UIControlStateNormal];
    
}

#pragma mark 搜索按钮被点击
-(void)onSearchbtnClick:(UIButton *)btn{
    if (btn.tag == 10){
        _pageIndex = 0;
        if ([_searchText.text isEqualToString:@""] ||_searchText.text.length == 0){
            
            [self button1Click];
        }
        else{
            _offset = 0;
            _page_size = 10;
            _word = _searchText.text;
            [self.dataList removeAllObjects];
            [self getSendOrderList];
            
        }
    }
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
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _headView.backgroundColor = MainColor;
        [self.view addSubview:_headView];
    }
    
    if (!_sendIngBtn) {
        _sendIngBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendIngBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [_sendIngBtn setBackgroundImage:[[communcat sharedInstance]createImageWithColor:whiteColor] forState:UIControlStateSelected];
        [_sendIngBtn addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
        _sendIngBtn.frame = CGRectMake(20, 10, (SCREEN_WIDTH-80)/3, 30);
        
        _sendIngBtn.titleLabel.font = LittleFont;
        _sendIngBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _sendIngBtn.layer.cornerRadius=10;
        _sendIngBtn.clipsToBounds=YES;
        [_headView addSubview:_sendIngBtn];
    }
    
    if (!_alreadySendBtn) {
        _alreadySendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_alreadySendBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [_alreadySendBtn setBackgroundImage:[[communcat sharedInstance]createImageWithColor:whiteColor] forState:UIControlStateSelected];
        [_alreadySendBtn addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
        _alreadySendBtn.frame = CGRectMake(_sendIngBtn.x+_sendIngBtn.width+20,10, (SCREEN_WIDTH-80)/3, 30);
        _alreadySendBtn.titleLabel.font = LittleFont;
        _alreadySendBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _alreadySendBtn.layer.cornerRadius=10;
        _alreadySendBtn.clipsToBounds = YES;
        [_headView addSubview:_alreadySendBtn];
    }
    
    
    if (!_problemBtn) {
        _problemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_problemBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [_problemBtn setBackgroundImage:[[communcat sharedInstance]createImageWithColor:whiteColor] forState:UIControlStateSelected];
        [_problemBtn addTarget:self action:@selector(button3Click) forControlEvents:UIControlEventTouchUpInside];
        _problemBtn.frame = CGRectMake(_alreadySendBtn.width+_alreadySendBtn.x+20, 10, (SCREEN_WIDTH-80)/3, 30);
        _problemBtn.titleLabel.font = LittleFont;
        _problemBtn.layer.cornerRadius = 10;
        _problemBtn.clipsToBounds = YES;
        _problemBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:_problemBtn];
    }
    
    _totalOrderArray = [[NSMutableArray alloc] init];
    
    _filterData = [[NSMutableArray alloc] init];
    
    _searchData = [[NSMutableArray alloc] init];
    
    [self inithomeTableView];
    
    [self.view addSubview:_goodsTableview];
    
    
    if (!_searchBtn) {
        
        _searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn addTarget:self action:@selector(onSearchbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _searchBtn.tag = 10;
        _searchBtn.frame=CGRectMake(SCREEN_WIDTH-90, 60, 70, 30);
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"btn_serech.png"] forState:UIControlStateNormal];
        [_headView addSubview:_searchBtn];
        
    }
    
    if (!_searchText){
        _searchText=[[UITextField alloc]initWithFrame:CGRectMake(30, 60, SCREEN_WIDTH-130, 30)];
        _searchText.layer.cornerRadius = 10.0;
        _searchText.delegate=self;
        _searchText.clearButtonMode= UITextFieldViewModeAlways;
        _searchText.backgroundColor= whiteColor;
        _searchText.placeholder=@"   请输入订单号";
        _searchText.clearsOnBeginEditing=YES;
        _searchText.clearButtonMode = UITextFieldViewModeAlways;
        [_headView addSubview:_searchText];
    }
    //生成顶部右侧按钮
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_扫描.png"] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(scannerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
#pragma mark ------------模糊查询-------------
-(void)scannerBtnClick{
    
    DimChectViewController *vc = [[DimChectViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Cell出现时或者刷新的动画
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //缩放
    cell.layer.transform = CATransform3DMakeScale(0.6, 0.6, 1);
    [UIView animateWithDuration:0.3 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
    
}

#pragma mark --------textFileDelegate---------------
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if (textField == _searchText) {
        if (_searchText.text.length==0||[_searchText.text isEqualToString:@""]||!_searchText.text) {
            [self getSendOrderList];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView==_approve) {
        if (buttonIndex==0) {
            
            
        }
        else{
            ApplyBrokerViewController * approver=[[ApplyBrokerViewController alloc]init];
            approver.status=1;
            [self.navigationController pushViewController:approver animated:YES];
            
        }
    }
}
@end
