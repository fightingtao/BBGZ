//
//  binDingVController.m
//  CYZhongBao
//
//  Created by cbwl on 16/8/18.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "binDingVController.h"
#import "PublicSouurce.h"
#import "LoginViewController.h"


@interface binDingVController ()
@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property(nonatomic,strong)LoginViewController *loginView;

@end

@implementation binDingVController
-(void)viewWillAppear{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroud;
    self.automaticallyAdjustsScrollViewInsets=false;
    
    
    
    
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 64, 150, 36)];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 36)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = LargeFont;
        _titleLabel.textColor = TextMainCOLOR;
        _titleLabel.text = @"绑定手机号";
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
}
- (IBAction)onSendCodeClick:(UIButton *)sender {
    [_textPhone resignFirstResponder];
    [_textCode resignFirstResponder];
    
    if (_textPhone.text.length == 0) {
        
        [[KNToast shareToast] initWithText:@"请输入手机号" duration:2 offSetY:0];
        return;
    }
    if (![[communcat sharedInstance]checkTel:_textPhone.text]) {
        [[KNToast shareToast] initWithText:@"请输入有效的手机号" duration:2 offSetY:0];

        return;
    }
    sender.enabled=NO;
    _btnCode.enabled=NO;
    _btnCode.userInteractionEnabled = NO;

    [self sendCodeWithPhone:_textPhone.text];
    
}

//发送验证码倒计时
//- (void)startCodeTime
//{
//    __block int timeout=60; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if(timeout<=0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
//                [_btnCode setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
//                _btnCode.userInteractionEnabled = YES;
//            });
//        }else{
//            //            int minutes = timeout / 60;
//            int seconds = timeout % 61;
//            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                [_btnCode setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
//                [_btnCode setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
//                _btnCode.userInteractionEnabled = NO;
//            });
//            timeout--;
//            
//        }
//    });
//    dispatch_resume(_timer);
//}


- (IBAction)onButtonSureClick:(id)sender {
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSArray *array=[[NSArray alloc]initWithObjects:@"",_textPhone.text,_textCode.text,userInfoModel.telephone, nil];
    NSString *hmac=[[communcat sharedInstance ]ArrayCompareAndHMac:array];
    
    In_changePhoneModel *inModel=[[In_changePhoneModel alloc]init];
    inModel.key=userInfoModel.key;
    inModel.digest=hmac;
    inModel.header=@"";
    inModel.mobile=userInfoModel.telephone;
    inModel.newmobile=_textPhone.text;
    inModel.code=_textCode.text;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[communcat sharedInstance]changePersonerPhoneWith:inModel resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (!dic)
                {
                    [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                }
                else if ([[dic objectForKey:@"code"]intValue] ==1000)
                {
//                    if ([self.delegate respondsToSelector:@selector(hadChangePhone:)]) {
                        [self.delegate hadChangePhone:inModel.newmobile];
//                    }
                    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                    [userDefault setObject:inModel.newmobile forKey:@"phoneNumbleGuZhu"];

                    [self.navigationController popToViewController:[LoginViewController new] animated:YES];
                    [[LoginViewController new]upDataUserMag];
                    
                    [[KNToast shareToast]initWithText:@"手机号更换成功!" duration:1.5 offSetY:0];
                    
                    
                    [self leftItemClick];
                    
                }else{
                    [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                    
                    DLog(@"%@",[dic objectForKey:@"message"]);
                }
                
            } );
            
        }];
    });
}

-(void)sendCodeWithPhone:(NSString *)phone{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    if ([userInfoModel.telephone isEqualToString:_textPhone.text]) {
        [[KNToast shareToast]initWithText:@"该手机号与当前手机号相同,请更换!" duration:1.5 offSetY:0];
        
        return;
    }

    NSString *hmac=[[communcat sharedInstance ]hmac:phone withKey:userInfoModel.primary_key];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[communcat sharedInstance]changePersonerPhoneMsgWithkey:userInfoModel.key   degist:hmac phone:phone resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
              if (!dic)
                {
                    [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                    
                    
                    
                }
                else if ([[dic objectForKey:@"code"]intValue] ==1000)
                {
//                    [self startCodeTime];
                    [[communcat sharedInstance] startCodeTimeWithTime:60  during:^(int timeDuring) {
                        int seconds = timeDuring % 61;
                        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                            //设置界面的按钮显示 根据自己需求设置
                            [_btnCode setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                            [_btnCode setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
                            _btnCode.userInteractionEnabled = NO;
                    } outTime:^(int outTime) {
                        [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                        [_btnCode setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
                        _btnCode.userInteractionEnabled = YES;

                    }];

                    
                }else{
                    
                    [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                    _btnCode.enabled=YES;
                    _btnCode.userInteractionEnabled = YES;

                }

            } );
            
        }];
    });

}
-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed=YES;
    self.tabBarController.tabBar.hidden=YES;
}

@end
