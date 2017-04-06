//
//  PersonOtherInfoTableViewCell.m
//  CYZhongBao
//
//  Created by xc on 15/11/24.
//  Copyright © 2015年 xc. All rights reserved.
//

#import "PersonOtherInfoTableViewCell.h"
#define TextCOLOR [UIColor colorWithRed:0.6235 green:0.6235 blue:0.6235 alpha:1.0]

@implementation PersonOtherInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //各项控件初始化 start
        if (!_titleLable) {
            _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20,0, 120, 40)];
            _titleLable.backgroundColor = [UIColor clearColor];
            _titleLable.font = MiddleFont;
            _titleLable.textColor = kTextMainCOLOR;
            _titleLable.text = @"需求类型";
            _titleLable.lineBreakMode = NSLineBreakByTruncatingTail;
            _titleLable.textAlignment = NSTextAlignmentLeft;
            [self addSubview:_titleLable];
        }
        
        if (!_contentLable) {
            _contentLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-35,0, SCREEN_WIDTH/2, 40)];
            _contentLable.backgroundColor = [UIColor clearColor];
            _contentLable.font = LittleFont;
            _contentLable.textColor = kTextMainCOLOR;
            _contentLable.text = @"";
            _contentLable.lineBreakMode = NSLineBreakByTruncatingTail;
            _contentLable.textAlignment = NSTextAlignmentRight;
            [self addSubview:_contentLable];
        }
        
        if (!_versionLabel) {
            _versionLabel = [[UILabel alloc]init];
            _versionLabel.backgroundColor = [UIColor clearColor];
            _versionLabel.font = LittleFont;
            _versionLabel.textColor = TextCOLOR;
            _versionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _versionLabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:_versionLabel];
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

- (void)CurrentVersion
{
    _versionLabel.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 40, 40);
    _versionLabel.text = @"V1.0";
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
