//
//  DistributionRangeController.m
//  BBShangJia
//
//  Created by cbwl on 16/9/24.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "DistributionRangeController.h"
#import "PublicSouurce.h"
#import "AppDelegate.h"
#import "ApplyBrokerViewController.h"
@interface DistributionRangeController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    CGFloat _all;
    NSString *_text;
    NSString *_loctionCity;
}

@property(nonatomic,strong)UITextField *searchFiled;
@property(nonatomic,strong)UIButton *searchBtn;
@property(nonatomic,strong)UIView *historyView;
@property(nonatomic,strong)UILabel *historyLabel;
@property(nonatomic,strong)UIView *historyLine;
@property(nonatomic,strong)UIView *allView;
@property(nonatomic,strong)UILabel *allLabel;
@property(nonatomic,strong)UIView *allLine;
@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)NSMutableArray *recordList;//历史记录
@property(nonatomic,strong)NSMutableArray *allList;//所有数据
@property(nonatomic,strong)NSMutableArray *searchList;//搜索

@property(nonatomic,strong)UITableView *tableView;
//@property(nonatomic,copy)NSString * loctionCity;
@property (nonatomic,strong)  UIAlertView *approve;//去雇主认证

@end

@implementation DistributionRangeController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _allList = [[NSMutableArray alloc]init];
    self.recordList = [[NSMutableArray alloc]init];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden = NO;
    
    [self initScrollView];
//    [self initSubViews];
    [self initTableView];
    [self getMsgWithCity];
}

-(NSMutableArray*)searchList{
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}


-(NSMutableArray*)recordList{
    if (!_recordList) {
        _recordList = [NSMutableArray array];
    }
    return _recordList;
}
//
//-(NSMutableArray*)allList{
//    if (!_allList) {
//        _allList = [NSMutableArray array];
//    }
//    return _allList;
//}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;//一行代码解决问题，注意要写在viewDidAppear方法里
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    //    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    self.title = @"配送范围";
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    
    UIButton *leftItem =[UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
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
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT-134)];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
}

