//
//  ApplyBrokerViewController.m
//  CYZhongBao
//
//  Created by xc on 15/11/25.
//  Copyright © 2015年 xc. All rights reserved.
//

#import "ApplyBrokerViewController.h"
#import "ApplyBrokerInfoTableViewCell.h"
#import "ApplyBrokerImgTableViewCell.h"
#import "ApplyBrokerTestTableViewCell.h"
#import "LoginViewController.h"
#import "citySelectVController.h"
//选择城市

@interface ApplyBrokerViewController ()<ApplyInfoDelegate,IdImgDelegate>
{
    ///当前选择图片的类型 1是正面照 2是反面照 3是手持照
    int _currentImgType;
    ///上传的身份证图片
    UIImage *_positiveImg;
    UIImage *_negativeImg;
    UIImage *_handIdImg;
    ///上传图片后图片地址
    NSString *_positiveImgString;
    NSString *_negativeImgString;
    NSString *_handIdImgString;
    ///身份信息
    NSString *_realNameString;
    NSString *_realPhoneString;//支付宝账户
    NSString *_realIdString;
    ///上传图片索引
    int _uploadIndex;
    NSString *_city;//城市名字
}

@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UITableView *applyTableView;
@property (nonatomic, strong) UIView *dealView;
@property (nonatomic, strong) UIButton *applyBtn;
@property (nonatomic, strong) UIView *checkView;
@property (nonatomic, strong) UIButton *delegateBtn;
@property (nonatomic, strong) NSMutableArray  *cityAry;

@property(nonatomic, strong) id<ALBBMediaServiceProtocol> albbMediaService;
@property(nonatomic, strong) TFEUploadNotification *notificationupload1;
@property(nonatomic, strong) TFEUploadNotification *notificationupload2;
@property(nonatomic, strong) TFEUploadNotification *notificationupload3;

@end

