//
//  XBRuleView.h
//  XBRuleView
//
//  Created by XB on 2016/10/30.
//  Copyright © 2016年 少先队. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBRuleContentView.h"
@protocol RuleEndScrollDelegate <NSObject>
-(void)ruleEndScroll:(int)index scroll:(UIScrollView *)scrollView;
@end

@interface XBRuleView : UIView

-(instancetype)initWithFrame:(CGRect)frame ruleType:(XBRuleType)ruleType;
@property(assign ,nonatomic)int indexP;
@property (weak, nonatomic) id<RuleEndScrollDelegate> delegate;
@property (nonatomic ,strong) UIColor *shortSymbolColor;
@property (nonatomic ,assign) CGFloat shortSymbolHeight;
@property (nonatomic ,strong) UIColor *middleSymbolColor;
@property (nonatomic ,assign) CGFloat middleSymbolHeight;
@property (nonatomic ,strong) UIColor *longSymbolColor;
@property (nonatomic ,assign) CGFloat longSymbolHeight;
@property (nonatomic ,strong) UIColor *textColor;
@property (nonatomic ,strong) UIFont  *textFont;
@property(nonatomic,strong)NSMutableArray *dalist;

-(void)setRangeFrom:(NSInteger)minVale to:(NSInteger)maxValue minScale:(CGFloat)minScale minScaleWidth:(CGFloat)minScaleWidth;

@property (nonatomic ,assign) CGFloat currentValue;

@end
