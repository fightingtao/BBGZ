//
//  RootViewController.m
//  CYZhongBao

//  Copyright © 2016年 xc. All rights reserved.
//

#import "RootViewController.h"
#import "SendOrderViewController.h"
#import "OrderViewController.h"
#import "MyHomeViewController.h"
#import "PublicSouurce.h"
#import <AVFoundation/AVFoundation.h>
//#import "JPUSHService.h"
#import "JKNotifier.h"

@interface RootViewController ()

@property(nonatomic,strong)AVAudioPlayer *avAudioPlayer;

@end


@implementation RootViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    SendOrderViewController *sendVC = [[SendOrderViewController alloc]init];
    [self addChildVc:sendVC  title:@"发单" image:@"btn_unbilling" selectedImage:@"btn_billing" ];
    
    OrderViewController *orderVC = [[OrderViewController alloc]init];
    [self addChildVc:orderVC title:@"订单" image:@"btn_unoder" selectedImage:@"btn_oder" ];
    
    MyHomeViewController *personerVC = [[MyHomeViewController alloc]init];
    
    [self addChildVc:personerVC title:@"我的" image:@"btn_unme" selectedImage:@"btn_me" ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushResult:) name:PushNotifyName object:nil];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    
    childVc.title = title;
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    // 设置文字的样式
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    
    //设置选中字体颜色
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    
    
    // 为子控制器包装导航控制器
    UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:childVc];
    
    UIView *backgroundView = [navigationVc.navigationBar subviews].firstObject;
    UIImageView *lineView = backgroundView.subviews.firstObject;
    lineView.hidden = YES;
    navigationVc.navigationBar.barTintColor = MainColor;
    [navigationVc.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    UIColor *color = [UIColor colorWithRed:0.9882 green:0.9961 blue:0.9922 alpha:1.0];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    navigationVc.navigationBar.titleTextAttributes = dict;
    
    
    // 添加子控制器
    [self addChildViewController:navigationVc];
}

////极光推送消息展示
- (void)pushResult:(NSNotification *)notification{
    NSDictionary *object = notification.object;
    NSDictionary *aps = [object objectForKey:@"aps"];
    NSString *alertString = [aps objectForKey:@"alert"];
    NSString *showMessage=[NSString stringWithFormat:@"您有一条新消息:%@",alertString];
    DLog(@"%@",alertString);
    if ([alertString containsString:@"有人抢单了"]){
        [self performSelector:@selector(playAudio:) withObject:@"graborder" afterDelay:1.0];
    }
    else if ([alertString containsString:@"对不起，您的抢单被取消了"]){
        [self performSelector:@selector(playAudio:) withObject:@"cancelorder" afterDelay:1.5];


    }
    else if ([alertString containsString:@"认证"]){
        [[LoginViewController new]upDataUserMag];
    }
    
    [JKNotifier showNotifer:showMessage];
    
    [JKNotifier handleClickAction:^(NSString *name,NSString *detail, JKNotifier *notifier) {
        [notifier dismiss];
    }];
}
#pragma mark 语音播放
-(void)playAudio:(NSString *)name{
    NSString *string = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:string];
    //初始化音频类 并且添加播放文件
    self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //设置代理
    //    self.avAudioPlayer.delegate = self;
    
    //设置初始音量大小
    self.avAudioPlayer.volume = 1;
    
    //设置音乐播放次数  -1为一直循环
    self.avAudioPlayer.numberOfLoops = 0;
    
    //预播放
    [self.avAudioPlayer prepareToPlay];
    
    [self.avAudioPlayer play];
    [self performSelector:@selector(stopPlay) withObject:@"cancelorder" afterDelay:2.0];

}
-(void)stopPlay{
    [self.avAudioPlayer stop];
}

@end
