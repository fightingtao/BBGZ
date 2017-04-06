//
//  PayViewController.m
//  BBShangJia
//
//  Created by cbwl on 16/9/24.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "PayViewController.h"



@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource,editorBtnDelegate,UIAlertViewDelegate>
{
    NSString *payWay;//支付方式  0余额 1支付宝 2混合支付
    NSString *_yuE;//个人账户余额
    NSString *_orderId;//个人账户余额
    
    
}
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)UIButton *payBtn;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIAlertView *AlertViewOne;
@property (nonatomic,strong)UIAlertView *AlertViewTwo;
@property (nonatomic,assign)int timeCode;
@property (nonatomic,strong)CustomAlertView *alertOne;
@end

@implementation PayViewController
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"付款";
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    self.tabBarController.tabBar.hidden=YES;
    UIButton *leftItem =[UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    [self initTableView];
    [self initFooterView];
    _tableView.tableFooterView = _footerView;
    
    [self getMoney];//获取当前的余额
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAlipayResult:) name:@"alipay" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAlipayResultBiAlipay:) name:@"noAlipay" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cotinueGoAlipay) name:@"cotinueGoAlipay" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelOrderWithOrderId) name:@"cancelOrder" object:nil];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    self.InModel.city_name=userInfoModel.city_name;
    
}
#pragma mark 支付宝支付成功
-(void)getAlipayResult:(NSNotification*) notification
{
    PayFinishViewController *finish=[[PayFinishViewController alloc]init];
    finish.status=1;
    [self.navigationController pushViewController:finish animated:YES];
    //    [self afterAlipayCreateOrderWithOrderId:[notification object]];
    //    [notification object];//通过这个获取到传递的对象
}
#pragma mark 支付宝支付失败
-(void)getAlipayResultBiAlipay:(NSNotification*) notification
{
    DLog(@"duo数十年单  %@",[notification object]);
    PayFinishViewController *finish=[[PayFinishViewController alloc]init];
    finish.status=2;
    finish.noPayMsg=[notification object];
    finish.time=_publish_time;
    [self.navigationController pushViewController:finish animated:YES];
    
}
#pragma mark 支付失败后继续支付
-(void)cotinueGoAlipay
{
    _kind=2;
    [self payBtnClick];
}
-(void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , SCREEN_HEIGHT -64) style:UITableViewStyleGrouped];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark ----------uitablViewDateSource-----------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0)
    {
        PayViewCell *cell=  [[[NSBundle mainBundle]loadNibNamed:@"PayViewCell" owner:self options:nil]firstObject];
        [cell requirment_nameText:self.requirment_name];
        if (cell.cellHeight1 <= 200) {
            return 200;
        }else{
            return cell.cellHeight1;
        }
        
        

    }
    else{
        return 100;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Id = @"identefier";
    
    PayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    cell.delegate = self;
    if(indexPath.section == 0){
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PayViewCell" owner:self options:nil]firstObject];
            cell.delegate = self;
            DLog(@"_InModel%@",_InModel);
            cell.orderNumLabel.text=[NSString stringWithFormat:@"%d单",self.numble];
            cell.requirment_name.text=self.requirment_name;
            [cell requirment_nameText:self.requirment_name];

            if (self.kind==2) {
                cell.orderPrice.text=[NSString stringWithFormat:@"¥%.2f元",_money];
                cell.saverMoney.text=[NSString stringWithFormat:@"¥%.2f元",_money*0.05];
                cell.totalNumLabel.text=[NSString stringWithFormat:@"¥%.2f元",_money*1.05];
                
            }
            else{
                cell.orderPrice.text=[NSString stringWithFormat:@"¥%.2f元",[_InModel.commission floatValue]*[_InModel.order_amount intValue]];
                cell.saverMoney.text=[NSString stringWithFormat:@"¥%.2f元",[_InModel.commission floatValue]*[_InModel.order_amount intValue]*0.05];
                cell.totalNumLabel.text=[NSString stringWithFormat:@"¥%.2f元",[_InModel.commission floatValue]*[_InModel.order_amount intValue]*1.05];
            }
        }
    }else{
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PayViewCell" owner:self options:nil] lastObject];
            cell.yuerLabel.text=[NSString stringWithFormat:@"账户余额: ¥%.2f元",[_yuE floatValue]];
            
        }
        if ([_yuE floatValue]>self.money*1.05){
            cell.yuerBtn.selected=YES;
            cell.zhifubaoBtn.selected=NO;
        }
        else if ([_yuE floatValue]<=0){
            cell.yuerBtn.selected=NO;
            cell.zhifubaoBtn.selected=YES;
        }
        else {
            cell.yuerBtn.selected=YES;
            cell.zhifubaoBtn.selected=YES;
        }
        cell.selected=YES;
        
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)initFooterView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    }
    if (!_payBtn) {
        
        _payBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 60, SCREEN_WIDTH-40, 40)];
        _payBtn.backgroundColor = MainColor;
        [_payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payBtn.clipsToBounds = YES;
        _payBtn.layer.cornerRadius = 10;
        [_payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_payBtn];
    }
}

