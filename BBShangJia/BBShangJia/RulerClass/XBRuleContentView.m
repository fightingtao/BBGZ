//
//  XBRuleContentView.m
//  XBRuleView
//
//  Created by XB on 2016/10/30.
//  Copyright © 2016年 少先队. All rights reserved.
//
#import "PublicSouurce.h"
#import "XBRuleContentView.h"

@interface XBRuleContentView()

@property (nonatomic ,assign) CGFloat minScale;
@property (nonatomic ,assign) CGFloat minScaleWidth;
@property (nonatomic ,assign) CGFloat minValue;
@property (nonatomic ,assign) CGFloat maxValue;

@property (nonatomic ,assign) CGFloat startIndex;

@property (nonatomic ,strong) UIColor *shortSymbolColor;
@property (nonatomic ,strong) UIColor *middleSymbolColor;
@property (nonatomic ,strong) UIColor *longSymbolColor;
@property (nonatomic ,strong) UIColor *textColor;

@property (nonatomic ,assign) CGFloat shortSymbolHeight;
@property (nonatomic ,assign) CGFloat middleSymbolHeight;
@property (nonatomic ,assign) CGFloat longSymbolHeight;
@property (nonatomic ,strong) UIFont *textFont;
@property (nonatomic ,assign) XBRuleType ruleType;


@end

@implementation XBRuleContentView

