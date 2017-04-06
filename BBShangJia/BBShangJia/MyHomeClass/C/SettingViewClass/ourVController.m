//
//  ourVController.m
//  RCYunMaApp
//
//  Created by cbwl on 16/8/12.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "ourVController.h"
#import "PublicSouurce.h"
@interface ourVController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题
@end

@implementation ourVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=false;
    self.tabBarController.tabBar.hidden=YES;
    
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroud;
    self.automaticallyAdjustsScrollViewInsets=false;
    
    self.title = @"关于我们";
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if (!_telphone||_telphone.length==0) {
        _phone.text=[NSString stringWithFormat:@"客服电话:%@",userInfoModel.hotline];
    }
    else{
        _phone.text=[NSString stringWithFormat:@"客服电话:%@",_telphone];

    }
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    self.version.text=[NSString stringWithFormat:@"邦办雇主 V%@",kVersion];
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



@end