-(void)editorBtnSelect{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 确定按钮点击
-(void)payBtnClick{
    _payBtn.enabled=NO;
    NSIndexPath *index1=[NSIndexPath indexPathForRow:0 inSection:1];
    PayViewCell *cell1=[_tableView cellForRowAtIndexPath:index1];
    if (cell1.yuerBtn.isSelected==YES&&cell1.zhifubaoBtn.isSelected==YES) {
        payWay=@"2";//hu混合支付
    }
    else if (cell1.yuerBtn.isSelected==YES){
        payWay=@"0";//余额支付
        
    }
    else if (cell1.zhifubaoBtn.isSelected==YES){
        payWay=@"1";//支付宝支付
        
    }
    if ([payWay isEqualToString: @"0"]) {
        
        if ([_yuE floatValue] >=_money*1.05) {
            [self creactOrderBefore];
            
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的余额不足!请选择其他支付方式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            _payBtn.enabled=YES;
            
            return;
        }
        
    }
    else if ([payWay isEqualToString: @"1"])
    {
       

        [self creactOrderBefore];
        
    }
    else if ([payWay isEqualToString: @"2"]){
        if ([_yuE floatValue] >=_money*1.05) {
            payWay=@"0";//余额支付
        }
        [self creactOrderBefore];

    }
    
    DLog(@"支付方式  %@",payWay);
    
}
-(void)beforeAlipayCreateOrder{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if (userInfoModel.key.length==0||[userInfoModel.key isEqualToString:@""]||!userInfoModel.key){
        [[KNToast shareToast]initWithText:@"请登录!" duration:1.5 offSetY:0];
        _payBtn.enabled=YES;
        
        return;
    }
    if ([userInfoModel.user_status isEqualToString:@"0"]){
        [[KNToast shareToast]initWithText:@"您的账号已被冻结!" duration:1.5 offSetY:0];
        _payBtn.enabled=YES;
        
        return;
        
    }
    
    In_OrderPayModel *inModel = [[In_OrderPayModel alloc] init];
    NSString *hmacString;
    NSArray *  array;
    ///支付宝支付
    
    if ([payWay isEqualToString:@"1"]){
        array= [[NSArray alloc] initWithObjects:@"0",[NSString stringWithFormat:@"%.2f",_money*1.05],payWay,@"6",[NSString stringWithFormat:@"%@",_requirment_id],[NSString stringWithFormat:@"%@",_orders],[NSString stringWithFormat:@"%.2f",_money*0.05],nil];
        hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:array];
        inModel.key = userInfoModel.key;
        inModel.digest = hmacString;
        inModel.trade_amount = [NSString stringWithFormat:@"%.2f",_money*1.05];//支付宝交易金额
        inModel.reduced_amount = @"0";//平台账号扣取金额
        inModel.trade_way = payWay;
        inModel.trade_type =@"6";
        inModel.requirment_id =[NSString stringWithFormat:@"%@",_requirment_id];
        inModel.order_id =[NSString stringWithFormat:@"%@",_orders];
        inModel.service_amount=[NSString stringWithFormat:@"%.2f",_money*0.05];
    }
    ///混合支付
    else if ([payWay isEqualToString:@"2"]){
        array= [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%.2f",[_yuE floatValue]],[NSString stringWithFormat:@"%.2f",_money*1.05-[_yuE floatValue]],payWay,@"6",[NSString stringWithFormat:@"%@",_requirment_id],[NSString stringWithFormat:@"%@",_orders],[NSString stringWithFormat:@"%.2f",_money*0.05],nil];
        hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:array];
        inModel.key = userInfoModel.key;
        inModel.digest = hmacString;
        inModel.trade_amount = [NSString stringWithFormat:@"%.2f",_money*1.05-[_yuE floatValue]];//支付宝交易金额
        inModel.reduced_amount = [NSString stringWithFormat:@"%.2f",[_yuE floatValue]];//平台账号扣取金额
        inModel.trade_way = payWay;
        inModel.trade_type =@"6";
        inModel.requirment_id =[NSString stringWithFormat:@"%@",_requirment_id];
        inModel.order_id =[NSString stringWithFormat:@"%@",_orders];
        inModel.service_amount=[NSString stringWithFormat:@"%.2f",_money*0.05];
    }
    ///余额支付
    
    else  if ([payWay isEqualToString: @"0"]) {
        array= [[NSArray alloc] initWithObjects:@"0",[NSString stringWithFormat:@"%.2f",_money*1.05],payWay,@"6",[NSString stringWithFormat:@"%@",_requirment_id],[NSString stringWithFormat:@"%@",_orders],[NSString stringWithFormat:@"%.2f",_money*0.05],nil];
        hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:array];
        inModel.key = userInfoModel.key;
        inModel.digest = hmacString;
        inModel.trade_amount = @"0";//支付宝交易金额
        inModel.reduced_amount = [NSString stringWithFormat:@"%.2f",_money*1.05];//平台账号扣取金额
        inModel.trade_way = payWay;
        inModel.trade_type =@"6";
        inModel.requirment_id =[NSString stringWithFormat:@"%@",_requirment_id];
        inModel.order_id =[NSString stringWithFormat:@"%@",_orders];
        inModel.service_amount=[NSString stringWithFormat:@"%.2f",_money*0.05];
    }
    DLog(@"requirment_id  requirment_id  %@",inModel);
    
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbp.labelText = @"加载中";
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]createOrderAlipayWithModel:inModel  resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                DLog(@"生成支付订单%@",dic);
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    
                    [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                    
                }
                else if (code ==1000)
                {
                    out_OrderPayModel *outModel=[[out_OrderPayModel alloc]initWithDictionary:dic error:nil];
                    _orderId=outModel.data.pay_order_id;
                    
                    ///余额支付
                    
                    if ([payWay isEqualToString: @"0"]){
                        [self afterAlipayCreateOrderWithOrderId:outModel.data.pay_order_id];
                    }
                    else{
                        [self AliPayActionWith:outModel];
                    }
                }else{
                    [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                    
                    if (code == 1002) {
                        //                    LoginViewController *vc = [[LoginViewController alloc]init];
                        //                    [self.navigationController pushViewController: vc animated:YES];
                    }
                }
            });
        }];
    });
    _payBtn.enabled=YES;
    
}

