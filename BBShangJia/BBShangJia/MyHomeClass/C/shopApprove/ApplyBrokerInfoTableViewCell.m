//
//  ApplyBrokerInfoTableViewCell.m
//  CYZhongBao
//
//  Created by xc on 15/11/25.
//  Copyright © 2015年 xc. All rights reserved.
//

#import "ApplyBrokerInfoTableViewCell.h"

@interface ApplyBrokerInfoTableViewCell ()


@end

@implementation ApplyBrokerInfoTableViewCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        if (!_menucontentView) {
            _menucontentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CellViewHeight)];
            [self.contentView addSubview:_menucontentView];
        }
        if (!_nameLabel) {
            _nameLabel = [[UILabel alloc] init];
            _nameLabel.textAlignment = NSTextAlignmentCenter;
            [_nameLabel setTextColor:kTextMainCOLOR];
            [_nameLabel setFont:LittleFont];
            _nameLabel.text = @"真实姓名:";
            [_menucontentView addSubview:_nameLabel];
        }
        
        if (!_nameTextField) {
            _nameTextField = [[UITextField alloc] init];
            _nameTextField.borderStyle = UITextBorderStyleNone;
            _nameTextField.placeholder = @"请输入您的真实姓名";
            _nameTextField.backgroundColor = [UIColor clearColor];
            _nameTextField.clearButtonMode=UITextFieldViewModeAlways;

            _nameTextField.textColor = kTextMainCOLOR;
            _nameTextField.delegate = self;
            _nameTextField.font = LittleFont;
            _nameTextField.returnKeyType = UIReturnKeyDone;
            [_menucontentView addSubview:_nameTextField];
        }
        
        
        
        if (!_phoneLabel) {
            _phoneLabel = [[UILabel alloc] init];
            _phoneLabel.textAlignment = NSTextAlignmentCenter;
            [_phoneLabel setTextColor:kTextMainCOLOR];
            [_phoneLabel setFont:LittleFont];
            _phoneLabel.text = @"意向城市:";
            [_menucontentView addSubview:_phoneLabel];
            
        }
        if (!_right) {
            _right=[[UIImageView alloc]init];
            _right.image=[UIImage imageNamed:@"btn_choice@2x.png"];
            [_menucontentView addSubview:_right];
        }
        
        if ( !_address) {
            _address=[UIButton buttonWithType:UIButtonTypeCustom];
            [_address setTitle:@"请选择城市" forState:UIControlStateNormal];
            [_address setTitleColor:LineColor forState:UIControlStateNormal];
            _address.titleLabel.font=MiddleFont;
            _address.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            // 但是问题又出来，此时文字会紧贴到做边框，我们可以设置
            //            _address.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
            [_address addTarget:self action:@selector(onAddrssClick) forControlEvents:UIControlEventTouchUpInside];
            [_menucontentView addSubview:_address];
        }
        
        
        
        
        
        if (!_idLabel) {
            _idLabel = [[UILabel alloc] init];
            _idLabel.textAlignment = NSTextAlignmentCenter;
            [_idLabel setTextColor:kTextMainCOLOR];
            [_idLabel setFont:LittleFont];
            _idLabel.text = @"身份证号:";
            [_menucontentView addSubview:_idLabel];
        }
        
        if (!_idTextField) {
            _idTextField = [[UITextField alloc] init];
            _idTextField.borderStyle = UITextBorderStyleNone;
            _idTextField.placeholder = @"请输入您的身份证号码";
            _idTextField.backgroundColor = [UIColor clearColor];
            _idTextField.clearButtonMode=UITextFieldViewModeAlways;
            _idTextField.textColor = kTextMainCOLOR;
            _idTextField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
            _idTextField.delegate = self;
            _idTextField.font = LittleFont;
            _idTextField.returnKeyType = UIReturnKeyDone;
            [_menucontentView addSubview:_idTextField];
        }
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40,SCREEN_WIDTH, 0.5)];
        line1.backgroundColor = LineColor;
        [_menucontentView addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 80,SCREEN_WIDTH, 0.5)];
        line2.backgroundColor = LineColor;
        [_menucontentView addSubview:line2];
        
        _nameLabel.sd_layout.leftSpaceToView(_menucontentView,20)
        .topSpaceToView(_menucontentView,10)
        .heightIs(20);
        [_nameLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
        
        _nameTextField.sd_layout.leftSpaceToView(_nameLabel,10)
        .topSpaceToView(_menucontentView,10)
        .rightSpaceToView(_menucontentView,20)
        .heightIs(20);
        
        
        _idLabel.sd_layout.leftSpaceToView(_menucontentView,20)
        .topSpaceToView(line1,10)
        .heightIs(20);
        [_idLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
        
        _idTextField.sd_layout.leftSpaceToView(_idLabel,10)
        .topSpaceToView(line1,10)
        .rightSpaceToView(_menucontentView,20)
        .heightIs(20);
        
        _phoneLabel.sd_layout.leftSpaceToView(_menucontentView,20)
        .topSpaceToView(line2,10)
        .heightIs(20);
        [_phoneLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
        
        _address.sd_layout.leftSpaceToView(_phoneLabel,10)
        .topSpaceToView(line2,10)
        .rightSpaceToView(_menucontentView,10)
        .heightIs(20);
        
        _right.sd_layout.topSpaceToView(line2,10)
        .rightSpaceToView(_menucontentView,20)
        .widthIs(20)
        .heightIs(20);
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)onAddrssClick{
    
    if ([self.delegate respondsToSelector:@selector(choceAddressBtnClick)]) {
         [self.delegate choceAddressBtnClick];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _nameTextField) {
        
        [self.delegate setAgentInfo:_nameTextField.text andType:1];
    }
    else
    {
        if (_idTextField==textField) {
            
            if ([_idTextField.text length] > 23) { //如果输入框内容大于11则弹出警告
               _idTextField .text = [textField.text substringToIndex:22];
            }
        }

        [self.delegate setAgentInfo:_idTextField.text andType:3];
    }
}


+(CGFloat)cellHeight
{
    return CellViewHeight;
}

@end
