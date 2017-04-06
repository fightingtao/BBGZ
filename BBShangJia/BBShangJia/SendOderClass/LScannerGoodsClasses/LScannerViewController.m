//
//  LScannerViewController.m
//  CYZhongBao
//
//  Created by xc on 16/1/19.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "LScannerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScannerListTableViewCell.h"
#define Height [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width
#define XCenter self.view.center.x
#define YCenter self.view.center.y

#define SHeight 20
#define SWidth (XCenter+30)
@interface LScannerViewController ()<UITableViewDataSource,UITableViewDelegate,ScannerGoodsDelegate>
{
   
    NSString *_order_id;
     UIImageView * imageView;
    NSInteger _index; //记录哪个按钮被点击

}

@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIView *scannerView;
@property (nonatomic, strong) UITableView *goodsTableview;
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)UIButton *footerBtn;
@property(nonatomic,copy) NSMutableArray *goodsArray;
@property(nonatomic,strong)AVAudioPlayer *avAudioPlayer;
@property(nonatomic,copy) NSString *  path;//声音名字
@property(nonatomic,copy) NSString *  type;//声音格式
@end

@implementation LScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
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
        _titleLabel.text = @"领货";
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
    
 
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake((Width-SWidth)/2,50,SWidth,SWidth)];
    imageView.image = [UIImage imageNamed:@"saomiao.png"];
    [self.view addSubview:imageView];
    
    UILabel * labIntroudction = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.y +imageView.height +5, SCREEN_WIDTH, 20)];
    [labIntroudction setText:@"将二维码/条形码放入取景框中即可自动扫描"];
    labIntroudction.font = [UIFont systemFontOfSize:15];
    [labIntroudction setTextColor:[UIColor whiteColor]];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labIntroudction];
    [self.view bringSubviewToFront:labIntroudction];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5, SWidth-10,1)];
    _line.image = [UIImage imageNamed:@"saomiao1.png"];
    [self.view addSubview:_line];
    

  timer = [NSTimer timerWithTimeInterval:.01 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [self setupCamera];
    [self inithomeTableView];
    [self initFooterView];
    [self.view addSubview:self.goodsTableview];
    _path=@"success";
    _type=@"wav";
}

-(void)initFooterView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _goodsTableview.height-60)];
    }
    if (!_footerBtn) {
        _footerBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, _footerView.height-60, SCREEN_WIDTH-40, 40)];
        _footerBtn.backgroundColor = MainColor;
        [_footerBtn setTitle:@"确认发单" forState:UIControlStateNormal];
        [_footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _footerBtn.clipsToBounds = YES;
        _footerBtn.layer.cornerRadius = 10;
        [_footerBtn addTarget:self action:@selector(footerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:_footerBtn];
    }
}

#pragma mark -----确认发单
-(void)footerBtnClick{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets=false;
    self.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    // 获取订单信息
//    [self getScannerListInfor];
    [_session startRunning];

}

-(void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    [_session stopRunning];
}

