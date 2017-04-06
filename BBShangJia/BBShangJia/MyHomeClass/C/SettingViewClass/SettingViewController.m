//
//  SettingViewController.m
//  CYZhongBao
//
//  Created by xc on 15/11/27.
//  Copyright © 2015年 xc. All rights reserved.
//

#import "SettingViewController.h"
#import "ourVController.h"
#import "JPUSHService.h"
#import "PersonOtherInfoTableViewCell.h"
#import "LoginViewController.h"//登录


@interface SettingViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bgView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UITableView *setTableView;
@property (nonatomic, strong) UIButton *pushSwitch;
@property (nonatomic, strong) UIButton *logoutBtn;

@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden=YES;
}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//       self.tabBarController.tabBar.hidden = NO;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroud;
    self.title = @"设置";
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    
    [self initpersonTableView];
    [self.view addSubview:_setTableView];
    
    if (!_bgView){
        
        _bgView=[[UIView alloc]init];
        _bgView.backgroundColor = backGroud;
        _bgView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 80);
        
    }
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutBtn.frame = CGRectMake(30,40, SCREEN_WIDTH-60, 40);
        [_logoutBtn addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
        _logoutBtn.backgroundColor = MainColor;
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _logoutBtn.clipsToBounds = YES;
        _logoutBtn.layer.cornerRadius = 10;
        [_bgView addSubview:_logoutBtn];
    }
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
//初始化下单tableView
-(UITableView *)initpersonTableView
{
    if (_setTableView != nil) {
        return _setTableView;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT-50;
    
    self.setTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _setTableView.delegate = self;
    _setTableView.dataSource = self;
    _setTableView.backgroundColor = backGroud;
    _setTableView.showsVerticalScrollIndicator = NO;
    
    return _setTableView;
}


#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _bgView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"PersonOtherInfoTableViewCell";
    PersonOtherInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[PersonOtherInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    if (indexPath.row == 1)
    {
        cell.titleLable.text = @"关于我们";
        cell.contentLable.hidden = YES;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
    }else{
        
        cell.titleLable.text = @"当前版本号";
        NSString *V=[[NSUserDefaults standardUserDefaults]objectForKey:@"banbenhao"];
        if ([V isEqualToString:@""]|| V.length==0||!V||V==nil) {
            cell.contentLable.text =[NSString stringWithFormat:@"V %@",kVersion];

        }
        else{
            cell.contentLable.text = [NSString stringWithFormat:@"V %@",V];;

        }
        cell.arrowImg.hidden=YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 1)
    {
        ourVController * our = [[ourVController alloc] init];
        our.telphone=self.telphone;
        [self.navigationController pushViewController: our animated:YES];
    }
}

///退出账号
- (void)logoutClick
{
    
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"确认退出账号\n退出账号后将不能接收到任何通知" message:nil cancelBtnTitle:@"否" otherBtnTitle:@"是" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex == 200) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login-out" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login-out2" object:nil];

            //清除用户信息
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            UserInfoSaveModel *userInfoModel = [[UserInfoSaveModel alloc] init];
            userInfoModel.tag=@"";
            userInfoModel.key=@"";
            NSData *setData = [NSKeyedArchiver archivedDataWithRootObject:userInfoModel];
            [userDefault setObject:setData forKey:UserKey];
            //退出推送
            NSSet *set = [[NSSet alloc] initWithObjects:@"", nil];
            [JPUSHService setTags:set alias:@"" callbackSelector:nil object:nil];
            [self loginOutMathCLick];
            [userDefault setObject:@"" forKey:UserKey];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ChengGong"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self leftItemClick];
        }
    }];
    [alertView showLXAlertView];
}


#pragma mark 退出登录
-(void)loginOutMathCLick{
    NSData *msg=[[NSUserDefaults standardUserDefaults] objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:msg];
    if (userInfoModel.key.length==0) {
        return;
    }
    NSString *hmacString = [[communcat sharedInstance] hmac:@"" withKey:userInfoModel.primary_key];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] loginOutClickWithKey:userInfoModel.key digest:hmacString resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (dic){
                    
                    int   code =[[dic objectForKey:@"code"] intValue];
                    if (code==1000) {
                        [[KNToast shareToast]initWithText:@"退出登录成功" duration:1.5 offSetY:0];
                        
                    }
                    
                }
                else{
                    [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                    
                }
                
            });
            
        }];
        
    });
}

//导航栏左右侧按钮点击
- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
