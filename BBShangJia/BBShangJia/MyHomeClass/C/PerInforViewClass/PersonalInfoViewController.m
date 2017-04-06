//
//  PersonalInfoViewController.m
//  CYZhongBao
//
//  Created by xc on 15/11/24.
//  Copyright © 2015年 xc. All rights reserved.
//
#import "ApplyBrokerViewController.h"
#import"PublicSouurce.h"
#import "PersonalInfoViewController.h"
#import "PersonHeadTableViewCell.h"
#import "PersonOtherInfoTableViewCell.h"
#import "binDingVController.h"
#import <Accelerate/Accelerate.h>

@interface PersonalInfoViewController ()<ChangePhoneDelegate,UIGestureRecognizerDelegate>
{
    ///用户头像
    UIImage *_headImg;
    ///头像上传后地址
    NSString *_headImgString;
    ///用户名
    NSString *_userNameString;
    ///性别
    int _sex;
    ///年龄
    NSString *_birthday;
    NSString *_phone;
}

@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UITableView *personTableView;

@property(nonatomic, strong) id<ALBBMediaServiceProtocol> albbMediaService;
@property(nonatomic, strong) TFEUploadNotification *notificationupload1;
@end

@implementation PersonalInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroud;
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    //    //添加头部菜单栏
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 0, 150, 36)];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 36)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = LargeFont;
        _titleLabel.textColor = TextMainCOLOR;
        _titleLabel.text = @"个人信息";
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
    [self.view addSubview:_personTableView];

    ///上传功能初始化
    _albbMediaService =[[TaeSDK sharedInstance] getService:@protocol(ALBBMediaServiceProtocol)];
    _notificationupload1 = [TFEUploadNotification notificationWithProgress:nil success:^(TFEUploadSession *session, NSString *url) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _headImgString = url;
        
        [self updateUserInfoHeader:_headImgString];
        
        [_personTableView reloadData];
    } failed:^(TFEUploadSession *session, NSError *error) {
        //        [[iToast makeText:@"图片上传失败!"] show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];

    _phone=userInfoModel.telephone;
    [self creactRightGesture];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePhone:) name:@"changePhone" object:nil];
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
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)changePhone:(NSNotification *)notif{
//    
////}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if (_personTableView) {
//        [_personTableView reloadData];
//    }
//}
//初始化下单table
-(UITableView *)initpersonTableView
{
    if (_personTableView != nil) {
        return _personTableView;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT;
    
    self.personTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _personTableView.delegate = self;
    _personTableView.dataSource = self;
    _personTableView.backgroundColor = backGroud;
    _personTableView.showsVerticalScrollIndicator = NO;
    
    return _personTableView;
}

//-(AppDelegate*)delegate
//{
//    return (AppDelegate *)[UIApplication sharedApplication].delegate;
//}

#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:UserKey];
    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    static NSString *cellName = @"PersonHeadTableViewCell";
    PersonHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[PersonHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    static NSString *cellName2 = @"PersonOtherInfoTableViewCell";
    PersonOtherInfoTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellName2];
    if (!cell2) {
        cell2 = [[PersonOtherInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName2];
    }
    
    if (indexPath.row == 0) {
        
        if (_headImg) {
            cell.contentImg.image = _headImg;
        }else
        {
            [cell.contentImg setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userInfoModel.header]]]];
            [cell.contentImg sd_setImageWithURL:[NSURL URLWithString:userInfoModel.header] placeholderImage:[UIImage imageNamed:@"矢量智能对象"]];
        }
             cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        if (indexPath.row == 1) {
            
            cell2.titleLable.text = @"绑定手机号";
            cell2.contentLable.text = _phone;
            
        }
//        else if (indexPath.row == 2)
//        {
//            cell2.titleLable.text = @"修改认证信息";
//            cell2.contentLable.text = @"";
//            
//        }
        cell2.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell2;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        _headSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍一张照片",@"从手机相册选择", nil];
        [_headSheet showInView:self.view];
    }else if (indexPath.row == 1)
    {
        
        binDingVController *binding=[[binDingVController alloc]init];
        binding.delegate=self;
        [self.navigationController pushViewController:binding animated:YES];
        
    }