@implementation ApplyBrokerViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=false;
    self.navigationController.navigationBar.hidden=NO;
    self.hidesBottomBarWhenPushed=YES;
    self.tabBarController.tabBar.hidden=YES;
    if (_status==2){
        [[[LoginViewController alloc]init] upDataUserMag];
        
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    _status=2;
    
    self.view.backgroundColor = backGroud;
    self.automaticallyAdjustsScrollViewInsets=false;
    _cityAry=[[NSMutableArray alloc]initWithCapacity:0];
    //添加头部菜单栏
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 0, 150, 36)];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 36)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = LargeFont;
        _titleLabel.textColor = TextMainCOLOR;
        _titleLabel.text = @"雇主认证";
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
    [self initpersonTableView];
    [self.view addSubview:_applyTableView];
    
    if (!_dealView) {
        _dealView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-50, SCREEN_WIDTH, 100)];
        _dealView.backgroundColor = backGroud;
        
        // [self.view addSubview:_dealView];
    }
    _applyTableView.tableFooterView=_dealView;
    if (!_applyBtn) {
        _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyBtn.frame = CGRectMake(20,30, SCREEN_WIDTH-40, 40);
        
        [_applyBtn addTarget:self action:@selector(applyBrokerClick) forControlEvents:UIControlEventTouchUpInside];
        _applyBtn.layer.borderColor = TextMainCOLOR.CGColor;
        _applyBtn.layer.borderWidth = 0.5;
        _applyBtn.layer.cornerRadius = 10;
        _applyBtn.clipsToBounds=YES;
        [_applyBtn setBackgroundImage:[[communcat sharedInstance] createImageWithColor:MainColor] forState:UIControlStateNormal];
        [_applyBtn setBackgroundImage:[[communcat sharedInstance] createImageWithColor:MainColor] forState:UIControlStateHighlighted];
        [_applyBtn setTitleColor:TextMainCOLOR forState:UIControlStateNormal];
        _applyBtn.titleLabel.font = MiddleFont;
        [_dealView addSubview:_applyBtn];
        if (_status==2){
            [_applyBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        }
        else{
            [_applyBtn setTitle:@"提交认证" forState:UIControlStateNormal];
            
        }
    }
    
    if (!_checkView) {
        _checkView = [[UIView alloc] initWithFrame:CGRectMake(0,10, SCREEN_WIDTH, 50)];
        _checkView.backgroundColor = backGroud;
    }
    
    if (!_delegateBtn) {
        _delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_delegateBtn setBackgroundImage:[UIImage imageNamed:@"提交.png"] forState:UIControlStateNormal];
        [_delegateBtn addTarget:self action:@selector(delegateClick) forControlEvents:UIControlEventTouchUpInside];
        //  [_checkView addSubview:_delegateBtn];
    }
    
    _delegateBtn.sd_layout.centerXEqualToView(_checkView)
    .heightIs(45)
    .topSpaceToView(_checkView,10)
    .widthIs(280);
    
    ///上传功能初始化
    _albbMediaService =[[TaeSDK sharedInstance] getService:@protocol(ALBBMediaServiceProtocol)];
    _uploadIndex = 0;
    
    //正面照上传回调
    _notificationupload1 = [TFEUploadNotification notificationWithProgress:nil success:^(TFEUploadSession *session, NSString *url) {
        _uploadIndex = 0;
        
        _uploadIndex++;
        _positiveImgString = url;
        [self allContentSubmit];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failed:^(TFEUploadSession *session, NSError *error) {
        [[KNToast shareToast]initWithText:@"图片上传失败!" duration:1.5 offSetY:0];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    //反面照上传回调
    _notificationupload2 = [TFEUploadNotification notificationWithProgress:nil success:^(TFEUploadSession *session, NSString *url) {
        
        _uploadIndex++;
        _negativeImgString = url;
        [self allContentSubmit];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failed:^(TFEUploadSession *session, NSError *error) {
        [[KNToast shareToast]initWithText:@"图片上传失败!" duration:1.5 offSetY:0];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    //手持照上传回调
    _notificationupload3 = [TFEUploadNotification notificationWithProgress:nil success:^(TFEUploadSession *session, NSString *url) {
        
        _uploadIndex++;
        _handIdImgString = url;
        [self allContentSubmit];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failed:^(TFEUploadSession *session, NSError *error) {
        [[KNToast shareToast]initWithText:@"图片上传失败!" duration:1.5 offSetY:0];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCityWithName:) name:@"city" object:nil];
    _applyBtn.enabled=YES;
    
    
}
-(void)didSelectCityWithName:(NSNotification*) notification
{
    NSString *  cityname = [notification object];//通过这个获取到传递的对象
    _city = cityname;
    DLog(@"选择城市%@",cityname);
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];
    ApplyBrokerInfoTableViewCell *cell=[_applyTableView cellForRowAtIndexPath:index];
    [cell.address  setTitle:cityname forState:UIControlStateNormal];
    [cell.address setTitleColor:kTextMainCOLOR forState:UIControlStateNormal];
    
}
-(void)dealloc{
    
    [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"city" object:nil];
    
}


#pragma mark 初始化下单table
-(UITableView *)initpersonTableView
{
    if (_applyTableView != nil) {
        return _applyTableView;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT-64;
    
    self.applyTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _applyTableView.delegate = self;
    _applyTableView.dataSource = self;
    _applyTableView.backgroundColor = backGroud;
    // _applyTableView.backgroundColor = [UIColor redColor];
    
    _applyTableView.showsVerticalScrollIndicator = NO;
    //    _applyTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    return _applyTableView;
}

#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 10.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 0.01;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    if (section == 0) {
    //        return _tipLabel;
    //    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return _checkView;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  [ApplyBrokerInfoTableViewCell cellHeight];
    }else if (indexPath.section == 1)
    {
        return [ApplyBrokerImgTableViewCell cellHeight];
    }
    return 50;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (indexPath.section == 0) {
        static NSString *cellName = @"ApplyBrokerInfoTableViewCell";
        ApplyBrokerInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[ApplyBrokerInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
//        _city=userInfoModel.city_name;
        if(![_city isEqualToString:@""] && _city.length!=0){
            [cell.address  setTitle:_city forState:UIControlStateNormal];
            [cell.address setTitleColor:kTextMainCOLOR forState:UIControlStateNormal];
            
        }
        else if( _city.length==0) {
            [cell.address  setTitle:@"请选择城市" forState:UIControlStateNormal];
        }
        if (_status==2){
            cell.nameTextField.enabled=NO;
            cell.idTextField.enabled=NO;
            cell.nameTextField.text=userInfoModel.realname;
            cell.idTextField.text=userInfoModel.idcard_no;
            
            
        }
        cell.delegate = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        static NSString *cellName = @"ApplyBrokerImgTableViewCell";
        ApplyBrokerImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[ApplyBrokerImgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        if (_status==2) {
            cell.idImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userInfoModel.positive_idcard]]];
            
            cell.idImg2.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userInfoModel.opposite_idcard]]];
            cell.idImg3.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userInfoModel.hand_idcard]]];
            
            //                        cell.idImg.frame=CGRectMake(SCREEN_WIDTH-ImgBackWidth-ImgWidth, 20,400, 200);
            //                        cell.idImg2.frame=CGRectMake(SCREEN_WIDTH-ImgBackWidth-ImgWidth, ImgHeight+40,400, 200);
            //                        cell.idImg3.frame=CGRectMake(SCREEN_WIDTH-ImgBackWidth-ImgWidth, ImgHeight*2+70,400, 200);
            
            //                        DLog(@"头箱地址%@*****%@****%@",userInfoModel.positive_idcard,userInfoModel.opposite_idcard,userInfoModel.hand_idcard);
        }
        else{
            if (_positiveImg) {
                cell.idImg.image = _positiveImg;
            }
            
            if (_negativeImg) {
                cell.idImg2.image = _negativeImg;
            }
            
            if (_handIdImg) {
                cell.idImg3.image = _handIdImg;
            }
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //            BrokerTrainViewController *trainVC = [[BrokerTrainViewController alloc] init];
            //            trainVC.delegate = self;
            //            [self.navigationController pushViewController:trainVC animated:YES];
        }else
        {
            //            BrokerTestViewController *testVC = [[BrokerTestViewController alloc] init];
            //            testVC.delegate = self;
            //            [self.navigationController pushViewController:testVC animated:YES];
        }
    }
}

