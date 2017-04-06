//
//  SendOrderViewController.m
//  BBShangJia
//
//  Created by cbwl on 16/9/24.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "SendOrderViewController.h"
#import "PublicSouurce.h"
#import "citySelectVController.h"
#import "SendOrderViewCell.h"
#import "DistributionRangeController.h"//配送范围
#import <SYAlertController/SYAlertController.h>
#import "LoginViewController.h"
#import "ApplyBrokerViewController.h"
#import "PayViewController.h"

@interface SendOrderViewController ()<UITableViewDelegate,UITableViewDataSource,selectedDistributionDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    NSString *_text;//记录配送范围
    NSString *_type;//记录订单类型
    NSString *_grid_id	;//	网格id
}
//navigationBarItem
@property(nonatomic,strong)UIView *leftView;
@property (nonatomic, strong) UIButton *leftItem;
@property(nonatomic,strong)UIButton *leftDown;
@property(nonatomic,copy)NSString *city;//选择城市
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *footerView;//尾视图
@property(nonatomic,strong)UIButton *payBtn;
@property (nonatomic,strong)UserInfoSaveModel * userInfoModel;
@property (nonatomic,strong)  UIAlertView *approve;//去雇主认证
@property (nonatomic,strong)  UIAlertView *alertKind;//去雇主认证

@property(nonatomic,copy)NSString *price;//商家用户的价格
@property(nonatomic,copy)NSString *numb;//发单数量

@end