#pragma mark------------- 获取订单列表----------------
//-(void)getScannerListInfor{
//
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    
//    NSData *userData = [userDefault objectForKey:UserKey];
//    
//    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
//    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
//        return ;
//    }
//    NSString *hamcString = [[communcat sharedInstance] hmac:@"" withKey:userInfoModel.primary_key];
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        [[communcat sharedInstance] getOrderScanListInfoWithkey:userInfoModel.key degist:hamcString resultDic:^(NSDictionary *dic) {
//           
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//            DLog(@"最大胆量%@",dic);
//            
//            int code=[[dic objectForKey:@"code"] intValue];
//            
//            if (!dic)
//            {
//                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
//                
//            }else if (code == 1000)
//            {
//                NSDictionary * data =[dic objectForKey:@"data"];
//                NSArray *array = [data objectForKey:@"order_ids"];
//                for(NSDictionary *result in array){
//                    NSString *order_original_id = [result objectForKey:@"order_original_id"];
//                
//                    [_goodsArray addObject:order_original_id];
//                    
//                    [self.goodsTableview reloadData];
//                }
//            }else{
//                
//                [[iToast makeText:[dic objectForKey:@"message"]] show];
//            }
//        }];
//    });
//}

#pragma mark 语音播放
-(void)playAudio{
    NSString *string = [[NSBundle mainBundle] pathForResource:@"success" ofType:@"wav"];
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
}

//初始化table
-(UITableView *)inithomeTableView
{
    _goodsArray = [NSMutableArray array];
    
    if (_goodsTableview != nil) {
        return _goodsTableview;
    }
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 320.0;
    rect.size.width = self.view.frame.size.width;
    rect.size.height = self.view.frame.size.height-320-64;
    
    self.goodsTableview = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    
    _goodsTableview.delegate = self;
    _goodsTableview.dataSource = self;
    _goodsTableview.backgroundColor =  [UIColor whiteColor];
    _goodsTableview.showsVerticalScrollIndicator = NO;
   _goodsTableview .separatorStyle = UITableViewCellSeparatorStyleNone;
    self.goodsTableview.rowHeight = 50;
    
    return _goodsTableview;
}

#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_goodsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScannerListTableViewCell *cell= [ScannerListTableViewCell tempTableViewCellWith:tableView indexPath:indexPath msg:_goodsArray];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.cancelOrderBtn.tag = indexPath.row;
    return cell;
}

//导航栏左右侧按钮点击
- (void)leftItemClick

{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-------------取消订单-----------------------

//取消单号
- (void)cancelOrderWithIndex:(NSInteger)index
{
    _index = index;
    CustomAlertView *alerltView =[[CustomAlertView alloc]initWithTitle:@"用户提示:\n是否删除已扫描订单" message:@"" cancelBtnTitle:@"否" otherBtnTitle:@"是" clickIndexBlock:^(NSInteger clickIndex) {
        if(clickIndex == 200){
            _order_id = _goodsArray[_index];//获取单号
            
            [self.goodsArray removeObjectAtIndex:_index];
            if (self.goodsArray.count == 0) {
                [_footerBtn removeFromSuperview];
            }
//            [self cancelOrderList];//取消接口
            [_goodsTableview reloadData];
        }
    }];
    
    [alerltView showLXAlertView];//显示
}

#pragma mark --------取消订单
//-(void)cancelOrderList{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    
//    NSData *userData = [userDefault objectForKey:UserKey];
//    
//    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
//    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
//        return ;
//    }
//    
//    NSString *hamcString = [[communcat sharedInstance] hmac:[NSString stringWithFormat:@"%@",_order_id] withKey:userInfoModel.primary_key];
//    
//    In_orderScanModel *InModel = [[ In_orderScanModel alloc]init];
//    InModel.key = userInfoModel.key;
//    InModel.digest = hamcString;
//    
//    InModel.order_id = [NSString stringWithFormat:@"%@",_order_id];
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [[communcat sharedInstance]cancelOrderWithMsg:InModel resultDic:^(NSDictionary *dic) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            DLog(@"列表数据%@",dic);
//            
//            int code=[[dic objectForKey:@"code"] intValue];
//            
//            if (!dic)
//            {
//                [[iToast makeText:@"网络不给力,请稍后重试!"] show];
//                
//            }
//            else if (code ==1000)
//            {
//                [[iToast makeText:@"取消成功"] show];
//                
//                
//            }else{
//                [[iToast makeText:[dic objectForKey:@"message"]] show];
//            }
//        }];
//    });
//}
//

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5+2*num, SWidth-10,1);
        
        if (num ==(int)(( SWidth-10)/2)) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame =CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5+2*num, SWidth-10,1);
        
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    // 1.获取屏幕的frame
    CGRect viewRect = self.view.frame;
    // 2.获取扫描容器的frame
    CGRect containerRect = imageView.frame;
    
    CGFloat x = containerRect.origin.y / viewRect.size.height;
    CGFloat y = containerRect.origin.x / viewRect.size.width;
    
    CGFloat width = containerRect.size.height / viewRect.size.height;
    
    CGFloat height = containerRect.size.width / viewRect.size.width;
    
    _output.rectOfInterest = CGRectMake(x, y, width, height);
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResize;
    _preview.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    [self.view bringSubviewToFront:imageView];
    
    [self setOverView];
    
    // 7.添加容器图层
    [self.view.layer addSublayer:self.layer];
    self.layer.frame = self.view.bounds;

    // Start
    [_session startRunning];
    
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate返回数据
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;//获取扫描结果
        [_session stopRunning];
        [self.layer removeFromSuperlayer];
    }
    
    if (!stringValue || [stringValue isEqualToString:@""]) {
        return;
    }
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    BOOL isHaving = NO;
    for (int i = 0; i < [_goodsArray count]; i++) {
        NSString *temp = [_goodsArray objectAtIndex:i];
        if (!isHaving) {
            if ([temp isEqualToString:stringValue]) {
                isHaving = YES;
                
            }else{
                isHaving = NO;
                
            }
        }
    }
    if (isHaving) {
        
//        [[iToast makeText:@"该单已扫入成功,不可重复扫描!"] show];
         [_session startRunning];
    }else
    {
        _order_id = stringValue;
//        [_session stopRunning];

        if(![_goodsArray containsObject:_order_id]){
            [_goodsArray insertObject:_order_id atIndex:_goodsArray.count];
        }
        if (self.goodsArray.count > 0) {
            self.goodsTableview.tableFooterView = _footerView;
        }
        
        [self.goodsTableview reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.goodsArray.count -1 inSection:0];
        [self.goodsTableview scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionBottom) animated:NO];
        
        
