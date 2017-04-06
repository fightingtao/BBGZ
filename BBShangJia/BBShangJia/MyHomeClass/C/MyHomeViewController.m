//
//  MyHomeViewController.m
//  BBShangJia
//
//  Created by cbwl on 16/9/24.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "MyHomeViewController.h"
#import "PublicSouurce.h"
#import"BillRecordViewController.h"//发单记录
#import "historyVController.h"//历史订单
#import "FeedBackViewController.h"//意见反馈
#import "MyWalletViewController.h"//我的钱包
#import "ApplyBrokerViewController.h"//雇主认证
#import"SettingViewController.h"//设置
#import <Accelerate/Accelerate.h>
#import"PersonalInfoViewController.h"

@interface MyHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    ///用户头像
    UIImage *_headImg;
    ///头像上传后地址
    NSString *_headImgString;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIButton *headBtn;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UIButton *settingBtn;

@property(nonatomic, strong) id<ALBBMediaServiceProtocol> albbMediaService;
@property(nonatomic, strong) TFEUploadNotification *notificationupload1;

@property (nonatomic, strong) UIAlertController *alert;//更改头像
@property (nonatomic,copy) NSString *userKind;  // 1 个人用户 2商户
@property (nonatomic, strong)  UserInfoSaveModel * userInfoModel;
@property (nonatomic,strong)  UIAlertView *approve;//去雇主认证
@end

@implementation MyHomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    
    UserInfoSaveModel * userInfoModel;
    if (data && data.length>0){
        
        userInfoModel   = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        _userInfoModel=userInfoModel;
    }
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""] ||!userInfoModel.key) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        
          }
     else   if ([userInfoModel.user_status isEqualToString:@"0"]){
        [[KNToast shareToast]initWithText:@"您的账号已被冻结!" duration:1.5 offSetY:0];
        
        return;
        
    }
    else{
        [[LoginViewController new]upDataUserMag];
        
    }
    
    if (![userInfoModel.user_type isEqualToString:@"1"]){
        
        if ([userInfoModel.authen_status isEqualToString:@"-1"]||[userInfoModel.authen_status isEqualToString:@"2"]){
            if (_tableView){
                [_tableView reloadData];
            }
            _approve=[[UIAlertView alloc]initWithTitle:@"用户提示" message:@"经过雇主认证之后就可以赚钱了!" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"马上去", nil];
            [_approve show];
            return;
        }
        
    }
    _userKind=userInfoModel.user_type;
    if (_tableView){
        [_tableView reloadData];
    }
 }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroud;
    //    self.navigationController.navigationBar.hidden = YES;
    
    [self initTableView];
//    self.tableView.tableHeaderView = _headerView;
    self.tableView.rowHeight = 50;
    
    ///上传功能初始化
    _albbMediaService =[[TaeSDK sharedInstance] getService:@protocol(ALBBMediaServiceProtocol)];
    _notificationupload1 = [TFEUploadNotification notificationWithProgress:nil success:^(TFEUploadSession *session, NSString *url) {
        
        _headImgString = url;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[PersonalInfoViewController new]updateUserInfoHeader:_headImgString];
 
    
        [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"矢量智能对象"]];
        
    } failed:^(TFEUploadSession *session, NSError *error) {
        
        [[KNToast shareToast] initWithText:@"图片上传失败!" duration:2 offSetY:0];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeInfoImageHeader:) name:@"changeheaderimage" object:nil];

}
-(void)dealloc{
  
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark 初始化tableView
-(void)initTableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor =  [UIColor colorWithRed:0.9608 green:0.9608 blue:0.9608 alpha:1.0];
        _tableView.showsVerticalScrollIndicator = NO;
        //        _tableView.scrollEnabled = NO;
        [self.view addSubview:_tableView];
    }
}

#pragma mark 个人商家头像变化了
-(void)ChangeInfoImageHeader:(NSNotification *)notif{
    [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[notif object]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"矢量智能对象"]];
    _phoneLabel.text =_userInfoModel.telephone;
    if (_tableView){
                [_tableView reloadData];
    }
  }

#pragma mark 头像被点击
-(void)headBtnClick{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfoModel;
    
    if (data && data.length>0){
        
        userInfoModel   = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
    }
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        LoginViewController *login = [[LoginViewController alloc] init];
 
        [self.navigationController pushViewController:login animated:YES];
        return ;
    }
  
    if(![_userKind isEqualToString:@"1"]){
        PersonalInfoViewController *VC = [[PersonalInfoViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        _alert = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* button0 = [UIAlertAction
                                  actionWithTitle:@"取消"
                                  style:UIAlertActionStyleCancel
                                  handler:^(UIAlertAction * action)
                                  {
                                      
                                  }];
        
        UIAlertAction *button1 = [UIAlertAction actionWithTitle:@"拍一张照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            [self toCameraPickingController];
        }];
        
        UIAlertAction *button2 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self toPhotoPickingController];
        }];
        [_alert addAction:button0];
        [_alert addAction:button1];
        [_alert addAction:button2];
        [self presentViewController:_alert animated:YES completion:nil];
        
    }
}