@implementation SendOrderViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden=NO;
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    if (data && data.length>0){
        _userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
                DLog(@"用户信息%@",_userInfoModel.user_type);
    }
    
    ///判断请登录
    if (_userInfoModel.key.length==0||[_userInfoModel.key isEqualToString:@""]||!_userInfoModel.key){
        //        [[KNToast shareToast]initWithText:@"您还没有登录,请登录!" duration:1.5 offSetY:0];
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    if ([_userInfoModel.user_status isEqualToString:@"0"]){
        [[KNToast shareToast]initWithText:@"您的账号已被冻结!" duration:1.5 offSetY:0];
        
        return;
        
    }
    if ( [_userInfoModel.user_type containsString:@"5"]){
        
        if ([_userInfoModel.authen_status isEqualToString:@"-1"]||[_userInfoModel.authen_status isEqualToString:@"2"]){
            if(_tableView){
                [_tableView reloadData];
            }
            _approve=[[UIAlertView alloc]initWithTitle:@"雇主身份未认证" message:@"只有通过<邦办雇主>身份认证之后,才能发单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去认证", nil];
            [_approve show];
            return;
        }
    }
    
    if(_tableView){
        [_tableView reloadData];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邦办雇主";
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    self.view.backgroundColor = backGroud;
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    if (data && data.length>0){
        _userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
     
        DLog(@"用户信息%@",_userInfoModel.user_type);
    }
    if (![_userInfoModel.user_type containsString:@"5"]){
        //        _price=@"请先选择订单类型";
        _price=@"";
    }
    else{
        _price=@"";
        //        _price=@"请输入订单单价";
    }
    //    _numb=@"请输入订单总数";
    _numb=@"";
    [self initNavigationItem];
    [self  initTableView];
    [self initFooterView];
    _tableView.tableFooterView = _footerView;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCityNotif:) name:@"citySelect2" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(outLoginDoit:) name:@"login-out2" object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)outLoginDoit:(NSNotification *)notif{
    _price=@"";
    _numb=@"";
    _text=NULL;
    _type=@"";
    if (_tableView  ) {
        [_tableView reloadData];
    }
}
-(void)getCityNotif:(NSNotification *)notifiction{
    NSString *  cityname = [notifiction object];//通过这个获取到传递的对象
    _city = cityname;
    [_leftItem setTitle:[NSString stringWithFormat:@"%@V",_city] forState:UIControlStateNormal];
    
    DLog(@"选择城市%@V",cityname);
}
-(void)initNavigationItem{
    _city=[[NSUserDefaults standardUserDefaults]objectForKey:@"loctionCity"];
    if ([_city isEqualToString:@""]||!_city||_city.length==0) {
        _city = @"南京市";
    }
    
    if (!_leftView) {
        _leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    }
    
    if (!_leftDown) {
        _leftDown = [[UIButton alloc]initWithFrame:CGRectMake(62, 12, 13, 10)];
        [_leftDown setBackgroundImage:[UIImage imageNamed:@"btn_down"] forState:UIControlStateNormal];
        //        [_leftView addSubview:_leftDown];
    }
    
    if (!_leftItem) {
        _leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftItem.frame = CGRectMake(0, 0, 130, 30);
        [_leftItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//左对齐
        _leftItem.titleLabel.font = MiddleFont;
        [_leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
        [_leftView addSubview:_leftItem];
        //        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftView];
    }
    
    
    
    //按钮文字显示
    [_leftItem setTitle:[NSString stringWithFormat:@"%@V",_city] forState:UIControlStateNormal];
}

-(void)initTableView {
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    _imageView.image = [UIImage imageNamed:@"商家banner"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = _imageView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)initFooterView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    }
    if (!_payBtn) {
        
        _payBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 60, SCREEN_WIDTH-40, 40)];
        _payBtn.backgroundColor = MainColor;
        [_payBtn setTitle:@"发单" forState:UIControlStateNormal];
        
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payBtn.clipsToBounds = YES;
        _payBtn.layer.cornerRadius = 10;
        [_payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_payBtn];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (![_userInfoModel.user_type containsString:@"5"]){
        return 4;
    }
    else{
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SendOrderViewCell *cell=  [[[NSBundle mainBundle]loadNibNamed:@"SendOrderViewCell" owner:self options:nil] objectAtIndex:0];
        
        if (cell.cellHeight1 <= 20) {
            return 50;
        }else{
            return cell.cellHeight1;
        }
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    SendOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (indexPath.row == 0) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SendOrderViewCell" owner:self options:nil] objectAtIndex:0];
        if (!_text) {
            cell.distrLabel.text = @"请选择";
            cell.distrLabel.textColor=kplaceHolderColor;
        }else{
           // cell.distrLabel.text = _text;
            [cell resultWithText:_text];

            cell.distrLabel.textColor=[UIColor blackColor];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    else if(indexPath.row == 1){
        if ( [_userInfoModel.user_type containsString:@"5"]){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SendOrderViewCell" owner:self options:nil] objectAtIndex:2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.priceAndNumb.text=@"订单数量:";
            cell.price.placeholder=@"请输入订单总数";
            
            cell.price.text=[NSString stringWithFormat:@"%@",_numb];
            
            cell.price.keyboardType=UIKeyboardTypeNumberPad;
            cell.units.text=@"单";
            cell.price.delegate=self;
            
        }
        else{
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SendOrderViewCell" owner:self options:nil] objectAtIndex:1];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(!_type){
                cell.typeLabel.text = @"请选择";
                cell.typeLabel.textColor=kplaceHolderColor;
            }else{
                cell.typeLabel.text = _type;
                cell.typeLabel.textColor=[UIColor blackColor];
            }
            
        }
    }
    else if(indexPath.row == 2){
        if ( [_userInfoModel.user_type containsString:@"5"]){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SendOrderViewCell" owner:self options:nil] objectAtIndex:2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.price.placeholder=@"请输入单价";
            
            cell.price.text=[NSString stringWithFormat:@"%@",_price];
            cell.price.delegate=self;
            
        }
        else{
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SendOrderViewCell" owner:self options:nil] objectAtIndex:2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.priceAndNumb.text=@"订单数量:";
            cell.price.placeholder=@"请输入订单总数";
            cell.price.keyboardType=UIKeyboardTypeNumberPad;
            cell.price.text=[NSString stringWithFormat:@"%@",_numb];
            
            cell.units.text=@"单";
            cell.price.delegate=self;
        }
    }
    else if(indexPath.row == 3) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SendOrderViewCell" owner:self options:nil] objectAtIndex:2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([_price floatValue]<=0){
            cell.price.placeholder=@"请输入单价";
        }
        else{
            cell.price.text=[NSString stringWithFormat:@"%.2f",[_price floatValue]];
        }
        
        cell.price.enabled=NO;
    }
    
    return cell;
}