//        [self scanOrderList];//上传数据到服务器
        
    }
}

#pragma mark--------------------订单扫描----------------------
//-(void)scanOrderList{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSData *userData = [userDefault objectForKey:UserKey];
//    
//    UserInfoSaveModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
//    
//    if (userInfoModel.key.length == 0 || [userInfoModel.key isEqualToString:@""]) {
//        return ;
//    }
//
//    NSString *hamcString = [[communcat sharedInstance] hmac:[NSString stringWithFormat:@"%@",_order_id] withKey:userInfoModel.primary_key];
//    
//    In_orderScanModel *InModel = [[ In_orderScanModel alloc]init];
//    InModel.key = userInfoModel.key;
//    InModel.digest = hamcString;
//    
//    InModel.order_id = [NSString stringWithFormat:@"%@",_order_id];
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [[communcat sharedInstance]orderScanWithMsg:InModel resultDic:^(NSDictionary *dic) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            int code =[[dic objectForKey:@"code"] intValue];
//            
//            if (!dic){
//                [[[[iToast makeText:@"网络不给力,请稍后重试!"]setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
//                [_session startRunning];
//            }
//            else if (code == 1000){
//                [self playAudio];
//                [[[[iToast makeText:@"扫描成功"]setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
//                if(![_goodsArray containsObject:_order_id]){
//                    [_goodsArray insertObject:_order_id atIndex:_goodsArray.count];
//                }
//                [self.goodsTableview reloadData];
//                
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.goodsArray.count -1 inSection:0];
//                [self.goodsTableview scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionBottom) animated:NO];
//
//                
//                [_session startRunning];
//                
//            }else{
//                [[[[iToast makeText:[dic objectForKey:@"message"]]setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
//                [_session startRunning];
//               
//            }
//        }];
//    });
//}

#pragma mark - 添加模糊效果
- (void)setOverView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = 320;
    
    CGFloat x = CGRectGetMinX(imageView.frame);
    CGFloat y = CGRectGetMinY(imageView.frame);
    CGFloat w = CGRectGetWidth(imageView.frame);
    CGFloat h = CGRectGetHeight(imageView.frame);
    
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(0, y + h, width, height - y - h)];
    [self creatView:CGRectMake(x + w, y, width - x - w, h)];
}

- (void)creatView:(CGRect)rect {
    CGFloat alpha = 0.5;
    UIColor *backColor = [UIColor grayColor];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self.view addSubview:view];
}

@end