-(void)initSubViews{
    //搜索
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 15, 40, 40)];
        [_searchBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_searchBtn];
    }
    
    if (!_searchFiled) {
        _searchFiled = [[UITextField alloc] init];
        _searchFiled.frame = CGRectMake(20, 15, SCREEN_WIDTH-_searchBtn.width -55, 40);
        _searchFiled.leftViewMode=UITextFieldViewModeAlways;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 20, 20) ];
        imageView.image = [UIImage imageNamed:@"icon_serach"];
        _searchFiled.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        _searchFiled.keyboardType = UIKeyboardTypeDefault;
        [_searchFiled.leftView addSubview: imageView];
        _searchFiled.leftViewMode =  UITextFieldViewModeAlways;
        _searchFiled.backgroundColor = [UIColor whiteColor];
        [_searchFiled setBorderStyle:UITextBorderStyleRoundedRect];
        _searchFiled.clipsToBounds = YES;
        _searchFiled.layer.cornerRadius = 15;
        _searchFiled.placeholder = @"长江贸易大楼";
        _searchFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_searchFiled addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
        [self.view addSubview:_searchFiled];
    }
    
    //历史记录
    if (!_historyView) {
        _historyView = [[UIView alloc] init];
        _historyView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_historyView];
    }
    if (!_historyLabel) {
        _historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        _historyLabel.text = @"历史记录";
        _historyLabel.font = [UIFont systemFontOfSize:15];
        [_historyView addSubview:_historyLabel];
    }
    if (!_historyLine) {
        _historyLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
        _historyLine.backgroundColor = [UIColor grayColor];
        _historyLine.alpha = 0.1;
        [_historyView addSubview:_historyLine];
    }
    //循环添加历史记录  record
    if (self.recordList.count > 0) {
        CGFloat h = _historyLine.y +  16;
        CGFloat w = 0;
        for (NSInteger i = 0; i < self.recordList.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            
            NSDictionary *tmpdic=self.recordList[i];
            NSString *title =tmpdic[@"grid_name"];
            btn.tag=[tmpdic[@"grid_id"] intValue];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor grayColor].CGColor;
            btn.layer.cornerRadius = 10;
            [btn addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            //根据字体多少改变btn的宽度
            CGRect rect = [title boundingRectWithSize:(CGSizeMake(NSIntegerMax, 30)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
            CGFloat width = rect.size.width;
            //设置btn的frame
            
            btn.frame = CGRectMake(20 + w, h, width + 30 , 30);
            //当btn的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
            if(10 + w + width + 30 > SCREEN_WIDTH-20){
                w = 0; //换行时将w置为0
                h = h + btn.frame.size.height + 10;//距离父视图也变化
                btn.frame = CGRectMake(20 + w, h, width + 30, 30);//重设button的frame
            }
            w = btn.width + btn.x;
            
            [_historyView addSubview:btn];
            if (i == self.recordList.count -1) {
                _historyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, btn.y +btn.height +20) ;
            }
        }
    }else{
        _historyView.frame = CGRectMake(0,0, SCREEN_WIDTH, 40) ;
        _historyLine.hidden = YES;
    }
    
    //全部网格
    if(!_allView){
        _allView = [[UIView alloc] init];
        _allView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_allView];
    }
    if (!_allLabel) {
        _allLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 20)];
        _allLabel.text = @"全部网格";
        _allLabel.font = [UIFont systemFontOfSize:15];
        [_allView addSubview:_allLabel];
    }
    if (!_allLine) {
        _allLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
        _allLine.backgroundColor = [UIColor grayColor];
        _allLine.alpha = 0.1;
        [_allView addSubview:_allLine];
    }
    if (_allList.count>0){
        //循环添加btn
        CGFloat h = _allLine.y +  16;
        CGFloat w = 0;
        for (NSInteger i = 0; i < _allList.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            NSDictionary *tmpdic=_allList[i];
            NSString *title =tmpdic[@"grid_name"];
            btn.tag=[tmpdic[@"grid_id"] intValue];
            
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor grayColor].CGColor;
            btn.layer.cornerRadius = 10;
            
            //根据字体多少改变btn的宽度
            CGRect rect = [title boundingRectWithSize:(CGSizeMake(NSIntegerMax, 30)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
            
            CGFloat width = rect.size.width;
            //设置btn的frame
            
            btn.frame = CGRectMake(20 + w, h, width + 30 ,30);
            //当btn的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
            if(10 + w + width + 30 > SCREEN_WIDTH-20){
                w = 0; //换行时将w置为0
                h = h + btn.frame.size.height + 10;//距离父视图也变化
                btn.frame = CGRectMake(20 + w, h, width + 30, 30);//重设button的frame
            }
            w = btn.width + btn.x;
            
            [_allView addSubview:btn];
            //增加点击事件
            [btn addTarget:self action:@selector(hotBtnClick:)forControlEvents:UIControlEventTouchUpInside];
            if (i == _allList.count -1) {
                _allView.frame = CGRectMake(0, _historyView.y +_historyView.height+10, SCREEN_WIDTH, btn.y +btn.height +20) ;
            }
        }
        _scrollView.contentSize = CGSizeMake(0, _allView.height +_allView.y +10);
    }
}

#pragma mark -------uitextFiledDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

#pragma mark -------全部按钮点击

//全部网格按钮点击
-(void)hotBtnClick:(UIButton*)btn{
    _searchFiled.text = btn.titleLabel.text;
    if (![self.recordList containsObject:_searchFiled.text]) {
        [self.recordList insertObject:_searchFiled.text atIndex:0];
        if (self.recordList.count >= 7) {
            [self.recordList removeObjectAtIndex:self.recordList.count -1];
        }
    }
    
    NSArray *array = [NSArray arrayWithArray:self.recordList];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:array forKey:@"record"];
    [user synchronize];
    
    if ([self.delegate respondsToSelector:@selector(selectedDistribution: requiment:)]) {
        [self.delegate selectedDistribution:btn.titleLabel.text requiment:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initTableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT-70-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
    }
}