///提交申请，上传图片
- (void)applyBrokerClick
{
    //    [self allContentSubmit];
    _applyBtn.enabled=NO;
    DLog(@"上传头像");
    if (_status==2) {
        [self allContentSubmit];
        
    }
    else{
        if (!_realNameString || [_realNameString isEqualToString:@""]) {
            [[KNToast shareToast]initWithText:@"请输入真实姓名!" duration:1.5 offSetY:0];
            return;
        }
        
        
        if (!_realIdString || [_realIdString isEqualToString:@""]) {
            [[KNToast shareToast]initWithText:@"请输入身份证号!" duration:1.5 offSetY:0];
            
            return;
        }
        
        if (!_positiveImg) {
            [[KNToast shareToast]initWithText:@"请上传身份证正面照!" duration:1.5 offSetY:0];
            
            return;
        }
        if (!_negativeImg) {
            [[KNToast shareToast]initWithText:@"请上传身份证反面照!" duration:1.5 offSetY:0];
            
            return;
        }
        if (!_handIdImg) {
            [[KNToast shareToast]initWithText:@"请上传身份证手持照!" duration:1.5 offSetY:0];
            
            return;
        }
        
        //    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //    mbp.labelText = @"资料上传中";
        
        NSData *imageData1;
        if (UIImagePNGRepresentation(_positiveImg) == nil) {
            
            imageData1 = UIImageJPEGRepresentation(_positiveImg, 1);
            
        } else {
            
            //imageData1 = UIImagePNGRepresentation(_positiveImg);
            //        UIImage *image1 = [self imageCompressWithSimple:_positiveImg scaledToSize:_positiveImg.size];
            imageData1 = UIImageJPEGRepresentation(_positiveImg, 0.3f);
            
        }
        NSData *imageData2;
        if (UIImagePNGRepresentation(_negativeImg) == nil) {
            
            imageData2 = UIImageJPEGRepresentation(_negativeImg, 1);
            
        } else {
            
            //imageData2 = UIImagePNGRepresentation(_negativeImg);
            //            UIImage *image2 = [self imageCompressWithSimple:_negativeImg scaledToSize:_positiveImg.size];
            imageData2 = UIImageJPEGRepresentation(_negativeImg, 0.3f);
            
        }
        
        NSData *imageData3;
        if (UIImagePNGRepresentation(_handIdImg) == nil) {
            
            imageData3 = UIImageJPEGRepresentation(_handIdImg, 1);
            
        } else {
            
            //imageData3 = UIImagePNGRepresentation(_handIdImg);
            //            UIImage *image3 = [self imageCompressWithSimple:_handIdImg scaledToSize:_positiveImg.size];
            imageData3 = UIImageJPEGRepresentation(_handIdImg, 0.3f);
            
        }
        //        statstatic2016gz/user/approve
        //        statstatic2016gz/produce.client
        TFEUploadParameters *params1 = [TFEUploadParameters paramsWithData:imageData1 space:@"statstatic2016gz" fileName:[self uniqueString] dir:@"user/approve"];
        
        TFEUploadParameters *params2 = [TFEUploadParameters paramsWithData:imageData2 space:@"statstatic2016gz" fileName:[self uniqueString] dir:@"user/approve"];
        TFEUploadParameters *params3 = [TFEUploadParameters paramsWithData:imageData3 space:@"statstatic2016gz" fileName:[self uniqueString] dir:@"user/approve"];
        [_albbMediaService upload:params1 options:nil notification:_notificationupload1];
        [_albbMediaService upload:params2 options:nil notification:_notificationupload2];
        [_albbMediaService upload:params3 options:nil notification:_notificationupload3];
    }
}

