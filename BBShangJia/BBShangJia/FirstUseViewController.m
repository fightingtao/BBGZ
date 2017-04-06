//
//  FirstUseViewController.m
//  SendMessage
//
//  Created by 李志明 on 16/8/31.
//  Copyright © 2016年 李志明. All rights reserved.
//

#import "FirstUseViewController.h"

#define imgCount 3
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface FirstUseViewController()<UIScrollViewDelegate>
{
    // 用于判断上下方向
    CGFloat _directY;
}
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UILabel *showLable;
@property (nonatomic,strong)UIImageView *img;
@end

@implementation FirstUseViewController



-(void)viewDidLoad{
    [super viewDidLoad];
    _directY=0;
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        _scrollView.bounces = NO;
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH*imgCount, SCREENHEIGHT);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate=self;
        [self.view addSubview:_scrollView];
    }
    for (NSInteger i = 1; i <= imgCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH*(i-1), 0, SCREENWIDTH, SCREENHEIGHT)];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld引导",(long)i]];
        [_scrollView addSubview:imageView];
        
        if (i == imgCount ){

            UIButton *btn = [[UIButton alloc]initWithFrame:self.view.frame];
//             [btn setTitle:@"立即体验" forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:btn];

        }
    }
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((SCREENHEIGHT-100)/2, SCREENHEIGHT-40,100, 40)];
    _pageControl.center = CGPointMake(SCREEN_WIDTH/2, SCREENHEIGHT-60);
    _pageControl.numberOfPages = imgCount;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = MainColor;
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.6431 green:0.6667 blue:0.7059 alpha:1.0];
    [self.view addSubview:_pageControl];

}

-(void)btnClick{
    
    if ([self.delegate respondsToSelector:@selector(goToMainView)]) {
        [self.delegate goToMainView];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    _pageControl.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    if (scrollView.contentOffset.x>(imgCount-2)*SCREENWIDTH) {
        [self.delegate goToMainView];

    }
    else{
//         NSLog(@"辅导88888888888费方法");
    }
}
@end