#pragma mark ---------tableViewDateSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.searchList.count >0) {
        return self.searchList.count;
    }else{
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *ID = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (self.searchList.count > 0) {
        NSString *title =self.searchList[indexPath.row][@"grid_name"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",title];
    }else {
        if (_searchFiled.text.length >0) {
            cell.textLabel.text = @"抱歉，未找到相关位置，可尝试修改后重试";
        }else{
            cell.textLabel.text = @"";
        }
        
    }
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark --------输入字时-------
-(void)valueChanged:(UITextField*)filed{
    [_searchList removeAllObjects];
    if (filed.text.length > 0) {
        for (NSInteger i = 0; i < self.allList.count; i++) {
            
            if ([self.allList[i][@"grid_name"] length] >= filed.text.length) {
                
//                if ( [[self.allList[i][@"grid_name"] substringToIndex:filed.text.length] containsString:filed.text]) {
                if ( [self.allList[i][@"grid_name"]  containsString:filed.text]) {
                    if(![_searchList containsObject:self.allList[i]]){
                        
                        [_searchList addObject:self.allList[i]];
                    }
                }
            }
        }
        [_scrollView removeFromSuperview];
        [self.view addSubview:_tableView];
        [_tableView reloadData];
    }else{
        [self.tableView removeFromSuperview];
        [self.view addSubview:_scrollView];
    }
}

//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    [textField resignFirstResponder];
//    [_tableView removeFromSuperview];
//    [self.view addSubview:_scrollView];
//}

#pragma mark -------tableViewDidSelect
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.searchFiled resignFirstResponder];
    if (![self.recordList containsObject:_searchList[indexPath.row] ]) {
        [self.recordList insertObject:_searchList[indexPath.row] atIndex:0];
        if (self.recordList.count >= 7) {
            [self.recordList removeObjectAtIndex:self.recordList.count -1];
        }
    }

    
    NSArray *array = [NSArray arrayWithArray:self.recordList];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:array forKey:@"record"];
    [user synchronize];
    
    if (self.searchList.count >0) {
        if ([self.delegate respondsToSelector:@selector(selectedDistribution:requiment:)]) {
            NSDictionary *tmpdic=self.searchList[indexPath.row];
            NSString *title =tmpdic[@"grid_name"];
//            NSString *title=self.searchList[indexPath.row];
            
            [self.delegate selectedDistribution:title requiment:tmpdic[@"grid_id"]];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 搜索
-(void)searchBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)leftBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark   获取网格数据
-(void)getMsgWithCity{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app locationClick];
//    _loctionCity=[[NSUserDefaults standardUserDefaults]objectForKey:@"loctionCity"];
//    DLog(@"当前的城市是  %@",_loctionCity);
//    
//    if (!_loctionCity || [_loctionCity isEqualToString:@""]) {
//        _loctionCity = @"南京市";
//    }
//    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if (![userInfoModel.user_type isEqualToString:@"1"]){
        
        if ([userInfoModel.authen_status isEqualToString:@"-1"]||[userInfoModel.authen_status isEqualToString:@"2"]){
            _approve=[[UIAlertView alloc]initWithTitle:@"用户提示" message:@"经过雇主认证之后就可以赚钱了!" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"马上去", nil];
            [_approve show];
            return;
        }
        }

    if (!userInfoModel.city_name || [userInfoModel.city_name isEqualToString:@""]) {
        _loctionCity = @"南京市";
    }
    if (userInfoModel.key.length==0||[userInfoModel.key isEqualToString:@""]||!userInfoModel.key){
        [[KNToast shareToast] initWithText:@"请登录!" duration:1.5 offSetY:0];
        LoginViewController *Login=[[LoginViewController alloc]init];
        [self.navigationController pushViewController:Login animated:YES];
        return;
    }
    if ([userInfoModel.user_status isEqualToString:@"0"]){
        [[KNToast shareToast]initWithText:@"您的账号已被冻结!" duration:1.5 offSetY:0];
        
        return;
        
    }
    
    
      NSString *hmac = [[communcat sharedInstance] hmac:[NSString stringWithFormat:@"%@",userInfoModel.city_name] withKey:[NSString stringWithFormat:@"%@",userInfoModel.primary_key]];
    getZhanDianMsg_inModel *inModel = [[getZhanDianMsg_inModel alloc] init];
    inModel.key = userInfoModel.key;
    inModel.digest = hmac;
    inModel.city_name=userInfoModel.city_name;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] getZhanDianWithMsg:inModel resultDic:^(NSDictionary *dic) {
             dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            DLog(@"列表数据%@",dic);
            int code=[[dic objectForKey:@"code"] intValue];
            if (!dic)
            {
                [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
            }
            else if (code ==1000)
            {
                NSDictionary *data=[dic objectForKey:@"data"];
                
                for (NSDictionary *tmpdic in data[@"grids_list"]) {
                    if (![_allList containsObject:tmpdic]){
                        
                        [_allList addObject:tmpdic];
                        
                    }
                }
                for (NSDictionary *historyDic in data[@"history_grids_list"]) {
                    if (![_recordList containsObject:historyDic]){
                        [_recordList addObject:historyDic];

                        if (_recordList.count>6) {
                            [_recordList removeLastObject];
                        }
                        
                    }
                }
                DLog(@"列表数据shuzu %ld",_allList.count);
                
                [_tableView reloadData];
                [self initSubViews ];
            }else{
                [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                
                if (code == 1002) {
                    LoginViewController *vc = [[LoginViewController alloc]init];
                    [self.navigationController pushViewController: vc animated:YES];
                }
            }
             });
        }];
    });
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
