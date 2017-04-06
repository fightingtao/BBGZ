//
//  FeedBackViewController.m
//  CYZhongBao
//
//  Created by xc on 15/11/27.
//  Copyright © 2015年 xc. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()<UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bgView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UIButton *commit;
@property (nonatomic, strong) UITextView *demandTextView;//文字需求内容
@end

@implementation FeedBackViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden =YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroud;
    self.title = @"意见反馈";
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    if ( !_bgView) {
        _bgView =[[UIView alloc]init];
        _bgView.frame=CGRectMake(0, 10, SCREEN_WIDTH, 160);
        _bgView.backgroundColor= [UIColor whiteColor];
        [self.view addSubview:_bgView];
    }
    
    if (!_demandTextView) {
        _demandTextView = [[UITextView alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-60, 150)];
        _demandTextView.textColor = kTextMainCOLOR;//设置textview里面的字体颜色
        _demandTextView.text=@"请输入您对我们的意见和建议!(限三百字)";
        _demandTextView.font = [UIFont fontWithName:@"Arial" size:14.0];//设置字体名字和字体大小
        _demandTextView.delegate = self;//设置它的委托方法
        _demandTextView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
        _demandTextView.returnKeyType = UIReturnKeyDone;//返回键的类型
        _demandTextView.keyboardType = UIKeyboardTypeDefault;//键盘类型
        //        _demandTextView.scrollEnabled = NO;//是否可以拖动
        //        _demandTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        [_bgView addSubview:_demandTextView];
        
    }
    
    if (!_commit) {
        _commit = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_commit addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_commit setBackgroundColor:MainColor];
        [_commit setTitle:@"提交" forState:UIControlStateNormal];
        [_commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commit.clipsToBounds = YES;
        _commit.layer.cornerRadius = 10;
        [self.view addSubview:_commit];
    }
    
    _commit.sd_layout.leftSpaceToView(self.view,30)
    .topSpaceToView(_bgView,50)
    .rightSpaceToView(self.view,30)
    .heightIs(40);
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//导航栏左右侧按钮点击

- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//导航栏左右侧按钮点击

- (void)commitClick
{
    if (_demandTextView.text.length == 0 || [_demandTextView.text isEqualToString:@"请输入您对我们的意见和建议!(限三百字)"]||!_demandTextView.text) {
        [[KNToast shareToast]initWithText:@"请输入您对我们的意见和建议!" duration:1.5 offSetY:0];
        
        
        return;
    }
    if (_demandTextView.text.length>300) {
        [[KNToast shareToast]initWithText:@"字数不能超过300字呦!" duration:1.5 offSetY:0];
        
        
        return;
    }
    
    [_demandTextView resignFirstResponder];
    [self feedbackCommit];
}

#pragma mark -----------意见反馈--------------------------
- (void)feedbackCommit{
    //    //1 配送中 2 已签收  3 异常件
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //加判断
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]||!userInfoModel.key) {
        
        return ;
    }
    
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbp.labelText = @"提交中";
    DLog(@"意见反馈%@",_demandTextView.text);
    DLog(@"意见反馈%@",userInfoModel.primary_key);
    NSArray *array=[[NSArray alloc]initWithObjects:self.demandTextView.text,@"1",[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] ,nil];
    NSString *hmacString = [[communcat sharedInstance]ArrayCompareAndHMac:array];
    
    In_opinionBackModel *model = [[In_opinionBackModel alloc]init];
    model.key = userInfoModel.key;
    model.digest = hmacString;
    model.suggestion_text = _demandTextView.text;
    model.suggestion_source = 1;
    //获取当前版本号
    model.suggestion_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]feedBackClickWithModel:model resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                DLog(@"列表数据%@",dic);
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                    
                    
                }
                else if (code == 1000){
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"用户提示" message:@"提交成功,感谢您的宝贵意见!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }else{
                    [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                }
                DLog(@"modeldata%@",[dic objectForKey:@"message"]);
                
            } );
            
        }];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self leftItemClick];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    if ([textView.text isEqualToString:@"请输入您对我们的意见和建议!(限三百字)"]){
        self.demandTextView.text=@"";
    }
    
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //    NSString * toBeString = [self.demandTextView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
    
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [self.demandTextView resignFirstResponder];//释放键盘
        return NO;
    }
    
    if (self.demandTextView.text.length == 0){//textview长度为0
        
    }else{//textview长度不为0
        if ( self.demandTextView.text.length>300){//textview长度为1时候
            self.demandTextView.text=[textView.text substringWithRange:NSMakeRange(0, 299)];
            //            [[iToast makeText:@"字数在300字之内"]show];
            return NO;
            
            
        }
    }
    
    return YES;
}


@end