-(instancetype)initWithFrame:(CGRect)frame
                    minScale:(CGFloat)minScale
               minScaleWidth:(CGFloat)minScaleWidth
                     minVale:(CGFloat)minValue
                    maxValue:(CGFloat)maxVale
                  startIndex:(CGFloat)startIndex
            shortSymbolColor:(UIColor *)shortSymbolColor
           middleSymbolColor:(UIColor *)middleSymbolColor
             longSymbolColor:(UIColor *)longSymbolColor
           shortSymbolHeight:(CGFloat)shortSymbolHeight
          middleSymbolHeight:(CGFloat)middleSymbolHeight
            longSymbolHeight:(CGFloat)longSymbolHeight
                   textColor:(UIColor *)textColor
                    textFont:(UIFont *)textFont
                    ruleType:(XBRuleType)ruleType{
    
    if (self = [super initWithFrame:frame]) {
        self.minScale = minScale;
        self.minScaleWidth = minScaleWidth;
        self.minValue = minValue;
        self.maxValue = maxVale;
        self.startIndex = startIndex;
        self.shortSymbolColor = shortSymbolColor;
        self.middleSymbolColor = middleSymbolColor;
        self.longSymbolColor = longSymbolColor;
        self.shortSymbolHeight = shortSymbolHeight;
        self.middleSymbolHeight = middleSymbolHeight;
        self.longSymbolHeight = longSymbolHeight;
        self.textColor = textColor;
        self.textFont = textFont;
        self.ruleType = ruleType;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    if (self.ruleType == XBRuleTypeVertical) {
        [self drawSubviewsWhenVerticalWithRect:rect];
    }else{
        [self drawSubviewsWhenHorizontalWithRect:rect];
    }
}

//华垂直的标尺
-(void)drawSubviewsWhenVerticalWithRect:(CGRect)rect{
    
    UIImage *longSymbolDotImage = [self imageWithColor:self.longSymbolColor size:CGSizeMake(1, 1)];
    UIImage *middleSymbolDotImage = [self imageWithColor:self.middleSymbolColor size:CGSizeMake(1, 1)];
    UIImage *shortSymbolDotImage = [self imageWithColor:self.shortSymbolColor size:CGSizeMake(1, 1)];
    
    for (int i = 0; i <= (_maxValue - _minValue) / _minScale; i++) {
        
        if (i % 10 == 0 ) {
            CGRect scaleFrame = CGRectMake(0, _startIndex + i*_minScaleWidth, _longSymbolHeight, 1);
            [longSymbolDotImage drawInRect:scaleFrame];
            
            NSString *text = [NSString stringWithFormat:@"%.0f",_minValue + i * _minScale];
            CGSize textSize = [self textSizeWithFont:self.textFont text:text];
            NSDictionary *attributes = @{NSFontAttributeName:_textFont, NSForegroundColorAttributeName: _textColor};
            [text drawInRect:CGRectMake(rect.size.width - textSize.width,scaleFrame.origin.y - textSize.height/2.0, textSize.width, textSize.height) withAttributes:attributes];
            
        }else if(i % 5 == 0){
            
            [middleSymbolDotImage drawInRect:CGRectMake(0, _startIndex + i*_minScaleWidth, _middleSymbolHeight, 1)];
            
        }else{
            
            
            
            [shortSymbolDotImage drawInRect:CGRectMake(0, _startIndex + i*_minScaleWidth, _shortSymbolHeight, 1)];
            
        }
    }
}
//画水平尺子
-(void)drawSubviewsWhenHorizontalWithRect:(CGRect)rect{
    UIImage *longSymbolDotImage = [self imageWithColor:[UIColor grayColor] size:CGSizeMake(1, 1)];
    UIImage *shortSymbolDotImage = [self imageWithColor:[UIColor grayColor] size:CGSizeMake(1, 1)];
    
    for (int i = 0; i <= 45; i++) {
        
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60*(45 -i)sinceDate:currentDate ];//前一天
        NSString *dateString = [dateFormatter stringFromDate:lastDay];
        
        if ([[dateString substringToIndex:1] isEqualToString:@"0"]) {
            dateString = [dateString substringFromIndex:1];
        }
        if ([[dateString substringFromIndex:2] isEqualToString:@"01"] || [[dateString substringFromIndex:3] isEqualToString:@"15"]){
            
            CGRect scaleFrame = CGRectMake(_startIndex + i*_minScaleWidth, 0, 1, _longSymbolHeight);
            [longSymbolDotImage drawInRect:scaleFrame];
            CGSize textSize = [self textSizeWithFont:self.textFont text:dateString];
            NSDictionary *attributes = @{NSFontAttributeName:_textFont, NSForegroundColorAttributeName: [UIColor blackColor]};
            [dateString drawInRect:CGRectMake(scaleFrame.origin.x - textSize.width/2.0, rect.size.height - textSize.height, textSize.width, textSize.height) withAttributes:attributes];
        }
        for (NSString *dateTmp in self.array) {
           
            if ([dateTmp isEqualToString:dateString]) {
             
                CGRect scaleFrame = CGRectMake(_startIndex + i*_minScaleWidth, 0, 1, _shortSymbolHeight);
                [longSymbolDotImage drawInRect:scaleFrame];
                longSymbolDotImage = [self imageWithColor:[UIColor redColor] size:CGSizeMake(1, 1)];
                shortSymbolDotImage = [self imageWithColor:[UIColor redColor] size:CGSizeMake(1, 1)];//MainColor
                [shortSymbolDotImage drawInRect:CGRectMake(_startIndex + i*_minScaleWidth, 0, 1, _shortSymbolHeight)];

            }else{
                longSymbolDotImage = [self imageWithColor:[UIColor grayColor] size:CGSizeMake(1, 1)];
                shortSymbolDotImage = [self imageWithColor:[UIColor grayColor] size:CGSizeMake(1, 1)];
                [shortSymbolDotImage drawInRect:CGRectMake(_startIndex + i*_minScaleWidth, 0, 1, _shortSymbolHeight)];
            }
        }
        if ([self.array containsObject:dateString]){
            shortSymbolDotImage = [self imageWithColor:[UIColor redColor] size:CGSizeMake(1, 1)];//MainColor
            
            [shortSymbolDotImage drawInRect:CGRectMake(_startIndex + i*_minScaleWidth, 0, 1, _shortSymbolHeight)];
        }else{
            shortSymbolDotImage = [self imageWithColor:[UIColor grayColor] size:CGSizeMake(1, 1)];
            [shortSymbolDotImage drawInRect:CGRectMake(_startIndex + i*_minScaleWidth, 0, 1, _shortSymbolHeight)];
        }
        if (i == 45){
            longSymbolDotImage = [self imageWithColor:[UIColor grayColor] size:CGSizeMake(1, 1)];
            shortSymbolDotImage = [self imageWithColor:[UIColor redColor] size:CGSizeMake(1, 1)];
        }
    }
}
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (CGSize)textSizeWithFont:(UIFont *)font text:(NSString *)text{
    NSMutableParagraphStyle* paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary* attribute = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [text sizeWithAttributes:attribute];
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
    
}

@end
