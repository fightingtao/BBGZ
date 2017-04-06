//
//  LoginViewController.m
//  CYZhongBao
//
//  Created by xc on 15/11/30.
//  Copyright © 2015年 xc. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistDelegateViewController.h"
#import "JPUSHService.h"
@interface LoginViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *phoneImg;
@property (nonatomic, strong) UITextField *phoneTxtField;
@property (nonatomic, strong) UIImageView *codeImg;
@property (nonatomic, strong) UITextField *codeTxtField;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *delegateBtn;
@property (nonatomic, strong) UILabel *list;//shuom说明


@end

@implementation LoginViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //    self.navigationController.navigationBar.hidden = YES;
    //    self.hidesBottomBarWhenPushed=NO;
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBar.hidden = NO;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    self.automaticallyAdjustsScrollViewInsets=false;
    self.tabBarController.tabBar.hidden=YES;
    
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 64, 150, 36)];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 36)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = LargeFont;
        _titleLabel.textColor = TextMainCOLOR;
        _titleLabel.text = @"登录";
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
    
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_contentView];
    }
    if (!_logo) {
        _logo = [[UIImageView alloc] init];
        _logo.image = [UIImage imageNamed:@"Icon-76.png"];
        [self.view addSubview:_logo];
    }
    if (!_phoneImg) {
        _phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12.5, 15, 25)];
        _phoneImg.image = [UIImage imageNamed:@"icon_phone"];
        [_contentView addSubview:_phoneImg];
    }
    
    if (!_phoneTxtField) {
        _phoneTxtField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-80, 50)];
        _phoneTxtField.borderStyle = UITextBorderStyleNone;
        _phoneTxtField.placeholder = @"请输入手机号";
        _phoneTxtField.backgroundColor = [UIColor clearColor];
        _phoneTxtField.textColor = kTextMainCOLOR;
        _phoneTxtField.font = LittleFont;
        _phoneTxtField.keyboardType = UIKeyboardTypePhonePad;
        _phoneTxtField.delegate = self;
        _phoneTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTxtField.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumbleGuZhu"];
        [_contentView addSubview:_phoneTxtField];
    }
    
    if (!_codeImg) {
        _codeImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 70, 15, 25)];
        _codeImg.image = [UIImage imageNamed:@"组-14"];
        [_contentView  addSubview:_codeImg];
    }
    
    if (!_codeTxtField) {
        _codeTxtField = [[UITextField alloc] initWithFrame:CGRectMake(60, 60, SCREEN_WIDTH-150, 50)];
        _codeTxtField.borderStyle = UITextBorderStyleNone;
        _codeTxtField.placeholder = @"请输入验证码";
        _codeTxtField.backgroundColor = [UIColor clearColor];
        _codeTxtField.textColor = kTextMainCOLOR;
        _codeTxtField.font = LittleFont;
        _codeTxtField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTxtField.delegate=self;
        _codeTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_contentView  addSubview:_codeTxtField];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-20, 1)];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.3;
    [_contentView  addSubview:line];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, 119, SCREEN_WIDTH-20, 1)];
    line2.backgroundColor = [UIColor grayColor];
    line2.alpha = 0.3;
    [_contentView  addSubview:line2];
    
    if (!_codeBtn) {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeBtn.backgroundColor = MainColor;
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
        
        [_codeBtn addTarget:self action:@selector(getCodeClick) forControlEvents:UIControlEventTouchUpInside];
        _codeBtn.frame = CGRectMake(SCREEN_WIDTH-140, 68.5, 110, 35);
        _codeBtn.clipsToBounds = YES;
        _codeBtn.layer.cornerRadius = 10;
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_contentView  addSubview:_codeBtn];
    }
    
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.backgroundColor = MainColor;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.clipsToBounds = YES;
        _loginBtn.layer.cornerRadius = 10;
        
        [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_loginBtn];
    }
    
    if (!_list) {
        _list = [[UILabel alloc] init];
        _list.backgroundColor = [UIColor clearColor];
        _list.font = [UIFont systemFontOfSize:12];
        _list.textColor = [UIColor colorWithRed:102/225 green:102/225 blue:102/225 alpha:1.0];
        _list.alpha = 0.4;
        _list.text = @"登录代表您已同意";
        _list.lineBreakMode = NSLineBreakByTruncatingTail;
        _list.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_list];
    }
    
    if (!_delegateBtn) {
        _delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delegateBtn setTitle:@"《邦办雇主协议》" forState:UIControlStateNormal];
        
        [_delegateBtn setTitleColor:[UIColor colorWithRed:0.3137 green:0.1765 blue:0.4706 alpha:1] forState:UIControlStateNormal];
        
        [_delegateBtn addTarget:self action:@selector(goDelegateViewC) forControlEvents:UIControlEventTouchUpInside];
        _delegateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.view  addSubview:_delegateBtn];
    }
    _logo.sd_layout.centerXEqualToView(self.view)
    .topSpaceToView(self.view,40)
    .widthIs(90)
    .heightIs(90);
    
    _contentView.sd_layout.leftSpaceToView(self.view,0)
    .topSpaceToView (_logo,30)
    .rightSpaceToView(self.view,0)
    .heightIs(120);
    
    _loginBtn.sd_layout.leftSpaceToView(self.view,30)
    .topSpaceToView (_contentView,30)
    .rightSpaceToView(self.view,30)
    .heightIs(44);
    
    _list.sd_layout.rightSpaceToView(self.view,(SCREEN_WIDTH)/2)
    .bottomSpaceToView (self.view,12)