//    else if (indexPath.row == 2)
//    {
//        NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
//        UserInfoSaveModel *userInfo=[NSKeyedUnarchiver unarchiveObjectWithData:data ];
//        //        邦办达人认证状态( -1未认证 0申请中 1审核通过 2审核失败
//        if ([userInfo.authen_status isEqualToString:@"3"]){
//            [[KNToast shareToast]initWithText:@"您的认证信息被注销,不能进行修改" duration:1.5 offSetY:0];
//        }
//        else if ([userInfo.authen_status isEqualToString:@"-1"]){
//            [[KNToast shareToast]initWithText:@"先去认证经济人,再来修改信息吧!" duration:1.5 offSetY:0];
//            
//        }
//        else if ([userInfo.authen_status isEqualToString:@"0"]){
//            [[KNToast shareToast]initWithText:@"您的认证信息正在审核中,暂时还不能修改" duration:1.5 offSetY:0];
//        }
//        else if ([userInfo.authen_status isEqualToString:@"2"]){
//            [[KNToast shareToast]initWithText:@"您的认证信息认证失败,请重新前往认证" duration:1.5 offSetY:0];
//            
//        }
//        else if ([userInfo.authen_status isEqualToString:@"1"]){
//            ApplyBrokerViewController *binding=[[ApplyBrokerViewController alloc]init];
//            binding.status=2;
//            [self.navigationController pushViewController:binding animated:YES];
//            
//        }
//        //        ApplyBrokerViewController *binding=[[ApplyBrokerViewController alloc]init];
//        //        binding.status = 2;
//        //        [self.navigationController pushViewController:binding animated:YES];
//        
//    }
}

//导航栏左右侧按钮点击
- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _headSheet) {
        if (buttonIndex == 1) {
            //  相册
            [self toPhotoPickingController];
        }
        if (buttonIndex == 0) {
            //  拍照
            [self toCameraPickingController];
        }
    }
}


///修改用户信息
- (void)updateUserInfoHeader:(NSString *)headerImg
{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:UserKey];
    
    UserInfoSaveModel * userInfoModel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
        return ;
    }
    NSArray *array=[[NSArray alloc]initWithObjects:@"",headerImg,@"",@"", nil];
    NSString *hmac=[[communcat sharedInstance ]ArrayCompareAndHMac:array];
    
    In_changePhoneModel *inModel=[[In_changePhoneModel alloc]init];
    inModel.key=userInfoModel.key;
    inModel.digest=hmac;
    inModel.header=headerImg;
    inModel.mobile=@"";
    inModel.newmobile=@"";
    inModel.code=@"";
    
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
                    [[LoginViewController new]upDataUserMag];
                    [[KNToast shareToast]initWithText:@"上传头像成功!" duration:1.5 offSetY:0];
                    
                    [self leftItemClick];
                    
                }else{
                    [[KNToast shareToast]initWithText:[dic objectForKey:@"message"] duration:1.5 offSetY:0];
                    DLog(@"%@",[dic objectForKey:@"message"]);
                }
                
            } );
            
        }];
    });
}


///拍照上传头像
- (void)toCameraPickingController
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //        [[iToast makeText:@"该设备不支持拍照!"] show];
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

- (void)toPhotoPickingController
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [[KNToast shareToast]initWithText:@"该设备不支持拍照!" duration:1.5 offSetY:0];
        
        
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
    [_personTableView reloadData];
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbp.labelText = @"头像上传中";
    NSData *imageData1;
    if (UIImagePNGRepresentation(_headImg) == nil) {
        
        imageData1 = UIImageJPEGRepresentation(_headImg, 0.3);
        
    } else {
        
        imageData1 = UIImagePNGRepresentation(_headImg);
    }
    //        statstatic2016gz/user/approve
    
    TFEUploadParameters *params1 = [TFEUploadParameters paramsWithData:imageData1 space:@"statstatic2016gz" fileName:[self uniqueString] dir:@"user/headerImg"];
    
    [_albbMediaService upload:params1 options:nil notification:_notificationupload1];
    
}

//日期选择代理
//- (void)getSelectDate:(NSString *)date type:(DateType)type {
//    NSLog(@"%d - %@", type, date);
//    _birthday = date;
//    [_personTableView reloadData];
//}

///获取随机不重复字符串
- (NSString*) uniqueString
{
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);
    NSString	*uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}
#pragma mark 改变手机号
-(void)hadChangePhone:(NSString *)phone;{
    _phone=phone;
//    NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:0];
//    PersonOtherInfoTableViewCell *cell=[_personTableView cellForRowAtIndexPath:index];
//    cell.contentLable.text=phone;
    [_personTableView reloadData];
}

@end