#pragma mark 设置按钮被点击

-(void)settingBtnClick{
    
    SettingViewController *VC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma  mark -------tableView delegate-------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (![_userKind isEqualToString:@"1"]){
        
        return 3;
    }
    else{
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 3;
    }else if (section == 1){
        if (![_userKind isEqualToString:@"1"]){
            return 1;
        }
        else{
            return 2;
        }
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0){
        return 170;
    }
    else{
    return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
       
        
            _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
            _headerView.backgroundColor = MainColor;
     
            _headBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, 50, 60, 60)];
//            [_headBtn setImage:[UIImage imageNamed:@"矢量智能对象"] forState:UIControlStateNormal];
            _headBtn.clipsToBounds = YES;
            _headBtn.layer.cornerRadius = 30;
            [_headBtn addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:_headBtn];
       
            
            _settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 10, 30, 30)];
            [_settingBtn setImage:[UIImage imageNamed:@"btn_setup"] forState:UIControlStateNormal];
            [_settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:_settingBtn];
      
            
            _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _headBtn.y +_headBtn.height +10, SCREEN_WIDTH-40, 20)];
            _phoneLabel.text =@"$$$$$$$$$$$$";
            _phoneLabel.textColor = [UIColor whiteColor];
            _phoneLabel.font = [UIFont systemFontOfSize:15];
            _phoneLabel.textAlignment =NSTextAlignmentCenter;
            [_headerView addSubview:_phoneLabel];

    if (_userInfoModel&&_userInfoModel.key.length>0) {
            _phoneLabel.text =_userInfoModel.telephone;
        [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_userInfoModel.header] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"矢量智能对象"]];
        }
        return _headerView;
    }
    else{
        return nil;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfo;
    if (data&&data.length>0){
        userInfo=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        
    }


    if(indexPath.section == 0){
        if (indexPath.row == 0){
            cell.imageView.image = [UIImage imageNamed:@"icon_seth"];
            cell.textLabel.text = @"发单记录";
            
        }else if (indexPath.row== 1){
            cell.imageView.image = [UIImage imageNamed:@"icon_mypack"];
            cell.textLabel.text = @"我的钱包";
        }else{
            cell.imageView.image = [UIImage imageNamed:@"icon_hisorder"];
            cell.textLabel.text = @"历史订单";
        }
        
    }else if (indexPath.section == 1){
        if (![_userKind isEqualToString:@"1"]){
            cell.imageView.image = [UIImage imageNamed:@"icon_businesssure"];
            cell.textLabel.text = @"雇主认证";
            if ([userInfo.authen_status isEqualToString:@"0"]){
               cell.detailTextLabel.text=@"审核中";
            }
            else if ([userInfo.authen_status isEqualToString:@"1"]){
                cell.detailTextLabel.text=@"已认证";
                
            }
            else if ([userInfo.authen_status isEqualToString:@"2"]){
                cell.detailTextLabel.text=@"认证失败";
            }
            
            else{
                cell.detailTextLabel.text=@"未认证";

            }

        }
        else{
            if (indexPath.row == 0){
                cell.imageView.image = [UIImage imageNamed:@"icon_opinion"];
                cell.textLabel.text = @"意见反馈";
                
            }else{
                cell.imageView.image = [UIImage imageNamed:@"icon_contackus"];
                cell.textLabel.text = @"联系客服";
            }
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0){
            cell.imageView.image = [UIImage imageNamed:@"icon_opinion"];
            cell.textLabel.text = @"意见反馈";
            
        }else{
            cell.imageView.image = [UIImage imageNamed:@"icon_contackus"];
            cell.textLabel.text = @"联系客服";
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
}

#pragma mark ------------tableViewDidSelected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    UserInfoSaveModel * userInfo;
    if (data&&data.length>0){
        userInfo=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        
    }
    ///判断请登录
    if (userInfo.key.length==0||[userInfo.key isEqualToString:@""]||!userInfo.key){
        [[KNToast shareToast]initWithText:@"您还没有登录,请登录!" duration:1.5 offSetY:0];
        
        return;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BillRecordViewController *VC = [[BillRecordViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            
        }else if (indexPath.row == 1){
            MyWalletViewController *VC = [[MyWalletViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }else{
            historyVController *VC = [[historyVController alloc] init];
            
            [self.navigationController pushViewController:VC animated:YES];
            
        }
        
    }else if (indexPath.section == 1){
        
        
        if (![_userKind isEqualToString:@"1"]){
            
            if ([userInfo.authen_status isEqualToString:@"0"]){
                [[KNToast shareToast]initWithText:@"您的认证信息正在处理,请耐心等待" duration:1.5 offSetY:0];
                return;
                
            }
            else if ([userInfo.authen_status isEqualToString:@"1"]){
                [[KNToast shareToast]initWithText:@"审核通过,您可以去赚钱了!" duration:1.5 offSetY:0];
                return;
                
            }
            else if ([userInfo.authen_status isEqualToString:@"2"]){
                [[KNToast shareToast]initWithText:@"认证失败,请重新认证" duration:1.5 offSetY:0];
                
                ApplyBrokerViewController * approver=[[ApplyBrokerViewController alloc]init];
                approver.status=1;
                [self.navigationController pushViewController:approver animated:YES];
                return;
                
            }
            
            else{
                ApplyBrokerViewController * approver=[[ApplyBrokerViewController alloc]init];
                approver.status=1;
                [self.navigationController pushViewController:approver animated:YES];
            }
        }
        else{
            if (indexPath.row == 0) {
                FeedBackViewController *VC = [[FeedBackViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
                
            }else{
//                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",userInfo.hotline];//要修改
//                UIWebView * callWebview = [[UIWebView alloc] init];
//                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//                [self.view addSubview:callWebview];
                [self goPhoneClickWithPhoneNumble:[NSString stringWithFormat:@"%@",userInfo.hotline]];

            }
        }
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            FeedBackViewController *VC = [[FeedBackViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            
        }else{
            
//            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[NSString stringWithFormat:@"%@",userInfo.hotline]];//要修改
//            UIWebView * callWebview = [[UIWebView alloc] init];
//            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//            [self.view addSubview:callWebview];
            [self goPhoneClickWithPhoneNumble:[NSString stringWithFormat:@"%@",userInfo.hotline]];
        }
    }
}
#pragma mark  服务热线
-(void)goPhoneClickWithPhoneNumble:(NSString *)phone
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:phone message:nil preferredStyle:UIAlertControllerStyleAlert];
    // 设置popover指向的item
    alert.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString* phoneStr = [NSString stringWithFormat:@"tel://%@",phone];
        if ([phoneStr hasPrefix:@"sms:"] || [phoneStr hasPrefix:@"tel:"]) {
            UIApplication * app = [UIApplication sharedApplication];
            if ([app canOpenURL:[NSURL URLWithString:phoneStr]]) {
                [app openURL:[NSURL URLWithString:phoneStr]];
            }
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
///拍照上传头像
- (void)toCameraPickingController
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [[KNToast shareToast] initWithText:@"该设备不支持拍照!"];
        return;
    }
    else {
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.view.backgroundColor = [UIColor blackColor];
        cameraPicker.delegate = self;
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.allowsEditing = YES;
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
//从相册中获取
- (void)toPhotoPickingController
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [[KNToast shareToast] initWithText:@"该设备不支持拍照!"];
        return;
    }
    else {
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        photoPicker.view.backgroundColor = [UIColor whiteColor];
        photoPicker.delegate = self;
        photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        photoPicker.allowsEditing = YES;
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

//图片选择代理
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
    
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    _headImg = img;
    [self.tableView reloadData];
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbp.labelText = @"头像上传中";
    NSData *imageData1;
    if (UIImagePNGRepresentation(_headImg) == nil) {
        
        imageData1 = UIImageJPEGRepresentation(_headImg,0.2);
        
    } else {
        
        imageData1 = UIImagePNGRepresentation(_headImg);
    }
    //        statstatic2016gz/user/approve
    
    TFEUploadParameters *params1 = [TFEUploadParameters paramsWithData:imageData1 space:@"statstatic2016gz" fileName:[self uniqueString] dir:@"user/headerImg"];
    
    [_albbMediaService upload:params1 options:nil notification:_notificationupload1];
}

//#pragma mark 头像保存到本地
//-(void)saveheaderImageToDocument{
//    NSUserDefaults *userDefault1 = [NSUserDefaults standardUserDefaults];
//    NSData *userData1 = [userDefault1 objectForKey:UserKey];
////    UserInfoSaveModel *outModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData1];
//
//
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
////    UserInfoSaveModel *saveModel = [[UserInfoSaveModel alloc] init];
//
//
//}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView==_approve) {
        if (buttonIndex==1) {
            ApplyBrokerViewController * approver=[[ApplyBrokerViewController alloc]init];
            approver.status=1;
            [self.navigationController pushViewController:approver animated:YES];
            
        }
    }
}
///获取随机不重复字符串
- (NSString*) uniqueString
{
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);
    NSString	*uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}
//
//#pragma mark - Cell出现时或者刷新的动画
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //缩放
//    cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
//    [UIView animateWithDuration:1 animations:^{
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    }];
//    
//}



@end
