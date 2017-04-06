//
//  ApplyBrokerImgTableViewCell.m
//  CYZhongBao
//
//  Created by xc on 15/11/25.
//  Copyright © 2015年 xc. All rights reserved.
//

#import "ApplyBrokerImgTableViewCell.h"

@implementation ApplyBrokerImgTableViewCell

@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        if (!_menucontentView) {
            _menucontentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ImgCellViewHeight)];
            _menucontentView.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:_menucontentView];
        }
        
        if (!_tempImg) {
            _tempImg = [[UIImageView alloc] initWithFrame:CGRectMake(ImgBackWidth, 20, ImgWidth, ImgHeight)];
            _tempImg.image = [UIImage imageNamed:@"FrontIdImg.png"];
            [_menucontentView addSubview:_tempImg];
        }
        
        if (!_idImg) {
            _idImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-ImgBackWidth-ImgWidth, 20, ImgWidth, ImgHeight)];
            _idImg.image = [UIImage imageNamed:@"AddIdImg.png"];
            _idImg.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(idImg1Click)];
            _idImg.backgroundColor =[UIColor clearColor];
            [_idImg addGestureRecognizer:singleTap];
            [_menucontentView addSubview:_idImg];
        }
        
        if (!_tempImg2) {
            _tempImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(ImgBackWidth, ImgHeight+35, ImgWidth, ImgHeight)];
            _tempImg2.image = [UIImage imageNamed:@"BackIdImg.png"];
            [_menucontentView addSubview:_tempImg2];
        }
        
        if (!_idImg2) {
            _idImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-ImgBackWidth-ImgWidth, ImgHeight+35, ImgWidth, ImgHeight)];
            _idImg2.image = [UIImage imageNamed:@"AddIdImg.png"];
        
            _idImg2.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(idImg2Click)];
            _idImg2.backgroundColor =[UIColor clearColor];
            [_idImg2 addGestureRecognizer:singleTap];
            [_menucontentView addSubview:_idImg2];
        }
        if (!_tempImg3) {
            _tempImg3 = [[UIImageView alloc] initWithFrame:CGRectMake(ImgBackWidth, ImgHeight*2+50, ImgWidth, ImgHeight)];
            _tempImg3.image = [UIImage imageNamed:@"HandIdImg.png"];
            [_menucontentView addSubview:_tempImg3];
        }
        
        if (!_idImg3) {
            _idImg3 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-ImgBackWidth-ImgWidth, ImgHeight*2+50, ImgWidth, ImgHeight)];
            _idImg3.backgroundColor =[UIColor clearColor];
            _idImg3.image = [UIImage imageNamed:@"AddIdImg.png"];
            _idImg3.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(idImg3Click)];
            [_idImg3 addGestureRecognizer:singleTap];
            [_menucontentView addSubview:_idImg3];
        }
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

+(CGFloat)cellHeight
{
    return ImgCellViewHeight;
}

- (void)refreshIdImgWithType:(int)type andIdImg:(UIImage*)img
{
    if (type == 1)
    {
        _idImg.image = img;
        
    }else if (type == 2)
    {
        _idImg2.image = img;
        
    }else if (type == 3)
    {
        _idImg3.image = img;
    }
}

- (void)idImg1Click
{
    if ([self.delegate respondsToSelector:@selector(idImgChoose:)]) {
        [self.delegate idImgChoose:1];
    }
}

- (void)idImg2Click
{
    if ([self.delegate respondsToSelector:@selector(idImgChoose:)]) {
        [self.delegate idImgChoose:2];
    }
}


- (void)idImg3Click
{
    if ([self.delegate respondsToSelector:@selector(idImgChoose:)]) {
        [self.delegate idImgChoose:3];
    }
}

@end
