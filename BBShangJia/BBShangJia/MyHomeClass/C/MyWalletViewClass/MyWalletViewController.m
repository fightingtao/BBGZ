//
//  MyWalletViewController.m
//  BBShangJia
//
//  Created by cbwl on 16/9/27.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "MyWalletViewController.h"
#import "PublicSouurce.h"
#import "MyWalletViewCell.h"
#import "billVController.h"
@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题@end
@property (nonatomic,strong) NSDictionary *dataDic;
@end

@implementation MyWalletViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [ self.view addSubview:[self initpersonTableView]];
    self.view.backgroundColor = backGroud;
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 64, 150, 36)];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 36)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = LargeFont;
        _titleLabel.textColor = TextMainCOLOR;
        _titleLabel.text = @"我的钱包";
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
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(SCREEN_WIDTH-50, 0, 50, 30);
    [right setTintColor:[UIColor whiteColor]];
    [right setTitle:@"账单" forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:15];
    [right addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    
    [self getMyMoney];
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
-(void)leftItemClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----------账单按钮点击
-(void)rightItemClick{
    
    billVController *VC = [[billVController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
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
    rect.size.height = SCREEN_HEIGHT;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = backGroud;
    self.automaticallyAdjustsScrollViewInsets = false;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    return _tableView;
}
#pragma mark ---------tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyWalletViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MyWalletViewCell" owner:self options:nil] firstObject];
    if (_dataDic.allKeys.count>0) {
        [cell setModel:_dataDic];

    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return cell;

}

#pragma mark   我的钱包
-(void)getMyMoney{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if (userInfoModel.key.length==0||[userInfoModel.key isEqualToString:@""]||!userInfoModel.key){
        [[KNToast shareToast]initWithText:@"请登录!" duration:1.5 offSetY:0];
        
        return;
    }
    if ([userInfoModel.user_status isEqualToString:@"0"]){
        [[KNToast shareToast]initWithText:@"您的账号已被冻结!" duration:1.5 offSetY:0];
        
        return;
        
    }
    NSString *hmacString = [[communcat sharedInstance] hmac:[NSString stringWithFormat:@"%@",userInfoModel.user_type] withKey:userInfoModel.primary_key];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]getMyMoneyWithKey:userInfoModel.key digest:hmacString userType:[NSString stringWithFormat:@"%@",userInfoModel.user_type]  resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
            
                DLog(@"列表数据%@",dic);
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    
                    [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                    
                }
                else if (code ==1000)
                {
                    _dataDic=dic[@"data"];
                    
                    [_tableView reloadData];
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

@end
