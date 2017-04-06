//
//  PersonHeadTableViewCell.m
//  CYZhongBao
//
//  Created by xc on 15/11/24.
//  Copyright © 2015年 xc. All rights reserved.
//

#import "PersonHeadTableViewCell.h"

@implementation PersonHeadTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //各项控件初始化 start
        if (!_titleLable) {
            _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20,0, 50, 40)];
            _titleLable.backgroundColor = [UIColor clearColor];
            _titleLable.font = MiddleFont;
            _titleLable.textColor = kTextMainCOLOR;
            _titleLable.text = @"头像";
            _titleLable.lineBreakMode = NSLineBreakByTruncatingTail;
            _titleLable.textAlignment = NSTextAlignmentLeft;
            [self addSubview:_titleLable];
        }
        
        if (!_contentImg) {
            _contentImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 2.5, 35, 35)];
            _contentImg.image = [UIImage imageNamed:@"nav_leftbar_info"];
            _contentImg.layer.cornerRadius = 17;
            _contentImg.layer.masksToBounds = YES;
            //边框宽度及颜色设置
            [_contentImg.layer setBorderWidth:0.1];
            [_contentImg.layer setBorderColor:[UIColor clearColor].CGColor];
            [self addSubview:_contentImg];
        }
        
        if (!_arrowImg) {
            _arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, 10, 20, 20)];
//            _arrowImg.image = [UIImage imageNamed:@"btn_choice"];
            [self addSubview:_arrowImg];
        }
        //end
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
