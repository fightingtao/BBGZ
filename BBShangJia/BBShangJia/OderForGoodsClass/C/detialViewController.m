//
//  detialViewController.m
//
//
//  Created by 李志明 on 17/3/28.
//
//

#import "detialViewController.h"
#import "PublicSouurce.h"
#import "orderViewModel.h"
#import "orderTableView.h"
@interface detialViewController ()
@property(nonatomic,strong)orderTableView *tableView;
@property(nonatomic,strong)orderViewModel *viewModel;
@end

@implementation detialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"物流详情";
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    self.tabBarController.tabBar.hidden=YES;
    UIButton *leftItem =[UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [[leftItem rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    [self bingViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)bingViewModel{
    self.tableView = [[orderTableView alloc] initWithFrame:self.view.frame];
 
    [self.view addSubview:self.tableView];
    RAC(self.tableView,dataList) = RACObserve(self.viewModel,dataList);
    NSArray *array = [[NSArray alloc] initWithObjects:self.order_id,self.tableView, nil];
    [self.viewModel.dataCommand execute:array];
}

-(orderViewModel*)viewModel{
    if (!_viewModel) {
        _viewModel = [[orderViewModel alloc] init];
    }
    return _viewModel;
}

@end