#pragma mark 提交认证信息
- (void)allContentSubmit
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if (_status == 2) {
        if (_city.length==0||!_city||[_city isEqualToString:@""]){
            [[KNToast shareToast]initWithText:@"意向城市不能为空!" duration:1.5 offSetY:0];
            _applyBtn.enabled=YES;
            
            return;
        }
        MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbp.labelText = @"信息正在提交中...";
        
        NSArray *dataArray = [[NSArray alloc] initWithObjects:_city,@"1", userInfoModel.positive_idcard,userInfoModel.opposite_idcard,userInfoModel.hand_idcard,userInfoModel.realname,userInfoModel.idcard_no,nil];
        NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
        approve_InModel *inModel = [[approve_InModel alloc] init];
        inModel.key = userInfoModel.key;
        inModel.degist = hmacString;
        inModel.update_city =@"1";
        inModel.city_name=_city;
        inModel.positive_idcard = userInfoModel.positive_idcard;
        inModel.opposite_idcard =  userInfoModel.opposite_idcard;
        inModel.hand_idcard =  userInfoModel.hand_idcard;
        inModel.username =  userInfoModel.realname;
        inModel.idcardno =  userInfoModel.idcard_no;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[communcat sharedInstance]changeApproveMsgWithModel:inModel resultDic:^(NSDictionary *dic) {
                dispatch_async(dispatch_get_main_queue(), ^{

                [MBProgressHUD hideHUDForView:self.view animated:YES];
                _applyBtn.enabled=YES;
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                    
                    
                }else if (code ==1000)
                {
                    UIAlertView *alert=  [[UIAlertView alloc]initWithTitle:@"修改信息提交成功" message:@"您已成功xiugai" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];

                    [[[LoginViewController alloc]init] upDataUserMag];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                }
                           });
            }];
        });
        
    }
    else{
        DLog(@"_upload***%d",_uploadIndex);
        
        if (_positiveImgString.length == 0||!_positiveImgString){
            //                  [[KNToast shareToast]initWithText:@"上传图片信息失败,请重新上传" duration:1.5 offSetY:0];
            _applyBtn.enabled=YES;
            
            return;
        }
        
        if (_negativeImgString.length==0||!_negativeImgString){
            //[[KNToast shareToast]initWithText:@"上传图片信息失败,请重新上传" duration:1.5 offSetY:0];
            _applyBtn.enabled=YES;
            
            return;
        }
        if (_handIdImgString.length==0||!_handIdImgString){
            //                [[KNToast shareToast]initWithText:@"上传图片信息失败,请重新上传" duration:1.5 offSetY:0];
            _applyBtn.enabled=YES;
            
            return;
        }
        
        if (_city.length==0 ||!_city||[_city isEqualToString:@""]){
            [[KNToast shareToast]initWithText:@"无法上传城市信息" duration:1.5 offSetY:0];
            _applyBtn.enabled=YES;
            
            return;
        }
        
        if ([[communcat sharedInstance]checkUserIdCard:_realIdString] == NO){
            [[KNToast shareToast]initWithText:@"身份证号信息不正确" duration:1.5 offSetY:0];
            _applyBtn.enabled=YES;
            
            return;
        }
        
        MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbp.labelText = @"信息正在提交中...";
        
        //    _city = @"南京市";
        NSArray *dataArray = [[NSArray alloc] initWithObjects:_positiveImgString,_negativeImgString,_handIdImgString,_realNameString,_realIdString,_city,nil];
        NSString *hmacString = [[communcat sharedInstance] ArrayCompareAndHMac:dataArray];
        approve_InModel *inModel = [[approve_InModel alloc] init];
        inModel.key = userInfoModel.key;
        inModel.degist = hmacString;
        inModel.positive_idcard = _positiveImgString;
        inModel.opposite_idcard = _negativeImgString;
        inModel.hand_idcard = _handIdImgString;
        inModel.username = _realNameString;
        inModel.idcardno = _realIdString;
        inModel.city_name=_city;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[communcat sharedInstance]getApproveMsgWithModel:inModel resultDic:^(NSDictionary *dic) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                DLog(@"达人认证%@",dic);
                int code=[[dic objectForKey:@"code"] intValue];
                if (!dic)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [[KNToast shareToast]initWithText:@"网络不给力,请稍后重试!" duration:1.5 offSetY:0];
                    
                }
                else if (code ==1000)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    UIAlertView *alert=  [[UIAlertView alloc]initWithTitle:@"信息提交成功" message:@"我们将在二个工作日内作出结果,请耐心等待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                    [[[LoginViewController alloc]init] upDataUserMag];
                    
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                    
                }
                 });
            }];
        });
    }
    _applyBtn.enabled=YES;
    
}



