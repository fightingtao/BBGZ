//
//  PayFinishViewController.m
//  BBShangJia
//
//  Created by cbwl on 16/9/24.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "PayFinishViewController.h"
#import "BillRecordViewController.h"
#import "PublicSouurce.h"
#import "PayViewController.h"
@interface PayFinishViewController ()<UIAlertViewDelegate>


@end

@implementation PayFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
      self.tabBarController.tabBar.hidden=YES;
    UIButton *leftItem =[UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    if (_status==2){
        self.title = @"支付失败";

        _discrp.text=@"支付失败,请在15分钟之内付款";
        [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"继续支付" forState:UIControlStateNormal];
        _imgStatus.image=[UIImage imageNamed:@"icon_payno"];
        [self startCodeTime:@"ew"];
    }
    else{
        self.title = @"支付成功";

    }
}

#pragma mark 继续发单
- (IBAction)continueBtnClick:(id)sender {
    if (_status==1){
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = @"movein";
    transition.subtype = kCAGravityBottomRight;
    [[UIApplication sharedApplication].delegate.window.layer addAnimation:transition forKey:@"transition"];
    [[self navigationController]popToRootViewControllerAnimated:NO];
    }
    else
    {
        DLog(@"qu取消订单按钮被点击");
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"用户提示" message:@"您的订单将会被取消" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                    alert.tag=300;
                    [alert show];
        
            }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==300) {
        if (buttonIndex==1) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelOrder" object:nil];
            [self.navigationController popViewControllerAnimated:YES];

            
        }
        else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

#pragma mark 查看订单
- (IBAction)checkOrderBtnClick:(id)sender {
    if (_status==1){

//    self.tabBarController.selectedIndex = 1;
        BillRecordViewController *bill=[BillRecordViewController new];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = @"movein";
        transition.subtype = kCAGravityBottomRight;
        [[UIApplication sharedApplication].delegate.window.layer addAnimation:transition forKey:@"transition"];

        [self.navigationController pushViewController:bill animated:NO];
        
    }
    else{

        [[NSNotificationCenter defaultCenter]postNotificationName:@"cotinueGoAlipay" object:nil];
        [self.navigationController popViewControllerAnimated:YES];

//        BillRecordViewController *bill=[[BillRecordViewController alloc]init];
//        [self.navigationController pushViewController:bill animated:YES];
    }
}


#pragma mark   //发送验证码倒计时
- (void)startCodeTime:(NSString *)notification
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date1= [dateFormatter dateFromString:self.time];
    
            NSDate *date2 = [NSDate date];
    int time=(int)  [date2 timeIntervalSinceDate:date1]; //登录的时间查
    int time1=15*60-time+30;
    if (time1>15*60){
        time1=15*60;
    }
    DLog(@"临时的数据 %d",time1);

    __block int timeout=time1; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 61;
            int mint=timeout/61;
//            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                _discrp.text=[NSString stringWithFormat:@"%@,请在%d分%d秒之内付款",_noPayMsg,mint,seconds];
//按钮显示 根据自己需求设置
                //                [_codeBtn setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                //                [_codeBtn setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
                //                _codeBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}


-(void)leftItemClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