//    .widthIs(115)
    .heightIs(40);
    
    [_list setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
    _delegateBtn.sd_layout.leftSpaceToView(_list,0)
    .bottomSpaceToView (self.view,12)
    .widthIs(100)
    .heightIs(40);
}

//查看协议
-(void)goDelegateViewC{
    RegistDelegateViewController *delegate=[[RegistDelegateViewController alloc]init];
    //    self.hidesBottomBarWhenPushed=NO;
    //    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController pushViewController:delegate animated:YES];
}

//获取验证码事件处理
- (void)getCodeClick
{
    [_phoneTxtField resignFirstResponder];
    [_codeTxtField resignFirstResponder];
    
    if (_phoneTxtField.text.length == 0) {
        [[KNToast shareToast]initWithText:@"请输入您的手机号" duration:1.5 offSetY:420.0];
        return;
    }
    if (![[communcat sharedInstance]checkTel:_phoneTxtField.text]) {
        [[KNToast shareToast]initWithText:@"请输入正确的手机号" duration:1.5 offSetY:420.0];
        
        return;
    }
    [self startCodeTime];
    In_LoginCodeModel *inModel = [[In_LoginCodeModel alloc] init];
    inModel.telephone = _phoneTxtField.text;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]sendCodeWithPhone:_phoneTxtField.text resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (dic){
                    int   code =[[dic objectForKey:@"code"] intValue];
                    if (code==1000) {
                        DLog(@"验证码发送成功%@",dic );
                        [[KNToast shareToast]initWithText:@"验证码发送成功" duration:1.5 offSetY:420.0];
                    }
                    else {
                        [[KNToast shareToast]initWithText:@"请输入正确的手机号" duration:1.5 offSetY:420.0];
                        
                    }
                    
                    
                }
                else{
                    [[KNToast shareToast]initWithText:@"网络不给力!请检查数据连接..." duration:1.5 offSetY:0.0];
                    
                }
                
            });
            
        } ];
    });
    
}