- (void)AliPayActionWith:(out_OrderPayModel*)model
{
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    NSString *partner = model.data.alipay_config.partner;
    NSString *seller =model.data.alipay_config.seller;
    NSString *privateKey =model.data.alipay_config.private_key;
    
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = model.data.pay_order_id ; //订单ID（由商家自行制定）
    //    if (_payType == 1) {
    order.productName = @"订单金额";//商品标题
    order.productDescription = @"发单"; //商品描述
    //    }else
    //    {
    //    order.productName = @"直接支付(商品订单)";//商品标题
    //    order.productDescription = @"呼单支付"; //商品描述
    //    }
//    order.amount = [NSString stringWithFormat:@"0.01"];//test
    if ([payWay isEqualToString:@"2"]){
        order.amount = [NSString stringWithFormat:@"%.2f",_money*1.05-[_yuE floatValue]]; //商品价格

    }
    else{
        order.amount = [NSString stringWithFormat:@"%.2f",_money*1.05]; //商品价格
        
    }
    order.notifyURL = model.data.notify_url; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"BBGZ";
    
    //将商r品信息拼接成字符串
    NSString *orderSpec = [order description];
    //    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
         {
             if ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000){
                 
                 //                 [self afterAlipayCreateOrderWithOrderId];
             }
             else{
                 _AlertViewTwo = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付宝支付失败,是否继续支付" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                 [_AlertViewTwo show];
             }
             
         }];
    }
    
}
-(void)afterAlipayCreateOrderWithOrderId:(NSString *)order {
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
    
    In_afterPayModel *inModel = [[In_afterPayModel alloc] init];
    NSString *hmacString;
    ///支付宝支付
    //    NSArray *  array = [[NSArray alloc] initWithObjects:@"0",@"0",payWay,@"6",@"2",@"",nil];
    hmacString = [[communcat sharedInstance]hmac:[NSString stringWithFormat:@"%@",order] withKey:userInfoModel.primary_key];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.pay_order_id = [NSString stringWithFormat:@"%@",order];//支付宝交易金额
    
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbp.labelText = @"加载中";
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]checkOrderAfterAlipayWithModel:inModel  resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                DLog(@"查询结果列表数据%@",dic);
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    
                    [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                    
                }
                else if (code ==1000)
                {
                    NSDictionary *data=dic[@"data"];
                    //                status	int	支付状态，0：未支付，1：支付成功 2：支付失败
                    DLog(@"哎呀  %@",data);
                    if ([[NSString stringWithFormat:@"%@",data[@"status"]] isEqualToString:@"0"]){
                        PayFinishViewController *finish=[[PayFinishViewController alloc]init];
                        finish.status=2;
                        [self.navigationController pushViewController:finish animated:YES];
                        
                    }
                    else if ([[NSString stringWithFormat:@"%@",data[@"status"]] isEqualToString:@"1"]){
                        PayFinishViewController *finish=[[PayFinishViewController alloc]init];
                        finish.status=1;
                        [self.navigationController pushViewController:finish animated:YES];
                        
                        
                    }
                    else if ([[NSString stringWithFormat:@"%@",data[@"status"]] isEqualToString:@"2"]){
                        //                    _AlertViewOne = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付宝支付失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        //                    [_AlertViewOne show];
                        PayFinishViewController *finish=[[PayFinishViewController alloc]init];
                        finish.status=2;
                        [self.navigationController pushViewController:finish animated:YES];
                        
                    }
                    
                    
                }else{
                    [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                    
                    if (code == 1002) {
                        //                    LoginViewController *vc = [[LoginViewController alloc]init];
                        //                    [self.navigationController pushViewController: vc animated:YES];
                    }
                }
            });
        }];
    });
}
#pragma mark 取消订单
-(void)cancelOrderWithOrderId {
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
    
    In_afterPayModel *inModel = [[In_afterPayModel alloc] init];
    NSString *hmacString;
    ///支付宝支付
    //    NSArray *  array = [[NSArray alloc] initWithObjects:@"0",@"0",payWay,@"6",@"2",@"",nil];
    hmacString = [[communcat sharedInstance]hmac:[NSString stringWithFormat:@"%@",_requirment_id] withKey:userInfoModel.primary_key];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    inModel.pay_order_id = [NSString stringWithFormat:@"%@",_requirment_id];//支付宝交易金额
    
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbp.labelText = @"加载中";
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]cancelOrderAlipayWithModel:inModel  resultDic:^(NSDictionary *dic) {
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
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }else{
                    [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                    
                    if (code == 1002) {
                        //                    LoginViewController *vc = [[LoginViewController alloc]init];
                        //                    [self.navigationController pushViewController: vc animated:YES];
                    }
                }
            });
        }];
    });
}
#pragma mark 获取钱包余额
-(void)getMoney{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    In_afterPayModel *inModel = [[In_afterPayModel alloc] init];
    NSString *hmacString;
    
    hmacString = [[communcat sharedInstance] hmac:@"" withKey:userInfoModel.primary_key];
    inModel.key = userInfoModel.key;
    inModel.digest = hmacString;
    
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbp.labelText = @"加载中";
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]getYuEMoneyWithKey:userInfoModel.key digest:hmacString  resultDic:^(NSDictionary *dic) {
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
                    //                [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                    _yuE=dic[@"data"][@"balance"];
                    DLog(@"当前账户余额 %@",_yuE);
                    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:1];
                    [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
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
-(void)creactOrderBefore{
    if(_kind==2){
        [self beforeAlipayCreateOrder];
        
    }
    else{
        DLog(@"self.model %@",self.InModel);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[communcat sharedInstance]senderOrdersWithModel:self.InModel resultDic:^(NSDictionary *dic) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    int code =[[dic objectForKey:@"code"] intValue];
                    if (!dic){
                        [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                    }
                    else if (code == 1000){
                        DLog( @"订单提交返回的数据%@",dic);
                        self.requirment_id=dic[@"data"][@"requirment_id"];
                        self.publish_time=dic[@"data"][@"publish_time"];
                        
                        [self beforeAlipayCreateOrder];
                        
                    }
                    else{
                        [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                    }
                });
            }];
            
        });
    }
    _payBtn.enabled=YES;
    
}
-(void)leftItemClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_AlertViewOne==alertView) {
        
        PayFinishViewController *VC = [[PayFinishViewController alloc]init];
        
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    if (alertView.tag==300) {
        
        if (buttonIndex==1) {
            [self cancelOrderWithOrderId ];
            
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

@end