#pragma mark --------tableViewSelect--------
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DistributionRangeController *VC = [[DistributionRangeController alloc] init];
        VC.delegate = self;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = @"cube";//立体
        transition.subtype = kCAGravityBottomLeft;//动画方向从左向右
        [[UIApplication sharedApplication].delegate.window.layer addAnimation:transition forKey:@"transition"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.row == 1){
        if (![_userInfoModel.user_type containsString:@"5"]){
            _alertKind=[[UIAlertView alloc]initWithTitle:@"请选择配送网格" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"网格发单",@"网点发单",@"取消", nil];
            
            [_alertKind show];
            
//            SYAlertController *alert = [SYAlertController sharedWithTitle:@"请选择配送网格" message:@"" style:SYAlertStyleDefault];
//            SYAlertAction *cancel = [SYAlertAction actionWithTitle:@"网格发单" style:SYActionStyleDefault handler:^(SYAlertAction *action) {
//                _type = @"网格发单";
//                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
//                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationLeft];
//                [self getMsgWithType:_type];
//                
//            }];
//            SYAlertAction *action = [SYAlertAction actionWithTitle:@"网点发单" style:SYActionStyleDefault handler:^(SYAlertAction *action) {
//                _type = @"网点发单";
//                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
//                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationLeft];
//                [self getMsgWithType:_type];
//                
//            }];
//            SYAlertAction *action1 = [SYAlertAction actionWithTitle:@"取消" style:SYActionStyleDestructive handler:^(SYAlertAction *action) {
//                
//            }];
//            
//            [alert addAlertAction:cancel];
//            [alert addAlertAction:action];
//            [alert addAlertAction:action1];
//            [alert show];
            
        }
    }
}