#pragma mark 填写信息
- (void)delegateClick{
    [self applyBrokerClick];
    
}
#pragma ApplyInfoDelegate 申请信息代理
- (void)setAgentInfo:(NSString *)string andType:(int)type;
{
    if (type == 1) {
        _realNameString = string;
    }else if (type == 2)
    {
        _realPhoneString = string;
    }else
    {
        _realIdString = string;
        
        if ([[communcat sharedInstance]checkUserIdCard:string] == NO){
            //            [[iToast makeText:@"身份证号信息不正确"]show];
            
        }
    }
}


#pragma IdImgDelegate  选择图片代理
- (void) idImgChoose:(int)type
{
    if (_status==2) {
        
        
    }
    else{
        _currentImgType = type;
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍一张照片",@"从手机相册选择", nil];
        [as showInView:self.view];
        
    }
}

//导航栏左右侧按钮点击
- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //  相册
        [self toPhotoPickingController];
    }
    if (buttonIndex == 0) {
        //  拍照
        [self toCameraPickingController];
    }
}


- (void)toCameraPickingController
{
    //    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return;
    }
    else {
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.view.backgroundColor = [UIColor blackColor];
        cameraPicker.delegate = self;
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
            [self.navigationController presentViewController:cameraPicker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }];
        }
        else {
            
            [self.navigationController presentViewController:cameraPicker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }];
        }
    }
}

- (void)toPhotoPickingController
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        return;
    }
    else {
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        photoPicker.view.backgroundColor = [UIColor whiteColor];
        photoPicker.delegate = self;
        photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
            [self.navigationController presentViewController:photoPicker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }];
        }
        else {
            [self.navigationController presentViewController:photoPicker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }];
    }
    else {
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }];
    }
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (_currentImgType ==1) {
        _positiveImg = img;
    }else if (_currentImgType == 2)
    {
        _negativeImg = img;
    }else
    {
        _handIdImg = img;
    }
    [_applyTableView reloadData];
    
}

///获取随机不重复字符串
- (NSString*) uniqueString
{
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);
    NSString	*uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}

- (UIImage*)imageCompressWithSimple:(UIImage*)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0,0,1300,900)];
    UIImage* newImage =
    UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark 选择城市
-(void)choceAddressBtnClick{
    citySelectVController *city=[[citySelectVController alloc]init];
    city.status=1;
    [self.navigationController pushViewController:city animated:YES];
}
@end
