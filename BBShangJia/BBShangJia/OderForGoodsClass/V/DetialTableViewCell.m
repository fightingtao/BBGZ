//
//  DetialTableViewCell.m
//  BBShangJia
//
//  Created by 李志明 on 17/2/27.
//  Copyright  2017年 CYT. All rights reserved.
//

#import "DetialTableViewCell.h"
#import "PublicSouurce.h"
#define DotViewCentX 20//圆点中心 x坐标
#define VerticalLineWidth 2//时间轴 线条 宽度
#define ShowLabTop 46//cell间距
#define ShowLabWidth ([UIScreen mainScreen].bounds.size.width - DotViewCentX - 20)

#define ShowLabFont [UIFont systemFontOfSize:15]

@implementation DetialTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _verticalLineTopView = [[UIView alloc] init];
        _verticalLineTopView.backgroundColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0];//圆点上边的线
        [self.contentView addSubview:_verticalLineTopView];
        int dotViewRadius = 7.5;
        _dotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dotViewRadius * 2, dotViewRadius * 2)];
        _dotView.backgroundColor = [UIColor greenColor];
        _dotView.layer.cornerRadius = dotViewRadius;
        [self.contentView addSubview:_dotView];
        
        _verticalLineBottomView = [[UIView alloc] init];//下边的线
        _verticalLineBottomView.backgroundColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0];
        [self.contentView addSubview:_verticalLineBottomView];
        //时间
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_timeLabel];
        
        //内容
        _showLabel = [[UILabel alloc] init];
        _showLabel.font = ShowLabFont;
        _showLabel.numberOfLines = 0;
        _showLabel.textAlignment = NSTextAlignmentLeft;
        _showLabel.textColor = [UIColor blackColor];
        _showLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:_showLabel];
        
        _status = [[UILabel alloc] init];
        _status.font = ShowLabFont;
        _status.numberOfLines = 0;
        _status.textAlignment = NSTextAlignmentLeft;
        _status.textColor = [UIColor blackColor];
        _status.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:_status];
        
    }
    return self;
}


- (void)setFrame:(CGRect)frame{
    super.frame = frame;
    //20  10
    _dotView.center = CGPointMake(DotViewCentX, ShowLabTop );
    int cutHeight = _dotView.frame.size.height/2.0 ;
    _verticalLineTopView.frame = CGRectMake(DotViewCentX - VerticalLineWidth/2.0, 0, VerticalLineWidth, _dotView.center.y - cutHeight);
    _verticalLineBottomView.frame = CGRectMake(DotViewCentX - VerticalLineWidth/2.0, _dotView.center.y + cutHeight, VerticalLineWidth, frame.size.height - (_dotView.center.y + cutHeight));
    _timeLabel.frame = CGRectMake(35,15,200,15);
}

//正常签收
- (void)setDataSource:(NSString *)content date:(NSString*)time   isFirst:(BOOL)isFirst isLast:(BOOL)isLast {
    
    _showLabel.text = content;
    _timeLabel.text = time;
    // 1.文字的最大尺寸
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT);
    // 2.计算文字的高度
    CGFloat textH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    _showLabel.frame =CGRectMake(35,36,SCREEN_WIDTH-70,textH);
    [_showLabel sizeToFit];
    
    _verticalLineTopView.hidden = isFirst;
    _verticalLineBottomView.hidden = isLast;
    _dotView.backgroundColor = isLast ?[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0]:[UIColor colorWithRed:0/255.0 green:170/255.0 blue:40/255.0 alpha:1.0];
    _showLabel.textColor = isLast ? [UIColor blackColor]: [UIColor colorWithRed:0/255.0 green:170/255.0 blue:40/255.0 alpha:1.0];
    self.height = _showLabel.height +60;
}

//异常-物流详情-cell
- (void)setExptDataSource:(NSString *)content date:(NSString*)time  nextTime:(NSString *)nextTime isFirst:(BOOL)isFirst isLast:(BOOL)isLast {
    NSMutableAttributedString *string;
    _status.frame = CGRectMake(_timeLabel.x, _timeLabel.y+_timeLabel.height+6, 200, 20);
    if(nextTime.length >0) {
        string = [[NSMutableAttributedString alloc]initWithString:@"订单状态: 滞留"];
    }else{
        string = [[NSMutableAttributedString alloc]initWithString:@"订单状态: 拒收"];
    }

    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,5)];
   
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,2)];
    
    _status.attributedText = string;
    
    // 1.文字的最大尺寸
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT);
    content=[content stringByReplacingOccurrencesOfString:@"\n" withString:@"" ];
    time=[time stringByReplacingOccurrencesOfString:@"\n" withString:@"" ];
    NSString *list;
    if (nextTime.length>0){
        NSString *stringTmp=[nextTime substringWithRange:NSMakeRange(0, 10)];
        stringTmp = [time stringByReplacingOccurrencesOfString:@"-" withString:@"/" ];
        list =[NSString stringWithFormat:@"异常说明: %@，请于%@重新配送\n此订单费用将于今晚24:00前返回您的账户",content ,stringTmp];
        _showLabel.text = list;
        // 2.计算文字的高度
        CGFloat textH1 = [list boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
        _showLabel.frame =CGRectMake(_status.x,_status.y+_status.height+5,SCREEN_WIDTH-50,textH1);
        [_showLabel sizeToFit];
    }
    else
    {
        list =[NSString stringWithFormat:@"此订单费用将于今晚24:00前返回您的账户"];
       _showLabel.text = list;
        // 2.计算文字的高度
        CGFloat textH1 = [list boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
        _showLabel.frame =CGRectMake(_status.x,_status.y+_status.height+5,SCREEN_WIDTH-50,textH1);
        [_showLabel sizeToFit];
        [_showLabel sizeToFit];
    }
    NSMutableAttributedString *string2=[[NSMutableAttributedString alloc]initWithString:list];
    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    
    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, list.length-21)];
    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] range:NSMakeRange(list.length-21, 21)];
    [string2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(list.length-21, 21)];
    //设置行间距
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:6];
    [string2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [list length])];
    _showLabel.attributedText = string2;
    _timeLabel.text = time;
    _verticalLineTopView.hidden = isFirst;
    _verticalLineBottomView.hidden = isLast;
    _dotView.backgroundColor = isLast ? [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0]:[UIColor colorWithRed:247/255.0 green:35/255.0 blue:42/255.0 alpha:1.0];
    
}


+ (CGFloat)cellHeightWithString:(NSString *)str{
    
    // 1.文字的最大尺寸
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT);
    // 2.计算文字的高度
    CGFloat textH = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    return textH +60;
}

@end