-(void)selectedDistribution:(NSString *)text requiment:(NSString *)requiment{
    _text = text;
    _grid_id=requiment;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationLeft];
}
#pragma mark textDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField;   {
    NSIndexPath *index1=[NSIndexPath indexPathForRow:1 inSection:0];
    SendOrderViewCell *cell1=[_tableView cellForRowAtIndexPath:index1];
    
    NSIndexPath *index2=[NSIndexPath indexPathForRow:2 inSection:0];
    SendOrderViewCell *cell2=[_tableView cellForRowAtIndexPath:index2];
    //    NSIndexPath *index3=[NSIndexPath indexPathForRow:3 inSection:0];
    //    SendOrderViewCell *cell3=[_tableView cellForRowAtIndexPath:index3];
    
    if ( [_userInfoModel.user_type containsString:@"5"]){
        if (textField==cell1.price) {
            _numb=textField.text;
            
        }
        else if (textField==cell2.price){
            [self panDuanPriceWithCell:cell2 textFile:textField];
            
        }
    }
    else{
        if (textField==cell2.price) {
            _numb=textField.text;
            
        }
        //        else if (textField==cell2.price){
        //            [self panDuanPriceWithCell:cell2 textFile:textField];
        //
        //        }
        
    }
}
#pragma mark 判断订单单价 0.5
-(void)panDuanPriceWithCell:(SendOrderViewCell *)cell textFile:(UITextField *)textField{
    if (cell.price==textField) {
        float price1=[cell.price.text floatValue];
        if (price1<0.5) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"订单单价不能低于0.5元,请重新输入订单金额!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
//            SYAlertController *alert = [SYAlertController sharedWithTitle:@"订单单价不能低于0.5元,请重新输入订单金额!" message:@"" style:SYAlertStyleDefault];
//            SYAlertAction *action1 = [SYAlertAction actionWithTitle:@"确定" style:SYActionStyleDestructive handler:^(SYAlertAction *action) {
//                
//            }];
//            [alert addAlertAction:action1];
//            [alert show];
            cell.price.text=@"";
        }
        else{
            _price=textField.text;
        }
    }
}
-(void)payBtnClick{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    ///判断请登录
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""] || !userInfoModel.key) {
        [[KNToast shareToast]initWithText:@"您还没有登录,请登录!" duration:1.5 offSetY:0];
        return ;
    }
    if ([userInfoModel.user_status isEqualToString:@"0"]){
        [[KNToast shareToast]initWithText:@"您的账号已被冻结!" duration:1.5 offSetY:0];
        return;
    }
    in_senderOrderModel *InModel = [[ in_senderOrderModel alloc]init];
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];
    SendOrderViewCell *cell =  [_tableView cellForRowAtIndexPath:index];
    
    if ([ cell.distrLabel.text isEqualToString:@"请选择"]|| cell.distrLabel.text.length==0) {
        [[KNToast shareToast]initWithText:@"请先选择配送范围" duration:1.5 offSetY:0];
        
        return;
    }
    if (![_userInfoModel.user_type containsString:@"5"]){
        //user_type 1 企业商家
        if ([[NSString stringWithFormat:@"%@",_price] isEqualToString:@"请先选择订单类型"]) {
            [[KNToast shareToast]initWithText:@"请先选择订单类型" duration:1.5 offSetY:0];
            
            return;
        }
        NSIndexPath *index1=[NSIndexPath indexPathForRow:1 inSection:0];
        SendOrderViewCell *cell1=[_tableView cellForRowAtIndexPath:index1];
        
        NSIndexPath *index2=[NSIndexPath indexPathForRow:2 inSection:0];
        SendOrderViewCell *cell2=[_tableView cellForRowAtIndexPath:index2];
        ///判断订单数量
        if ([cell2.price.text isEqualToString: @"请输入订单总数"] ||cell2.price.text.length==0||!cell2.price.text)
        {
            [[KNToast shareToast]initWithText:@"请输入订单总数" duration:1.5 offSetY:0];
            
            return;
        }
        else if([cell2.price.text intValue]<=0){
            [[KNToast shareToast]initWithText:@"请输入正确的订单数量" duration:1.5 offSetY:0];
            
            return;
        }
        
        
        else{
            _numb=[NSString stringWithFormat:@"%d",[cell2.price.text intValue]];
        }
        
        NSIndexPath *index3=[NSIndexPath indexPathForRow:3 inSection:0];
        SendOrderViewCell *cell3=[_tableView cellForRowAtIndexPath:index3];
        ///判断单价
        
        if ([cell3.price.text isEqualToString: @"请输入订单单价"] ||cell3.price.text.length==0||!cell3.price.text)
        {
            [[KNToast shareToast]initWithText:@"请输入订单单价" duration:1.5 offSetY:0];
            
            return;
        }
        else if (cell3.price.text.length>5){
            [[KNToast shareToast]initWithText:@"请输入有效的订单单价" duration:1.5 offSetY:0];
            return;
        }
        //        else if ([cell3.price.text floatValue]<0.5){
        //            [[KNToast shareToast]initWithText:@"订单单价不能低于0.5元,请重新输入订单金额!" duration:1.5 offSetY:0];
        //            return;
        //        }
        else{
            
            _price=[NSString stringWithFormat:@"%.2f",[cell3.price.text floatValue]];
        }
        if ([cell1.typeLabel.text isEqualToString:@"网格发单"]){
            InModel.requirment_type = @"2";
            
        }
        else{
            InModel.requirment_type = @"1";
            
        }
        
        
        NSArray *  array = [[NSArray alloc] initWithObjects: InModel.requirment_type,[NSString stringWithFormat:@"%@",_price],[NSString stringWithFormat:@"%d",[cell2.price.text intValue]],[NSString stringWithFormat:@"%@",_grid_id],[NSString stringWithFormat:@"%@",userInfoModel.city_name],nil];
        
        NSString *hamcString = [[communcat sharedInstance] ArrayCompareAndHMac:array];
        
        InModel.key = userInfoModel.key;
        InModel.digest = hamcString;
        InModel.grid_id = _grid_id;
        InModel.commission = _price;
        InModel.order_amount= [NSString stringWithFormat:@"%d",[cell2.price.text intValue]];
        InModel.city_name=[NSString stringWithFormat:@"%@",userInfoModel.city_name];
    }
    else{
        NSIndexPath *index2=[NSIndexPath indexPathForRow:1 inSection:0];
        SendOrderViewCell *cell2=[_tableView cellForRowAtIndexPath:index2];
        ///判断订单数量
        if ([cell2.price.text isEqualToString: @"请输入订单总数"] ||cell2.price.text.length==0||!cell2.price.text)
        {
            [[KNToast shareToast]initWithText:@"请输入订单总数" duration:1.5 offSetY:0];
            
            return;
        }
        else if (cell2.price.text.length>5){
            [[KNToast shareToast]initWithText:@"请输入有效的订单数量" duration:1.5 offSetY:0];
            return;
        }
        else if ([cell2.price.text intValue]<=0){
            [[KNToast shareToast]initWithText:@"请输入订单总数" duration:1.5 offSetY:0];
            
            return;
        }
        else{
            
            _numb=[NSString stringWithFormat:@"%d",[cell2.price.text intValue]];
        }
        
        NSIndexPath *index3=[NSIndexPath indexPathForRow:2 inSection:0];
        SendOrderViewCell *cell3=[_tableView cellForRowAtIndexPath:index3];
        ///判断单价
        if ([cell3.price.text isEqualToString: @"请输入订单单价"] ||cell3.price.text.length==0||!cell3.price.text)
        {
            [[KNToast shareToast]initWithText:@"请输入订单单价" duration:1.5 offSetY:0];
            
            return;
        }
        else if (cell3.price.text.length>5){
            [[KNToast shareToast]initWithText:@"请输入有效的订单单价" duration:1.5 offSetY:0];
            return;
        }
        else if ([cell3.price.text floatValue]<0.5){
            [[KNToast shareToast]initWithText:@"订单单价不能低于0.5元,请重新输入订单金额!" duration:1.5 offSetY:0];
            return;
        }
        else{
            
            _price=cell3.price.text;
        }
        NSArray *  array = [[NSArray alloc] initWithObjects:@"2",[NSString stringWithFormat:@"%@",_price],[NSString stringWithFormat:@"%d",[cell2.price.text intValue]],[NSString stringWithFormat:@"%@",_grid_id],[NSString stringWithFormat:@"%@",userInfoModel.city_name],nil];
        
        NSString *hamcString = [[communcat sharedInstance] ArrayCompareAndHMac:array];
        
        InModel.key = userInfoModel.key;
        InModel.digest = hamcString;
        InModel.grid_id = _grid_id;
        InModel.requirment_type = @"2";
        InModel.commission = _price;
        InModel.order_amount= [NSString stringWithFormat:@"%d",[cell2.price.text intValue]];
        InModel.city_name=[NSString stringWithFormat:@"%@",userInfoModel.city_name];

    }
    
    
    PayViewController *VC = [[PayViewController alloc] init];
    VC.money=[_price floatValue]*[_numb intValue];
    VC.numble=[_numb intValue];
    VC.requirment_name=_text;
    if ( [_userInfoModel.user_type containsString:@"5"]){
        
        if ([_type isEqualToString:@"网点发单"]){
            VC.requirment_type=@"1";
        }
        else{
            VC.requirment_type=@"2";
        }
    }
    
    NSIndexPath *index00=[NSIndexPath indexPathForRow:0 inSection:0];
    SendOrderViewCell *cell00 =  [_tableView cellForRowAtIndexPath:index00];
    VC.gridId=_grid_id;
    VC.requirment_name=cell00.distrLabel.text;
    VC.InModel=InModel;
    VC.kind=1;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.1;
    transition.type = @"fade";//翻转
    transition.subtype = kCAGravityTopLeft;
    [[UIApplication sharedApplication].delegate.window.layer addAnimation:transition forKey:@"transition"];
    [self.navigationController pushViewController:VC animated:YES];
    
}