//发送验证码倒计时
- (void)startCodeTime
{
    [[communcat sharedInstance] startCodeTimeWithTime:60  during:^(int timeDuring) {
        int seconds = timeDuring % 61;
        [_codeBtn setTitle:[NSString stringWithFormat:@"%d秒后重发",seconds] forState:UIControlStateNormal];
        [_codeBtn setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
        _codeBtn.userInteractionEnabled = NO;
    } outTime:^(int outTime) {
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_codeBtn setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
        _codeBtn.userInteractionEnabled = YES;
    }];
}


#pragma mark 登录
- (void)loginClick
{
    
    if (_phoneTxtField.text.length == 0) {
        [[KNToast shareToast]initWithText:@"请输入手机号" duration:1.5 offSetY:420];

        return;
    }

    if (_codeTxtField.text.length != 4) {
        [[KNToast shareToast]initWithText:@"请输入正确的验证码" duration:1.5 offSetY:420];
        return;
    }
    
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbp.labelText = @"登录中...";
    In_LoginModel *inModel = [[In_LoginModel alloc] init];
    inModel.telephone = _phoneTxtField.text;
    inModel.code = _codeTxtField.text;
    inModel.userType=@"1";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]LoginbtnClickWithMsg:inModel resultDic:^(NSDictionary *dic) {
             dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            DLog(@"登录信息%@",dic);
            
            int code=[[dic objectForKey:@"code"] intValue];
            
            if (!dic)
            {
                [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.0 offSetY:0 ];
                
            }
            
            else if (code ==1000)
            {
                NSDictionary *data=[dic objectForKey:@"data"];
                OutLoginBody *outModel=[[OutLoginBody alloc]initWithDictionary:data error:nil];
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                UserInfoSaveModel *saveModel = [[UserInfoSaveModel alloc] init];
                DLog(@"登录信息%@",outModel);
                
                saveModel.key = outModel.key;
                saveModel.tag = outModel.tag;
                saveModel.header = outModel.header;
                saveModel.nickname = outModel.nickname;
                saveModel.notify_switch = outModel.notify_switch;
                saveModel.user_type = outModel.user_type;
                saveModel.pay_status = outModel.pay_status;
                saveModel.city_name = outModel.city_name;
                saveModel.realname = outModel.realname;
                saveModel.point = outModel.point;
                saveModel.primary_key = outModel.primary_key;
                saveModel.authen_status = outModel.authen_status;
                saveModel.telephone = outModel.telephone;
                saveModel.pay_amount = outModel.pay_amount;
                saveModel.level = outModel.level;
                saveModel.gender = outModel.gender;
                saveModel.user_status = outModel.user_status;
                
                saveModel.hand_idcard = outModel.hand_idcard;
                saveModel.positive_idcard = outModel.positive_idcard;
                saveModel.opposite_idcard = outModel.opposite_idcard;
                saveModel.idcard_no = outModel.idcard_no;
                saveModel.hotline=outModel.hotline;

                
                NSData *setData = [NSKeyedArchiver archivedDataWithRootObject:saveModel];
                [userDefault setObject:setData forKey:UserKey];
                NSSet *set = [[NSSet alloc] initWithObjects:outModel.tag, nil];
                
                
                [JPUSHService setTags:set alias:outModel.key callbackSelector:nil object:nil];
                
                [userDefault setObject:_phoneTxtField.text forKey:@"phoneNumbleGuZhu"];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                //                self.tabBarController.selectedIndex=0;
                //                NSData *data2=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
                //                UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data2];
                //                DLog(@"登录信息%@",userInfoModel);
                
            }else{
                [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:420.0];
            }
             });
        }];
    });
}



//导航栏左右侧按钮点击

- (void)leftItemClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        [textField resignFirstResponder];
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (_phoneTxtField == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 11) { //如果输入框内容大于11则弹出警告
            textField.text = [toBeString substringToIndex:10];
        }
    }
    if (_codeTxtField==textField) {
        
        if ([toBeString length] > 4) { //如果输入框内容大于11则弹出警告
            textField.text = [toBeString substringToIndex:3];
        }
    }
    return YES;
}
#pragma mark 更新个人信息
///更新个人信息
-(void)upDataUserMag{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (userInfoModel.key.length==0 || [userInfoModel.key isEqualToString:@""]) {
        [[KNToast shareToast]initWithText:@"请登录!" duration:1.5 offSetY:0];
        return ;
    }
    NSString *hmac=[[communcat sharedInstance ]hmac:@"" withKey:userInfoModel.primary_key];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance] upDataUserMsgWithkey:userInfoModel.key degist:hmac resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            DLog(@"最大胆量%@",dic);
            int code=[[dic objectForKey:@"code"] intValue];
            if (!dic)
            {
                [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                
                
            }else if (code ==1000)
            {
                NSDictionary *data=[dic objectForKey:@"data"];
                OutLoginBody *outModel=[[OutLoginBody alloc]initWithDictionary:data error:nil];
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                UserInfoSaveModel *saveModel = [[UserInfoSaveModel alloc] init];
                DLog(@"登录信息%@",outModel);
                
                saveModel.key = outModel.key;
                saveModel.tag = outModel.tag;
                saveModel.header = outModel.header;
                saveModel.nickname = outModel.nickname;
                saveModel.notify_switch = outModel.notify_switch;
                saveModel.user_type = outModel.user_type;
                saveModel.pay_status = outModel.pay_status;
                saveModel.city_name = outModel.city_name;
                saveModel.realname = outModel.realname;
                saveModel.point = outModel.point;
                saveModel.primary_key = outModel.primary_key;
                saveModel.authen_status = outModel.authen_status;
                saveModel.telephone = outModel.telephone;
                saveModel.pay_amount = outModel.pay_amount;
                saveModel.level = outModel.level;
                saveModel.gender = outModel.gender;
                saveModel.user_status = outModel.user_status;
                saveModel.hand_idcard = outModel.hand_idcard;
                saveModel.positive_idcard = outModel.positive_idcard;
                saveModel.opposite_idcard = outModel.opposite_idcard;
                saveModel.idcard_no = outModel.idcard_no;
                saveModel.hotline=outModel.hotline;
                
                NSData *setData = [NSKeyedArchiver archivedDataWithRootObject:saveModel];
                [userDefault setObject:setData forKey:UserKey];
            }else{
                [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
            }
                 });
        }];
    });
    
}

@end