//左侧按钮点击
-(void)leftItemClick{
    
    citySelectVController *citySelect=[[citySelectVController alloc]init];
    citySelect.status = 2;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:citySelect animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark   获取网格 网点发单金额
-(void)getMsgWithType:(NSString *)type{
    
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
    NSString *hmacString = [[communcat sharedInstance] hmac:@"" withKey:userInfoModel.primary_key];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[communcat sharedInstance]getZhanDianMoneyWithKey:userInfoModel.key digest:hmacString resultDic:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //            dispatch_sync(dispatch_get_main_queue(), ^{
                
                DLog(@"列表数据%@",dic);
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    
                    [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                    
                }
                else if (code ==1000)
                {
                    NSDictionary *data=[dic objectForKey:@"data"];
                    if (![_userInfoModel.user_type containsString:@"5"]){
                        if ([type isEqualToString:@"网格发单"])
                        {
                            _price=data[@"grid_commission"];
                        }
                        else if ([type isEqualToString:@"网点发单"]){
                            _price=data[@"dot_commission"];
                        }
                    }
                    NSIndexPath *index=[NSIndexPath indexPathForRow:3 inSection:0];
                    [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
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
    if (_alertKind==alertView) {
        if (buttonIndex==0) {
            _type = @"网格发单";
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationLeft];
            [self getMsgWithType:_type];

            
        }
        else if (buttonIndex==1) {
            _type = @"网点发单";
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationLeft];
            [self getMsgWithType:_type];
            

        }
        else{
            
        }
        
    }
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
